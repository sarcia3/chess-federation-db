import streamlit as st

import queries
from components import person_panel


def render():
    clubs = queries.run_query("""
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

    st.subheader("Clubs")
    # Selectable rows: clicking one reruns and reports its position in selection.
    # club_id is fetched but not shown (column_order omits it).
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
    players = queries.run_query("""
        SELECT pe.person_id,
               pe.first_name || ' ' || pe.last_name AS "Player"
        FROM club_memberships cm
        JOIN players pl USING (player_id)
        JOIN persons  pe USING (person_id)
        WHERE cm.club_id = %s
        ORDER BY "Player"
    """, (club["club_id"],))

    st.subheader(f"Players of {club['Club name']}")
    if not players:
        st.info("This club has no members.")
        return

    # Selectable like the clubs table; person_id is fetched but hidden.
    event = st.dataframe(
        players,
        hide_index=True,
        on_select="rerun",
        selection_mode="single-row",
        column_order=["Player"],
        key="club_players_table",
    )

    selected = event.selection["rows"]
    if selected:
        person_panel(players[selected[0]]["person_id"])
