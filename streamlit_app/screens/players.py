import streamlit as st

from db import run_query
from queries import player_options


def render():
    editing = st.session_state.setdefault("editing", False)
    # we have to do this because the framework is weird

    players = player_options()
    player = st.selectbox(
        "Chose a player", players,
        format_func=lambda p: f'[id: {str(p["player_id"])}] {p["name"]}',
        disabled=editing,   # locked while editing so the row can't change under you
    )

    if not editing:
        st.write(player)
        if st.button("Edit", type="primary"):
            st.session_state.editing = True
            st.rerun()
    else:
        # One input per field instead of st.data_editor: a single record has no
        # natural grid, and data_editor would render a transposed table with a
        # junk "value" header row that can't be hidden.
        st.write("Enter new values:")
        edited = {
            field: st.text_input(field, value=str(val),
                                 disabled=(field == "player_id"))
            for field, val in player.items()
        }
        save_col, clear_col = st.columns(2)
        if save_col.button("Save", type="primary", key="save_btn", width="stretch"):
            st.session_state.editing = False
            st.rerun()
        if clear_col.button("Clear changes", type="primary", key="clear_btn", width="stretch"):
            st.session_state.editing = False
            st.rerun()
