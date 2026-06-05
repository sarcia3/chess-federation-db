"""Reusable UI pieces shared across screens.

person_panel() is the single source of truth for viewing/editing a person. A
player has no editable fields of its own (the players table is just player_id +
person_id), so editing a player IS editing its person — the players screen and
any future persons screen both call person_panel() with the same person_id.
"""

import streamlit as st

from queries import person_info, update_person, country_options

# Edit mode lives in session_state so it survives the rerun a button click
# triggers (a plain local would reset every run). Screens read is_editing() to
# lock their record picker while an edit is in progress.
_EDIT_FLAG = "person_editing"

# Matches the GENDER enum in create.sql: ('Male', 'Female', 'Other').
GENDER_OPTIONS = ["Male", "Female", "Other"]


def is_editing():
    return st.session_state.get(_EDIT_FLAG, False)


def person_panel(person_id):
    """Show one person's details, with an inline Edit -> Save/Clear cycle."""
    info = person_info(person_id)[0]

    if not is_editing():
        st.markdown(f"### {info['first_name']} {info['last_name']}")
        for label, value in {
            "Date of birth": info["date_of_birth"],
            "Gender": info["gender"],
            "Country": info["country"],
        }.items():
            st.write(f"**{label}:** {value}")
        if st.button("Edit", type="primary"):
            st.session_state[_EDIT_FLAG] = True
            st.rerun()  # redraw now so the picker locks and the form appears
        return

    # Edit mode: proper widgets per field type so we don't break the FK/enum.
    st.write("Enter new values:")
    first = st.text_input("First name", value=info["first_name"])
    last = st.text_input("Last name", value=info["last_name"])
    dob = st.date_input("Date of birth", value=info["date_of_birth"])
    gender = st.selectbox("Gender", GENDER_OPTIONS,
                          index=GENDER_OPTIONS.index(info["gender"]))
    countries = country_options()
    country_ids = [c["country_id"] for c in countries]
    country = st.selectbox(
        "Country", countries,
        index=country_ids.index(info["country_id"]),
        format_func=lambda c: c["name"],
    )

    # Button colors live in styles/app.css, keyed off save_btn / clear_btn.
    save_col, clear_col = st.columns(2)
    if save_col.button("Save", type="primary", key="save_btn", width="stretch"):
        update_person(person_id, first, last, dob, gender, country["country_id"])
        st.session_state[_EDIT_FLAG] = False
        st.rerun()
    if clear_col.button("Clear changes", type="primary", key="clear_btn", width="stretch"):
        st.session_state[_EDIT_FLAG] = False
        st.rerun()
