CREATE FUNCTION FIDE_scoring_probability (first_rating INTEGER, second_rating INTEGER)
    RETURNS NUMERIC(3, 2)AS $$
DECLARE
    rating_diff INTEGER;
BEGIN
    IF first_rating < second_rating THEN
        RETURN 1-FIDE_scoring_probability(second_rating, first_rating);
    END IF;

    rating_diff = LEAST(first_rating - second_rating, 400); --400-point rule.
    --TODO change later to only be counted once/tournament
    RETURN CASE
               WHEN rating_diff >= 0 AND rating_diff <= 3 THEN 0.50
               WHEN rating_diff >= 4 AND rating_diff <= 10 THEN 0.51
               WHEN rating_diff >= 11 AND rating_diff <=  17 THEN 0.52
               WHEN rating_diff >= 18 AND rating_diff <=  25 THEN 0.53
               WHEN rating_diff >= 26 AND rating_diff <=  32 THEN 0.54
               WHEN rating_diff >= 33 AND rating_diff <=  39 THEN 0.55
               WHEN rating_diff >= 40 AND rating_diff <=  46 THEN 0.56
               WHEN rating_diff >= 47 AND rating_diff <=  53 THEN 0.57
               WHEN rating_diff >= 54 AND rating_diff <=  61 THEN 0.58
               WHEN rating_diff >= 62 AND rating_diff <=  68 THEN 0.59
               WHEN rating_diff >= 69 AND rating_diff <=  76 THEN 0.60
               WHEN rating_diff >= 77 AND rating_diff <=  83 THEN 0.61
               WHEN rating_diff >= 84 AND rating_diff <=  91 THEN 0.62
               WHEN rating_diff >= 92 AND rating_diff <=  98 THEN 0.63
               WHEN rating_diff >= 99 AND rating_diff <=  106 THEN 0.64
               WHEN rating_diff >= 107 AND rating_diff <= 113 THEN 0.65
               WHEN rating_diff >= 114 AND rating_diff <= 121 THEN 0.66
               WHEN rating_diff >= 122 AND rating_diff <= 129 THEN 0.67
               WHEN rating_diff >= 130 AND rating_diff <= 137 THEN 0.68
               WHEN rating_diff >= 138 AND rating_diff <= 145 THEN 0.69
               WHEN rating_diff >= 146 AND rating_diff <= 153 THEN 0.70
               WHEN rating_diff >= 154 AND rating_diff <= 162 THEN 0.71
               WHEN rating_diff >= 163 AND rating_diff <= 170 THEN 0.72
               WHEN rating_diff >= 171 AND rating_diff <= 179 THEN 0.73
               WHEN rating_diff >= 180 AND rating_diff <= 188 THEN 0.74
               WHEN rating_diff >= 189 AND rating_diff <= 197 THEN 0.75
               WHEN rating_diff >= 198 AND rating_diff <= 206 THEN 0.76
               WHEN rating_diff >= 207 AND rating_diff <= 215 THEN 0.77
               WHEN rating_diff >= 216 AND rating_diff <= 225 THEN 0.78
               WHEN rating_diff >= 226 AND rating_diff <= 235 THEN 0.79
               WHEN rating_diff >= 236 AND rating_diff <= 245 THEN 0.80
               WHEN rating_diff >= 246 AND rating_diff <= 256 THEN 0.81
               WHEN rating_diff >= 257 AND rating_diff <= 267 THEN 0.82
               WHEN rating_diff >= 268 AND rating_diff <= 278 THEN 0.83
               WHEN rating_diff >= 279 AND rating_diff <= 290 THEN 0.84
               WHEN rating_diff >= 291 AND rating_diff <= 302 THEN 0.85
               WHEN rating_diff >= 303 AND rating_diff <= 315 THEN 0.86
               WHEN rating_diff >= 316 AND rating_diff <= 328 THEN 0.87
               WHEN rating_diff >= 329 AND rating_diff <= 344 THEN 0.88
               WHEN rating_diff >= 345 AND rating_diff <= 357 THEN 0.89
               WHEN rating_diff >= 358 AND rating_diff <= 374 THEN 0.90
               WHEN rating_diff >= 375 AND rating_diff <= 391 THEN 0.91
               WHEN rating_diff >= 392 AND rating_diff <= 411 THEN 0.92
               WHEN rating_diff >= 412 AND rating_diff <= 432 THEN 0.93
               WHEN rating_diff >= 433 AND rating_diff <= 456 THEN 0.94
               WHEN rating_diff >= 457 AND rating_diff <= 484 THEN 0.95
               WHEN rating_diff >= 485 AND rating_diff <= 517 THEN 0.96
               WHEN rating_diff >= 518 AND rating_diff <= 559 THEN 0.97
               WHEN rating_diff >= 560 AND rating_diff <= 619 THEN 0.98
               WHEN rating_diff >= 620 AND rating_diff <= 735 THEN 0.99
               ELSE 1.00
        END;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION FIDE_rating_change(player_rating INTEGER, opponent_rating INTEGER, K_factor INTEGER, score NUMERIC(2, 1))
    RETURNS NUMERIC (5, 2) AS
$$
BEGIN
    RETURN (score-FIDE_scoring_probability(player_rating, opponent_rating))*K_factor;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_K_factor(player_id INTEGER, chess_type_id INTEGER, date_played DATE) RETURNS INTEGER
AS
$$
BEGIN
    CASE (
        SELECT ct.rating_policy
        FROM chess_types ct
        WHERE ct.chess_type_id = get_K_factor.chess_type_id
    )
        WHEN 'flat' THEN RETURN  (
            SELECT ct.k_factor
            FROM chess_types ct
            WHERE ct.chess_type_id = get_K_factor.chess_type_id
        );
        WHEN 'unrated' THEN RETURN 0;
        WHEN 'fide_standard' THEN
            --this doesn't work yet. We need to consider published rating lists etc.
--        IF (
--            SELECT COUNT()
--            FROM games g1
--            WHERE
--                (g1.white_player_id = player_id OR g1.black_player_id = player_id)
--            AND result IS NOT NULL
--            AND get_K_factor.chess_type_id = (
--                    SELECT t.chess_type_id
--                    FROM games g2 JOIN tournaments t USING (tournament_id)
--                    WHERE g2.game_id = g1.game_id
--                )
--            ) >= 30
            IF (SELECT MAX(value)
                FROM rating_history rh
                WHERE rh.player_id=get_K_factor.player_id
                  AND rh.chess_type_id=get_K_factor.chess_type_id) >=2400 THEN RETURN 10;
            END IF;
            IF
                EXTRACT('year' FROM
                        (SELECT per.date_of_birth
                         FROM persons per
                                  JOIN players pla USING (person_id)
                         WHERE pla.player_id=get_K_factor.player_id)
                )+18 <= EXTRACT('year' FROM date_played) THEN RETURN 40;
            END IF;
            RETURN 20;
        ELSE RAISE NOTICE 'Unsupported rating policy. Returning K-factor = 0';
        END CASE;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_ratings_after_new_game_result() RETURNS TRIGGER AS $update_ratings_after_new_game_result$
DECLARE
    white_old_rating INTEGER;
    black_old_rating INTEGER;
    game_chess_type_id INTEGER;
BEGIN
    --zmiana graczy, to tez by sie przydalo, ale przynajmniej GUI tego nie udostepnia na ten moment
    IF NEW.result IS NULL THEN
        RETURN NEW;
    END IF;
    IF OLD.result IS NOT DISTINCT FROM NEW.result THEN
        RETURN NEW;
    END IF;
    IF OLD.result IS NOT NULL THEN
        --to jest bardzo brzydkie dwa razy ten sam kod ale jest 21 i wole zeby bylo brzydko dzialajace niz w ogole brak
        --cofamy to co dodalismy
        game_chess_type_id = (
            SELECT t.chess_type_id
            FROM games g JOIN tournaments t USING(tournament_id)
            WHERE g.game_id = NEW.game_id);

        white_old_rating = (
            SELECT value
            FROM rating_history rh
            WHERE
                rh.player_id = NEW.white_player_id
              AND rh.chess_type_id = game_chess_type_id
              AND rh.date_to IS NULL
        );

        black_old_rating = (
            SELECT value
            FROM rating_history rh
            WHERE
                rh.player_id = NEW.black_player_id
              AND rh.chess_type_id = game_chess_type_id
              AND rh.date_to IS NULL
        );

        UPDATE live_ratings
        SET value = value - FIDE_rating_change(
                white_old_rating,
                black_old_rating,
                get_K_factor(NEW.white_player_id, game_chess_type_id, OLD.date),
                OLD.result
                            )
        WHERE player_id = NEW.white_player_id AND chess_type_id = game_chess_type_id;

        UPDATE live_ratings
        SET value = value - FIDE_rating_change(
                black_old_rating,
                white_old_rating,
                get_K_factor(NEW.black_player_id, game_chess_type_id, OLD.date),
                1-OLD.result
                            )
        WHERE player_id = NEW.black_player_id AND chess_type_id = game_chess_type_id;
    END IF;

    game_chess_type_id = (
        SELECT t.chess_type_id
        FROM games g JOIN tournaments t USING(tournament_id)
        WHERE g.game_id = NEW.game_id);

    white_old_rating = (
        SELECT value
        FROM rating_history rh
        WHERE
            rh.player_id = NEW.white_player_id
          AND rh.chess_type_id = game_chess_type_id
          AND rh.date_to IS NULL
    );

    black_old_rating = (
        SELECT value
        FROM rating_history rh
        WHERE
            rh.player_id = NEW.black_player_id
          AND rh.chess_type_id = game_chess_type_id
          AND rh.date_to IS NULL
    );

    UPDATE live_ratings
    SET value = value + FIDE_rating_change(
            white_old_rating,
            black_old_rating,
            get_K_factor(NEW.white_player_id, game_chess_type_id, NEW.date),
            NEW.result
                        )
    WHERE player_id = NEW.white_player_id AND chess_type_id = game_chess_type_id;

    UPDATE live_ratings
    SET value = value + FIDE_rating_change(
            black_old_rating,
            white_old_rating,
            get_K_factor(NEW.black_player_id, game_chess_type_id, NEW.date),
            1-NEW.result
                        )
    WHERE player_id = NEW.black_player_id AND chess_type_id = game_chess_type_id;

    RETURN NEW;
END;
$update_ratings_after_new_game_result$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_ratings_after_new_game_result AFTER
    INSERT OR UPDATE ON games FOR EACH ROW
EXECUTE PROCEDURE update_ratings_after_new_game_result();
