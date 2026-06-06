import streamlit as st
import pandas as pd

from queries import chess_type_options, ratings_by_chess_type


def rating_list(chess_type_id, chess_type_name):
    st.write(chess_type_id, chess_type_name)
    rating_df = pd.DataFrame(ratings_by_chess_type(chess_type_id))
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