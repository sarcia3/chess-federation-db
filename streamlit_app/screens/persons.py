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
        st.info("No persons yet.")
        return

    # Picker is locked while editing so the record can't change under the form.
    person = st.selectbox(
        "Chose a person", persons,
        format_func=lambda p: f'[id: {str(p["person_id"])}] {p["name"]}',
        disabled=is_editing(),
    )

    # A player's editable data is all on its person, so delegate to the shared
    # editor. A persons screen would call person_panel() the exact same way.
    person_panel(person["person_id"])
