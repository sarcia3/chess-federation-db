import pandas as pd
import streamlit as st

from db import run_exec
from queries import tournament_options, player_options, tournament_players_raw, tournament_players_full
from screens import tournament_players


def render():
    tournaments = tournament_options()

    if not tournaments:
        st.info("No tournaments available.")
        return

    tour = st.selectbox("Tournament", tournaments, format_func=lambda t: t["name"])
    players = tournament_players_full(tour["tournament_id"], tour["chess_type_id"])

    if len(players) < 2:
        st.info(f"Less than two players registered for {tour["name"]}.")
        return

    st.header("Pairings")
    manual, generate = st.tabs(["Add games manually", "Generate pairings"])
    with manual:
        col1, col2 = st.columns(2)
        white = col1.selectbox("White", players, format_func=lambda p: f'[id: {str(p["player_id"])}] {p["pname"]}', key="white")
        black = col2.selectbox("Black", players, format_func=lambda p: f'[id: {str(p["player_id"])}] {p["pname"]}', key="black")

        col3, col4 = st.columns(2)
        rnd = col3.number_input("Round", min_value=1, step=1, value=1)
        date = col4.date_input("Date")

        if st.button("Add pairing", type="primary"):
            if white["player_id"] == black["player_id"]:
                st.error("White and Black must be different players.")
                return
            try:
                run_exec(
                    """
                    INSERT INTO games
                        (tournament_id, white_player_id, black_player_id,
                         result, date, round_number)
                    VALUES (%s, %s, %s, NULL, %s, %s)
                    """,
                    (tour["tournament_id"], white["player_id"], black["player_id"],
                     date, int(rnd)),
                )
                st.success(f"Added {white['name']} – {black['name']} (Round {int(rnd)}).")
            except Exception as e:
                st.error(f"Insert failed: {e}")
    with generate:
        if st.button("Generate pairings (round robin)"):
            try:
                run_exec("""
                SELECT generate_round_robin_games(%s::INT)""", str(tour["tournament_id"]))
                st.success("Pairings generated.")
            except Exception as e:
                st.error(f"Round robin generation failed: {e}")


