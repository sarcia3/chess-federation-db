import streamlit as st
import pandas as pd

import queries
from db import run_query
from queries import chess_type_options

def rating_list(chess_type_id, chess_type_name):
    st.write(chess_type_id, chess_type_name)
    rating_df = pd.DataFrame(run_query("""
    SELECT persons.*, countries.name AS "country", live_ratings.value AS live, players.value AS pub
    FROM persons JOIN players_with_latest_published_ratings players ON players.person_id = persons.person_id
    JOIN live_ratings ON live_ratings.player_id = players.player_id
    JOIN countries ON countries.country_id = persons.country_id
    WHERE live_ratings.chess_type_id = %s AND live_ratings.chess_type_id = players.chess_type_id
    AND COALESCE(live_ratings.value, players.value) IS NOT NULL
    ORDER BY live_ratings.value DESC, persons.last_name
    """, str(chess_type_id)))
    if rating_df.empty:
        st.info(f"No ratings for {chess_type_name}.")
        return

    rating_df.insert(0, "Rank", range(1, len(rating_df) + 1))
    rating_df["Name"] = rating_df["last_name"] + ", " + rating_df["first_name"]
    st.dataframe(
        rating_df[["Rank", "Name", "country", "live", "pub"]],
        hide_index=True,
        column_config={
            "Rank":       st.column_config.NumberColumn(width="small"),
            "Name":  st.column_config.TextColumn("Player"),
            "country":    st.column_config.TextColumn("Country"),
            "live":       st.column_config.NumberColumn("Live", format="%d"),
            "pub":        st.column_config.NumberColumn("Published", format="%d")}

    )

def render():
    types = chess_type_options()
    if not types:
        st.info("No chess types defined.")
        return
    tabs = st.tabs([t["name"] for t in types])
    for chess_type, tab in zip(types, tabs):
        with tab:
            rating_list(chess_type["chess_type_id"], chess_type["name"])