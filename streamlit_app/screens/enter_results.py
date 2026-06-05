"""Screen: enter a whole round's results in an editable grid."""

from typing import cast

import streamlit as st

from db import run_query, run_many
from queries import (
    RESULT_OPTIONS,
    OPTION_DISPLAY,
    OPTION_TO_RESULT,
    result_to_option,
    tournament_options,
    round_games,
)


def render():
    st.header("Enter results")

    tournaments = tournament_options()
    if not tournaments:
        st.info("No tournaments yet — add one first.")
        return

    tour = st.selectbox("Tournament", tournaments, format_func=lambda t: t["name"])

    rounds = run_query(
        "SELECT DISTINCT round_number FROM games WHERE tournament_id = %s "
        "ORDER BY round_number",
        (tour["tournament_id"],),
    )
    if not rounds:
        st.info("This tournament has no games/pairings yet. Add them on 'Add game'.")
        return

    rnd = st.selectbox(
        "Round", [r["round_number"] for r in rounds], format_func=lambda n: f"Round {n}"
    )

    games = round_games(tour["tournament_id"], rnd)

    # One editable row per board. Board / White / Black are read-only; only the
    # Result dropdown can change. game_id rides along (hidden) so each row maps
    # back to the right game when saving.
    rows = [
        {
            "game_id": g["game_id"],
            "Board": i,
            "White": g["white"],
            "Result": result_to_option(g["result"]),
            "Black": g["black"],
        }
        for i, g in enumerate(games, start=1)
    ]

    st.caption("Pick a result per board (type 1-0 / ½-½ / 0-1 to filter). "
               "Leave blank for games not yet played, then click Save.")

    st.html(
        "<style>.st-key-results_grid { align-items: center; }</style>",
    )
    with st.container(key="results_grid"):
        edited = cast(list[dict], st.data_editor(
            rows,
            hide_index=True,
            width='content',
            num_rows="fixed",        # can't add/remove boards, only edit results
            disabled=["game_id", "Board", "White", "Black"],
            column_config={
                "game_id": None,     # hide the id column
                "Board": st.column_config.NumberColumn("#", width=40),
                "Result": st.column_config.SelectboxColumn(
                    "Result",
                    options=RESULT_OPTIONS,
                    format_func=lambda o: OPTION_DISPLAY[o],
                    required=False,
                    width=90,
                ),
            },
        ))

    if st.button("Save round", type="primary"):
        # A blank Result maps to None -> stored as NULL (lets you clear a result).
        statements = [
            (
                "UPDATE games SET result = %s WHERE game_id = %s",
                (OPTION_TO_RESULT.get(row["Result"]), row["game_id"]),
            )
            for row in [row_new for (row_old, row_new) in zip(rows, edited) if row_old["Result"] != row_new["Result"]]
        ]
        try:
            run_many(statements)
            st.success(f"Changed {len(statements)} results for Round {rnd}.")
        except Exception as e:
            st.error(f"Save failed: {e}")
