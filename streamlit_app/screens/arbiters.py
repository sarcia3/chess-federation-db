#same as players


import streamlit as st

from queries import player_options, non_player_persons, add_player, arbiter_options, non_arbiter_persons, add_arbiter
from components import person_panel, is_editing


def render():
    browse_tab, add_tab = st.tabs(["Browse & edit", "Add arbiter"])
    with browse_tab:
        _browse()
    with add_tab:
        _add_arbiter()


def _browse():
    arbiters = arbiter_options()
    if not arbiters:
        st.info("No arbiters yet.")
        return

    arbiter = st.selectbox(
        "Chose an arbiter", arbiters,
        format_func=lambda p: f'[id: {str(p["arbiter_id"])}] {p["name"]}',
        disabled=is_editing(),
    )

    person_panel(arbiter["person_id"])


def _add_arbiter():
    st.subheader("Add an arbiter")

    candidates = non_arbiter_persons()
    if not candidates:
        st.info("Every person in the database is already an arbiter.")
        return

    with st.form("add_arbiter_form", clear_on_submit=True):
        person = st.selectbox(
            "Person", candidates, index=None,
            format_func=lambda p: f'[id: {str(p["person_id"])}] {p["name"]}',
        )
        submitted = st.form_submit_button(
            "Add as an arbiter", type="primary", key="save_btn_addarbiter", width="stretch",
        )

    if submitted:
        if person is None:
            st.error("Pick a person first.")
        else:
            try:
                add_arbiter(person["person_id"])
                st.success(f'Added {person["name"]} as an arbiter.')
            except Exception as e:
                st.error(f"Adding arbiter failed: {e}")
