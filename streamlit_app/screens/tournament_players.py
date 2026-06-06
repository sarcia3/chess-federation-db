import pandas as pd
import streamlit as st

from queries import *


def render():
    st.title("Tournament Players")
    starting_list, results= st.tabs(["Starting list", "Results"])

    with starting_list:
        _starting_list()
    with results:
        tournaments = tournament_options()
        if not tournaments:
            st.info("No tournaments yet.")
            return

        tour = st.selectbox("Tournament", tournaments, key="restourselect", format_func=lambda t: t["name"])

        results = tournament_standings(tour["tournament_id"])
        if not results:
            st.info("No players yet")
            return

        st.dataframe(results)

def _starting_list():
    tournaments = tournament_options()
    if not tournaments:
        st.info("No tournaments yet.")
        return

    tour = st.selectbox("Tournament", tournaments, format_func=lambda t: t["name"])
    tour_players = tournament_players_raw(tour["tournament_id"])

    with st.popover("Add a player"):
        new = player_options()
        member_ids = {m["player_id"] for m in tour_players}
        new = [c for c in new if c["player_id"] not in member_ids]

        if not new :
            st.info(f"Every player is already in this tournament.")
        else:
            with st.form("add_player_form", clear_on_submit=True):

                tour_players = tournament_players_raw(tour["tournament_id"])
                new = player_options()
                member_ids = {m["player_id"] for m in tour_players}
                new = [c for c in new if c["player_id"] not in member_ids]

                player = st.selectbox(
                    "Chose a player", new,
                    format_func=lambda p: f'[id: {str(p["player_id"])}] {p["name"]}', index=None,
                )

                submitted = st.form_submit_button(
                    "Add", type="primary", key="save_btn_addplayer", width="stretch",
                )
            if submitted:
                if player is None:
                    st.error("Pick a player first.")
                else:
                    try:
                        run_exec("""
                        INSERT INTO tournament_players VALUES(%s, %s)""", (tour["tournament_id"], player["player_id"]))
                        st.rerun()
                    except Exception as e:
                        st.error(f"Adding player failed: {e}")

    tour_players = tournament_players_full(tour["tournament_id"], tour["chess_type_id"])
    tp_df = pd.DataFrame(tour_players)

    if tp_df.empty:
        st.info("No players yet")
    else:
        st.dataframe(
        tp_df[["first_name", "last_name", "name", "pub"]],
        hide_index=True,
        column_config={
            "first_name": "First name",
            "last_name": "Last name",
            "name": "Federation",
            "pub": "Rating",
        },
    )