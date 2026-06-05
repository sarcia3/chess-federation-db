import streamlit as st

from queries import player_options, non_player_persons, add_player
from components import person_panel, is_editing


def render():
    browse_tab, add_tab = st.tabs(["Browse & edit", "Add player"])
    with browse_tab:
        _browse()
    with add_tab:
        _add_player()


def _browse():
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

    # A player's editable data is all on its person, so delegate to the shared
    # editor. A persons screen would call person_panel() the exact same way.
    person_panel(player["person_id"])


def _add_player():
    st.subheader("Add a player")
    # Players are existing persons; if everyone's already a player there's no one
    # to add until a new person is created elsewhere.
    candidates = non_player_persons()
    if not candidates:
        st.info("Every person is already a player. Add the person first.")
        return

    with st.form("add_player_form", clear_on_submit=True):
        person = st.selectbox(
            "Person", candidates, index=None,
            format_func=lambda p: p["name"],
        )
        submitted = st.form_submit_button(
            "Add as player", type="primary", key="save_btn_addplayer", width="stretch",
        )

    if submitted:
        if person is None:
            st.error("Pick a person first.")
        else:
            try:
                add_player(person["person_id"])
                st.success(f'Added {person["name"]} as a player.')
            except Exception as e:
                st.error(f"Adding player failed: {e}")
