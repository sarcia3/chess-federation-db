CREATE OR REPLACE FUNCTION generate_round_robin_games(p_tournament_id int)
RETURNS VOID AS 
$$
DECLARE
   players_arr int[];
   n int;
   rounds int;
   half_n int;
   r int;
   i int;
   p1 int;
   p2 int;
   white_id int;
   black_id int;
   tmp int;
   start_date date;
BEGIN
    SELECT ARRAY_AGG(tp.player_id ORDER BY tp.player_id) INTO players_arr
    FROM tournament_players tp WHERE tp.tournament_id = p_tournament_id;
    IF players_arr IS NULL OR array_length(players_arr, 1) < 2 THEN 
       RAISE EXCEPTION 'Tournament must have at least 2 players';
    END IF;

    SELECT t.date_from INTO start_date
    FROM tournaments t WHERE t.tournament_id = p_tournament_id;
    IF start_date IS NULL THEN
       RAISE EXCEPTION 'Tournament % does not exist', p_tournament_id;
    END IF;

    -- if uneven players number
    IF array_length(players_arr, 1) % 2 = 1 THEN
       players_arr := players_arr || NULL;
    END IF;

    n := array_length(players_arr, 1);
    rounds := n - 1;
    half_n := n / 2;

    -- to not generate the same thing twice
    DELETE FROM games g WHERE g.tournament_id = p_tournament_id AND g.result IS NULL;
    FOR r IN 1..rounds LOOP
        FOR i IN 1..half_n LOOP
           p1 := players_arr[i];
           p2 := players_arr[n - i + 1];
           
           IF p1 IS NOT NULL AND p2 IS NOT NULL THEN
            -- changing the colour beetween rounds
            IF r % 2 = 1 THEN
              white_id := p1;
              black_id := p2;
            ELSE
              white_id := p2;
              black_id := p1;
            END IF;

            INSERT INTO games (
               tournament_id,
               white_player_id,
               black_player_id,
               result,
               date,
               round_number,
               pgn
             )
            VALUES (
               p_tournament_id,
               white_id,
               black_id,
               NULL,
               start_date + (r - 1),
               r,
               NULL
             );
            END IF;
        END LOOP;

        -- we rotate the players: the first one is still the rest circles
        tmp := players_arr[n];

        FOR i IN REVERSE n..3 LOOP
           players_arr[i] := players_arr[i - 1];
        END LOOP;

        players_arr[2] := tmp;
    END LOOP;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION tournament_standings(p_tournament_id int)
RETURNS TABLE (
    player_id int,
    first_name varchar,
    last_name varchar,
    games_played bigint,
    points numeric,
    wins bigint,
    draws bigint,
    losses bigint,
    buchholz numeric,
    sonneborn_berger numeric
) AS 
$$
BEGIN
    RETURN QUERY
    WITH player_games AS (
        SELECT g.white_player_id AS player_id, g.black_player_id AS opponent_id, g.result AS player_score
        FROM games g
        WHERE g.tournament_id = p_tournament_id AND g.result IS NOT NULL
        UNION ALL

        SELECT g.black_player_id AS player_id,g.white_player_id AS opponent_id, 1 - g.result AS player_score
        FROM games g
        WHERE g.tournament_id = p_tournament_id AND g.result IS NOT NULL
    ),

    points_table AS (
        SELECT pg.player_id, COUNT(*) AS games_played, SUM(pg.player_score) AS points, COUNT(*) FILTER (WHERE pg.player_score = 1) AS wins, COUNT(*) FILTER (WHERE pg.player_score = 0.5) AS draws, COUNT(*) FILTER (WHERE pg.player_score = 0) AS losses
        FROM player_games pg
        GROUP BY pg.player_id
    ),

    tie_breaks AS (
        SELECT pg.player_id, SUM(opp.points) AS buchholz, SUM(CASE
                    WHEN pg.player_score = 1 THEN opp.points
                    WHEN pg.player_score = 0.5 THEN opp.points / 2
                    ELSE 0
                END
            ) AS sonneborn_berger
        FROM player_games pg JOIN points_table opp ON (opp.player_id = pg.opponent_id)
        GROUP BY pg.player_id
    )

    SELECT pl.player_id, p.first_name, p.last_name, COALESCE(pt.games_played, 0) AS games_played, COALESCE(pt.points, 0) AS points, COALESCE(pt.wins, 0) AS wins, COALESCE(pt.draws, 0) AS draws, COALESCE(pt.losses, 0) AS losses, COALESCE(tb.buchholz, 0) AS buchholz, COALESCE(tb.sonneborn_berger, 0) AS sonneborn_berger
    FROM tournament_players tp
    JOIN players pl ON (pl.player_id = tp.player_id)
    JOIN persons p ON (p.person_id = pl.person_id)
    LEFT JOIN points_table pt ON (pt.player_id = pl.player_id)
    LEFT JOIN tie_breaks tb ON (tb.player_id = pl.player_id)
    WHERE tp.tournament_id = p_tournament_id
    ORDER BY COALESCE(pt.points, 0) DESC, COALESCE(tb.sonneborn_berger, 0) DESC, COALESCE(tb.buchholz, 0) DESC, p.last_name;
END;
$$ LANGUAGE plpgsql;