"""
Tutaj wrzucam query
"""

from db import run_query, run_exec

# hacky rozwiazanie dla add_game. --todo przenies to tam
RESULT_OPTIONS = ["white 1-0", "dra /", "black 0-1"]                       # raw cell values
OPTION_DISPLAY = {"white 1-0": "1-0", "dra /": "½-½", "black 0-1": "0-1"}   # format_func output
OPTION_TO_RESULT = {"white 1-0": 1.0, "dra /": 0.5, "black 0-1": 0.0}       # raw word -> DB number
RESULT_TO_OPTION = {1.0: "white 1-0", 0.5: "dra /", 0.0: "black 0-1"}       # DB number -> raw word


def result_to_option(value):
    """Stored NUMERIC result (Decimal or None) -> raw option word (or None)."""
    if value is None:
        return None
    return RESULT_TO_OPTION.get(float(value))


def person_options():
    return run_query(
        """
        SELECT 
               person_id,
               first_name || ' ' || last_name AS name
        FROM 
        persons 
        ORDER BY last_name
        """
    )

def player_options():
    return run_query(
        """
        SELECT pl.player_id,
               pl.person_id,
               p.first_name || ' ' || p.last_name AS name
        FROM players pl
        JOIN persons p USING (person_id)
        ORDER BY last_name
        """
    )

def arbiter_options():
    return run_query(
        """
        SELECT a.arbiter_id,
               a.person_id,
               p.first_name || ' ' || p.last_name AS name
        FROM arbiters a
        JOIN persons p USING (person_id)
        ORDER BY last_name
        """
    )

def time_control_options():
    return run_query("""
    SELECT time_control_id, 
    EXTRACT('HOURS' FROM starting_time) * 60 +
    EXTRACT('MINUTES' FROM starting_time) AS starting_time,  
    EXTRACT('SECONDS' FROM increment)::INT AS increment 
    FROM time_controls; 
    """)
# zakladam, ze sumaryczne jest mniejsze niz dni

def person_info(person_id):
    return run_query(
        """
        SELECT pe.person_id, pe.first_name, pe.last_name,
               pe.date_of_birth, pe.gender, pe.country_id,
               c.name AS country
        FROM persons pe
        JOIN countries c USING (country_id)
        WHERE pe.person_id = %s
        """,
        (person_id,),
    )

def club_options():
    return run_query("""
        SELECT c.club_id,
               c.name  AS "Club name",
               co.name AS "Country name",
               COUNT(cm.player_id) AS "Players"
        FROM clubs c
        JOIN countries co ON co.country_id = c.country_id
        LEFT JOIN club_memberships cm ON cm.club_id = c.club_id
        GROUP BY c.club_id, c.name, co.name
        ORDER BY c.name
    """)
def update_person(person_id, first_name, last_name, date_of_birth, gender, country_id):
    return run_exec(
        """
        UPDATE persons
           SET first_name = %s, last_name = %s, date_of_birth = %s,
               gender = %s, country_id = %s
         WHERE person_id = %s
        """,
        (first_name, last_name, date_of_birth, gender, country_id, person_id),
    )


_PERSON_COLS = ("first_name", "last_name", "date_of_birth", "gender", "country_id")

def insert_person(first_name, last_name, date_of_birth, gender, country_id):
    values = [first_name, last_name, date_of_birth, gender, country_id]
    if not all(v is not None and str(v).strip() != "" for v in values):
        raise ValueError("All fields must be filled up before inserting!")

    cols = ", ".join(_PERSON_COLS)
    placeholders = ", ".join(["%s"] * len(_PERSON_COLS))
    return run_exec(
        f"INSERT INTO persons ({cols}) VALUES ({placeholders})",
        values,
    )

def country_options():
    """[{country_id, name}] for a country picker, alphabetical."""
    return run_query("SELECT country_id, name FROM countries ORDER BY name")


def non_player_persons():
    return run_query(
        """
        SELECT pe.person_id,
               pe.first_name || ' ' || pe.last_name AS name
        FROM persons pe
        WHERE NOT EXISTS (
            SELECT pl.player_id FROM players pl WHERE pl.person_id = pe.person_id
        )
        ORDER BY name
        """
    )

def non_arbiter_persons():
    return run_query(
        """
        SELECT pe.person_id,
               pe.first_name || ' ' || pe.last_name AS name
        FROM persons pe
        WHERE NOT EXISTS (
            SELECT a.arbiter_id FROM arbiters a WHERE a.person_id = pe.person_id
        )
        ORDER BY name
        """
    )

def add_player(person_id):
    return run_exec("INSERT INTO players (person_id) VALUES (%s)", (person_id,))

def add_arbiter(person_id):
    return run_exec("INSERT INTO arbiters (person_id) VALUES (%s)", (person_id,))

def chess_type_options():
    return run_query("SELECT chess_type_id, name FROM chess_types ORDER BY name")

def player_info(player_id):
    return run_query("""
       SELECT 
       pe.first_name,
       pe.last_name,
       date_of_birth,
       gender,
       c.name AS country
       FROM
       players pl JOIN persons pe USING (person_id)
       JOIN countries c USING (country_id)
       where pl.player_id = %s
   """, str(player_id))

def tournament_options():
    return run_query("SELECT * FROM tournaments ORDER BY name")


def tournament_info(tournament_id):
    """One tournament's full row (FK ids included) — for prefilling the editor."""
    return run_query(
        """
        SELECT tournament_id, name, city, street_address,
               country_id, chess_type_id, main_arbiter, time_control_id,
               date_from, date_to
        FROM tournaments
        WHERE tournament_id = %s
        """,
        (tournament_id,),
    )

_TOURNAMENT_COLS = (
    "name", "city", "street_address", "country_id", "chess_type_id",
    "main_arbiter", "time_control_id", "date_from", "date_to",
)

def insert_tournament(name, city, street_address, country_id, chess_type_id,
                      main_arbiter, time_control_id, date_from, date_to):
    values = [name, city, street_address, country_id, chess_type_id,
              main_arbiter, time_control_id, date_from, date_to]
    if not all(str(v).strip() != "" for v in values):
        raise ValueError("All fields must be filled up before inserting!")

    cols = ", ".join(_TOURNAMENT_COLS)
    placeholders = ", ".join(["%s"] * len(_TOURNAMENT_COLS))
    return run_exec(
        f"INSERT INTO tournaments ({cols}) VALUES ({placeholders})",
        values,
    )


def update_tournament(tournament_id, name, city, street_address, country_id,
                      chess_type_id, main_arbiter, time_control_id,
                      date_from, date_to):
    assignments = ", ".join(f"{c} = %s" for c in _TOURNAMENT_COLS)
    return run_exec(
        f"UPDATE tournaments SET {assignments} WHERE tournament_id = %s",
        (name, city, street_address, country_id, chess_type_id,
         main_arbiter, time_control_id, date_from, date_to, tournament_id),
    )

def tournament_players_raw(tournament_id):
   return (
       run_query(
           """
           SELECT * FROM tournament_players WHERE tournament_id = %s
           """,
           (str(tournament_id),))
   )


def tournament_players_full(tournament_id, chess_type_id):
    return run_query(
            """
            SELECT *, live_ratings.value as live, players.value as pub, 
            persons.first_name || ' ' || persons.last_name AS pname
            FROM (tournament_players 
            LEFT OUTER JOIN players_with_latest_published_ratings players USING (player_id)) JOIN persons
            ON players.person_id = persons.person_id
            JOIN live_ratings ON live_ratings.player_id = players.player_id
            JOIN countries ON countries.country_id = persons.country_id
            WHERE live_ratings.chess_type_id = %s AND live_ratings.chess_type_id = players.chess_type_id
            AND tournament_id = %s
            ORDER BY live_ratings.value DESC, persons.last_name
            """,
            (str(chess_type_id),str(tournament_id)))


def round_games(tournament_id, round_number):
    """Pairings (with player names) for one tournament round, ordered stably."""
    return run_query(
        """
        SELECT g.game_id,
               g.result,
               w.first_name || ' ' || w.last_name AS white,
               b.first_name || ' ' || b.last_name AS black
        FROM games g
        JOIN players wp ON wp.player_id = g.white_player_id
        JOIN persons w  ON w.person_id  = wp.person_id
        JOIN players bp ON bp.player_id = g.black_player_id
        JOIN persons b  ON b.person_id  = bp.person_id
        WHERE g.tournament_id = %s AND g.round_number = %s
        ORDER BY g.game_id
        """,
        (tournament_id, round_number),
    )

def ratings_by_chess_type(chess_type_id):
    return run_query("""
        SELECT persons.*, players.player_id, countries.name AS "country", live_ratings.value AS live, players.value AS pub
        FROM persons JOIN players_with_latest_published_ratings players ON players.person_id = persons.person_id
        JOIN live_ratings ON live_ratings.player_id = players.player_id
        JOIN countries ON countries.country_id = persons.country_id
        WHERE live_ratings.chess_type_id = %s AND live_ratings.chess_type_id = players.chess_type_id
        AND COALESCE(live_ratings.value, players.value) IS NOT NULL
        ORDER BY live_ratings.value DESC, persons.last_name
        """, str(chess_type_id))

def tournament_standings(tournament_id):
    return run_query("SELECT * FROM tournament_standings(%s)", (str(tournament_id),))