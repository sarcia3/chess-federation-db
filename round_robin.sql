CREATE OR REPLACE FUNCTION generate_round_robin_games(p_tournament_id INTEGER)
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
   start_date int;
BEGIN
    SELECT ARRAY_AGG(player_id ORDER BY player_id) INTO players_arr
    FROM tournament_players WHERE tournament_id = p_tournament_id;
    IF players_arr IS NULL OR array_length(players_arr, 1) < 2 THEN 
       RAISE EXCEPTION 'Tournament must have at least 2 players';
    END IF;

    SELECT date_from INTO start_date
    FROM tournaments WHERE tournament_id = p_tournament_id;
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
    DELETE FROM games WHERE tournament_id = p_tournament_id AND result IS NULL;
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
