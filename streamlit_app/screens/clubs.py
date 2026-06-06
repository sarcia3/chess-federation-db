import streamlit as st

import queries
from components import person_panel
from queries import *


def render():
    st.subheader("Clubs")
    clubs = club_options()

    event = st.dataframe(
        clubs,
        hide_index=True,
        on_select="rerun",
        selection_mode="single-row",
        column_order=["Club name", "Country name", "Players"],
        key="clubs_table",
    )

    selected = event.selection["rows"]
    if selected:
        _show_club_players(clubs[selected[0]])


def _show_club_players(club):
    # powinnam to przeniesc do queries.py, ale jestem zbyt zmęczona ale ig --todo przenies
    club_players = queries.run_query("""
        SELECT pe.person_id,
               pe.first_name || ' ' || pe.last_name AS "Player"
        FROM club_memberships cm
        JOIN players pl USING (player_id)
        JOIN persons  pe USING (person_id)
        WHERE cm.club_id = %s
        ORDER BY "Player"
    """, (club["club_id"],))

    st.subheader(f"Players of {club['Club name']}")
    if not club_players:
        st.info("This club has no members.")
        return

    event = st.dataframe(
        club_players,
        hide_index=True,
        on_select="rerun",
        selection_mode="single-row",
        column_order=["Player"],
        key="club_players_table",
    )

    selected = event.selection["rows"]
    if selected:
        person_panel(club_players[selected[0]]["person_id"])
    else:
        with st.popover("Add a player"):
            candidates = player_options()
            member_ids = {m["person_id"] for m in club_players}
            candidates = [c for c in candidates if c["person_id"] not in member_ids]

            if not candidates:
                st.info(f"Every player is already in the club {club["Club name"]}.")
                return

            with st.form("add_player_form", clear_on_submit=True):

                player = st.selectbox(
                    "Chose a player", candidates,
                    format_func=lambda p: f'[id: {str(p["player_id"])}] {p["name"]}',
                )

                submitted = st.form_submit_button(
                    f"Add as {club["Club name"]} member", type="primary", key="save_btn_addplayer", width="stretch",
                )
            if submitted:
                if player is None:
                    st.error("Pick a player first.")
                else:
                    try:
                        queries.run_exec("""
                        INSERT INTO club_memberships VALUES(%s, %s)""", (player["player_id"], club["club_id"]))
                        st.success(f'Added {player["name"]} as {club["Club name"]} member.')
                    except Exception as e:
                        st.error(f"Adding player failed: {e}")
