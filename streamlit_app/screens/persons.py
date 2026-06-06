import streamlit as st

from queries import *
from components import person_panel, is_editing, add_person_panel


def render():
    browse_tab, add_tab = st.tabs(["Browse & edit", "Add person"])
    with browse_tab:
        _browse()
    with add_tab:
        add_person_panel()


def _browse():
    persons = person_options()
    if not persons :
        #to na prawde nie jest potrzebne. Będą jacyś ludzie w bazie zawsze, ale już nie usuwam bo po co.
        st.info("No persons yet.")
        return

    person = st.selectbox(
        "Chose a person", persons,
        format_func=lambda p: f'[id: {str(p["person_id"])}] {p["name"]}',
        disabled=is_editing(),
    )

    person_panel(person["person_id"])
