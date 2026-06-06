CREATE TYPE GENDER AS ENUM ('Male', 'Female', 'Other');
CREATE TYPE CONTINENT AS ENUM ('Asia', 'Africa', 'North America', 'South America', 'Antarctica', 'Europe', 'Australia');

CREATE TABLE "persons"(
    "person_id" SERIAL PRIMARY KEY,
    "first_name" VARCHAR(128) NOT NULL,
    "last_name" VARCHAR(128) NOT NULL,
    "date_of_birth" DATE NOT NULL,
    "gender" GENDER NOT NULL,
    "country_id" INTEGER NOT NULL
);

CREATE TABLE "countries"(
    "country_id" SERIAL PRIMARY KEY,
    "name" VARCHAR(128) NOT NULL,
    "continent" CONTINENT NOT NULL,
    "is_active" BOOLEAN DEFAULT TRUE
);

CREATE TABLE "person_contact_data"(
    "person_id" INTEGER NOT NULL,
    "mail_address" VARCHAR (254) NOT NULL,
    "phone_number" VARCHAR (15) NOT NULL,
    "timestamp_from" DATE NOT NULL,
    "timestamp_to" DATE,
    PRIMARY KEY("person_id", "timestamp_from")
);

CREATE TABLE "players"(
    "player_id" SERIAL PRIMARY KEY,
    "person_id" INTEGER NOT NULL
);

CREATE TABLE "arbiters"(
    "arbiter_id" SERIAL PRIMARY KEY,
    "person_id" INTEGER NOT NULL
);

CREATE TABLE "tournaments"(
    "tournament_id" SERIAL PRIMARY KEY,
    "chess_type_id" INTEGER NOT NULL,
    "city" VARCHAR(64) NOT NULL,
    "street_address" VARCHAR(128) NOT NULL,
    "country_id" INTEGER NOT NULL,
    "name" VARCHAR(64) NOT NULL,
    "main_arbiter" INTEGER NOT NULL,
    "time_control_id" INTEGER NOT NULL,
    "date_from" DATE NOT NULL,
    "date_to" DATE,
    CHECK (date_from <= date_to)
);

CREATE TABLE "chess_types"(
    "chess_type_id" SERIAL PRIMARY KEY,
    "name" VARCHAR(64) NOT NULL,
    "total_time_from" INTERVAL,
    "total_time_to" INTERVAL,
    --
    "rating_policy" VARCHAR(32) NOT NULL DEFAULT 'unrated',
    "k_factor" INTEGER,

    CONSTRAINT k_factor_required_for_flat
        CHECK ( rating_policy <> 'flat' OR k_factor IS NOT NULL ),

    CONSTRAINT k_factor_positive
        CHECK ( k_factor IS NULL OR k_factor > 0)
    -- how K-factor is calculated.
    -- I wasn't sure how to implement K-factors and if this should be an enum or not.
    -- I used some help from and LLM to make a decision on what to do, and after
    -- that I decided that this rating_policy field is the best idea.
);

CREATE TABLE "games"(
    "game_id" SERIAL PRIMARY KEY,
    "tournament_id" INTEGER NOT NULL,
    "white_player_id" INTEGER NOT NULL,
    "black_player_id" INTEGER NOT NULL,
    "result" NUMERIC(2, 1),
    "date" DATE NOT NULL, --start date
    "round_number" INTEGER NOT NULL,
    "pgn" TEXT NULL
    CHECK ("result" IS NULL or 
    "result" = 1.0
    or
    "result" = 0.5
    or
    "result" = 0.0)
    CHECK (white_player_id IS DISTINCT FROM black_player_id)
);

CREATE TABLE "live_ratings"(
    "player_id" INTEGER,
    "chess_type_id" INTEGER,
    "value" NUMERIC(9, 2) NOT NULL,
    PRIMARY KEY("player_id", "chess_type_id")
);

CREATE TABLE "rating_history"(
    "player_id" INTEGER NOT NULL,
    "value" INTEGER NOT NULL,
    "chess_type_id" INTEGER NOT NULL,
    "date_from" DATE NOT NULL,
    "date_to" DATE,
    CHECK (date_from < date_to),
    PRIMARY KEY("player_id", "chess_type_id", "date_from")
);

CREATE TABLE "time_controls"(
    "time_control_id" SERIAL PRIMARY KEY,
    "starting_time" INTERVAL NOT NULL,
    "increment" INTERVAL NOT NULL DEFAULT interval '0 seconds',
    UNIQUE("starting_time", "increment")
);

CREATE TABLE "titles"(
    "short_name" CHAR(4) PRIMARY KEY,
    "full_name" VARCHAR(64) NOT NULL UNIQUE
);

CREATE TABLE "players_titles"(
    "player_id" INTEGER NOT NULL,
    "title_short_name" CHAR(4) NOT NULL,
    "date_achieved" DATE NOT NULL,
    "norm1_tournament_id" INTEGER,
    "norm2_tournament_id" INTEGER,
    "norm3_tournament_id" INTEGER,
    "rating_norm_date" DATE,
    PRIMARY KEY("player_id", "title_short_name")
);

CREATE TABLE "club_memberships"(
    "player_id" INTEGER NOT NULL,
    "club_id" INTEGER NOT NULL,
    PRIMARY KEY ("player_id", "club_id")
);

CREATE TABLE "clubs"(
    "club_id" SERIAL PRIMARY KEY,
    "country_id" INTEGER,
    "name" VARCHAR(128)
);

CREATE TABLE "club_contact_data"(
    "club_id" INTEGER NOT NULL,
    "mail_address" VARCHAR(254) NOT NULL,
    "website" VARCHAR(256),
    "timestamp_from" DATE NOT NULL,
    "timestamp_to" DATE,
    PRIMARY KEY("club_id", "timestamp_from")
);


CREATE TABLE "tournament_players"
(
    "tournament_id" INTEGER,
    "player_id" INTEGER,
    PRIMARY KEY("tournament_id", "player_id")
);


CREATE TABLE "person_country_history"
(
    "person_id" INTEGER NOT NULL,
    "country_id" INTEGER NOT NULL,
    "date_from" DATE NOT NULL,
    "date_to" DATE,
    FOREIGN KEY (person_id) REFERENCES persons(person_id),
    FOREIGN KEY (country_id) REFERENCES countries(country_id),
    CHECK (date_to IS NULL OR date_from <= date_to),
    PRIMARY KEY("person_id", "date_from")
);


ALTER TABLE
    "person_contact_data" ADD CONSTRAINT "person_contact_data_person_id_foreign" FOREIGN KEY("person_id") REFERENCES "persons"("person_id");
ALTER TABLE
    "club_contact_data" ADD CONSTRAINT "club_contact_data_club_id_foreign" FOREIGN KEY("club_id") REFERENCES "clubs"("club_id");
ALTER TABLE
    "tournaments" ADD CONSTRAINT "tournaments_chess_type_id_foreign" FOREIGN KEY("chess_type_id") REFERENCES "chess_types"("chess_type_id");
ALTER TABLE
    "players_titles" ADD CONSTRAINT "players_titles_player_id_foreign" FOREIGN KEY("player_id") REFERENCES "players"("player_id");
ALTER TABLE
    "club_memberships" ADD CONSTRAINT "club_memberships_player_id_foreign" FOREIGN KEY("player_id") REFERENCES "players"("player_id");
ALTER TABLE
    "club_memberships" ADD CONSTRAINT "club_memberships_club_id_foreign" FOREIGN KEY("club_id") REFERENCES "clubs"("club_id");
ALTER TABLE
    "players" ADD CONSTRAINT "players_person_id_foreign" FOREIGN KEY("person_id") REFERENCES "persons"("person_id");
ALTER TABLE
    "tournaments" ADD CONSTRAINT "tournaments_main_arbiter_foreign" FOREIGN KEY("main_arbiter") REFERENCES "arbiters"("arbiter_id");
ALTER TABLE
    "tournaments" ADD CONSTRAINT "tournaments_time_control_id_foreign" FOREIGN KEY("time_control_id") REFERENCES "time_controls"("time_control_id");
ALTER TABLE
    "persons" ADD CONSTRAINT "persons_country_id_foreign" FOREIGN KEY("country_id") REFERENCES "countries"("country_id");
ALTER TABLE
    "players_titles" ADD CONSTRAINT "players_titles_norm1_tournament_id_foreign" FOREIGN KEY("norm1_tournament_id") REFERENCES "tournaments"("tournament_id");
ALTER TABLE
    "players_titles" ADD CONSTRAINT "players_titles_norm2_tournament_id_foreign" FOREIGN KEY("norm2_tournament_id") REFERENCES "tournaments"("tournament_id");
ALTER TABLE
    "players_titles" ADD CONSTRAINT "players_titles_norm3_tournament_id_foreign" FOREIGN KEY("norm3_tournament_id") REFERENCES "tournaments"("tournament_id");
ALTER TABLE
    "live_ratings" ADD CONSTRAINT "live_ratings_player_id_foreign" FOREIGN KEY("player_id") REFERENCES "players"("player_id");
ALTER TABLE
    "live_ratings" ADD CONSTRAINT "live_ratings_chess_type_id_foreign" FOREIGN KEY("chess_type_id") REFERENCES "chess_types"("chess_type_id");
ALTER TABLE
    "rating_history" ADD CONSTRAINT "rating_history_player_id_foreign" FOREIGN KEY("player_id") REFERENCES "players"("player_id");
ALTER TABLE
    "rating_history" ADD CONSTRAINT "rating_history_chess_type_id_foreign" FOREIGN KEY("chess_type_id") REFERENCES "chess_types"("chess_type_id");
ALTER TABLE
    "games" ADD CONSTRAINT "games_black_player_id_foreign" FOREIGN KEY("black_player_id") REFERENCES "players"("player_id");
ALTER TABLE
    "games" ADD CONSTRAINT "games_white_player_id_foreign" FOREIGN KEY("white_player_id") REFERENCES "players"("player_id");
ALTER TABLE
    "games" ADD CONSTRAINT "games_tournament_id_foreign" FOREIGN KEY("tournament_id") REFERENCES "tournaments"("tournament_id");
ALTER TABLE
    "players_titles" ADD CONSTRAINT "players_titles_title_short_name_foreign" FOREIGN KEY("title_short_name") REFERENCES "titles"("short_name");
ALTER TABLE
    "tournaments" ADD CONSTRAINT "tournaments_country_id_foreign" FOREIGN KEY("country_id") REFERENCES "countries"("country_id");
ALTER TABLE
    "arbiters" ADD CONSTRAINT "arbiters_person_id_foreign" FOREIGN KEY("person_id") REFERENCES "persons"("person_id");


\i tournament_management.sql

\i rating_management.sql

\i triggers.sql

\i views.sql

\i insert_data.sql
