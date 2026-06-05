import streamlit as st
import pandas as pd
import altair as alt
from db import run_query
from queries import player_options, non_player_persons, add_player, chess_type_options
from components import person_panel, is_editing


def render():
    players = player_options()
    if not players:
        st.info("No players yet.")
        return

    # Picker is locked while editing so the record can't change under the form.
    player = st.selectbox(
        "Chose a player", players,
        format_func=lambda p: f'[id: {str(p["player_id"])}] {p["name"]}',
        disabled=is_editing(),
    )

    types = chess_type_options()

    history_df = pd.DataFrame(run_query("""
        SELECT date_from, date_to, chess_type_id, value
        FROM players p LEFT OUTER JOIN rating_history rh USING (player_id)
        WHERE p.player_id = %s AND p.player_id = rh.player_id
    """, str(player["player_id"])))

    if history_df.empty:
        st.info("Not ratings published for player.")
        return

    history_by_type_df = dict(tuple(history_df.groupby("chess_type_id")))

    # Only chess types this player actually has history for.
    shown_types = [t for t in types if t["chess_type_id"] in history_by_type_df]
    tabs = st.tabs([t["name"] for t in shown_types])
    for chess_type, tab in zip(shown_types, tabs):
        with tab:
            chart_df = history_by_type_df[chess_type["chess_type_id"]]
            chart = (
                alt.Chart(chart_df)
                .mark_line(point=True)
                .encode(
                    x=alt.X("date_from:T", title="Date"),
                    # zero=False crops the y-axis to the rating range instead of
                    # starting at 0, so the line's variation is actually visible.
                    y=alt.Y("value:Q", title="Rating", scale=alt.Scale(zero=False)),
                    tooltip=["date_from:T", "value:Q"],
                )
            )
            st.altair_chart(chart, use_container_width=True)

