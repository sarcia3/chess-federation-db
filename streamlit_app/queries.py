"""Shared database queries and result-value helpers used by several screens.

Keeping these in one place avoids duplicating SQL across the screen modules.
All of them go through the helpers in db.py, so there is no hidden ORM.
"""

from db import run_query

# result is the WHITE player's score: 1.0 white win, 0.5 draw, 0.0 black win.
#
# In the grid, the cell holds a RAW option word ("white"/"draw"/"black"); the
# SelectboxColumn's format_func displays it as the score ("1-0" ...). So the
# cell shows a clean "1-0", while the underlying value is the word — which is
# what may let you filter the dropdown by typing "white". The database column
# games.result still stores the NUMERIC score (1.0 / 0.5 / 0.0).
RESULT_OPTIONS = ["white 1-0", "dra /", "black 0-1"]                       # raw cell values
OPTION_DISPLAY = {"white 1-0": "1-0", "dra /": "½-½", "black 0-1": "0-1"}   # format_func output
OPTION_TO_RESULT = {"white 1-0": 1.0, "dra /": 0.5, "black 0-1": 0.0}       # raw word -> DB number
RESULT_TO_OPTION = {1.0: "white 1-0", 0.5: "dra /", 0.0: "black 0-1"}       # DB number -> raw word


def result_to_option(value):
    """Stored NUMERIC result (Decimal or None) -> raw option word (or None)."""
    if value is None:
        return None
    return RESULT_TO_OPTION.get(float(value))


def player_options():
    """[{player_id, name}] sorted by full name — used by searchable selectboxes."""
    return run_query(
        """
        SELECT pl.player_id,
               p.first_name || ' ' || p.last_name AS name
        FROM players pl
        JOIN persons p USING (person_id)
        ORDER BY name
        """
    )


def tournament_options():
    return run_query("SELECT tournament_id, name FROM tournaments ORDER BY name")


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
