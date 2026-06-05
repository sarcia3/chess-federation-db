"""Screen: browse any table (read-only)."""

import streamlit as st

from db import run_query

# Allow-list of identifiers we permit in SELECT * (never interpolate raw input).
BROWSABLE_TABLES = [
    "countries", "persons", "person_contact_data", "players", "arbiters",
    "tournaments", "chess_types", "games", "live_ratings", "rating_history",
    "time_controls", "titles", "players_titles", "clubs", "club_memberships",
    "club_contact_data",
]


def render():
    st.header("Browse data")
    table = st.selectbox("Table", BROWSABLE_TABLES)
    try:
        rows = run_query(f'SELECT * FROM "{table}" LIMIT 500')
    except Exception as e:
        st.error(f"Query failed: {e}")
        return
    st.caption(f"{len(rows)} row(s) (max 500 shown)")
    st.dataframe(rows, use_container_width=True)
