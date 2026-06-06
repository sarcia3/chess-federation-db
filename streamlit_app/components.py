"""
Rzeczy, które można używać ponownie
"""

import streamlit as st
from datetime import date

from queries import person_info, update_person, insert_person, country_options

_EDIT_FLAG = "person_editing"

GENDER_OPTIONS = ["Female","Male", "Other"]


def is_editing():
    return st.session_state.get(_EDIT_FLAG, False)


def add_person_panel():
    st.subheader("Add a person")
    with st.form("new_person_form", clear_on_submit=True):
        first = st.text_input("First name")
        last = st.text_input("Last name")
        dob = st.date_input(
            "Date of birth", value=None,
            min_value=date(1900, 1, 1),
            max_value=date.today(),
        )
        gender = st.selectbox("Gender", GENDER_OPTIONS, index=None)

        country = st.selectbox(
            "Country", country_options(), index=None,
            format_func=lambda c: c["name"],
        )

        save_col, clear_col = st.columns(2)
        if save_col.form_submit_button("Add", type="primary", key="save_btn_addperson", width="stretch"):
            try:
                insert_person(first, last, dob, gender, (country or {}).get("country_id"))
                st.success(f"Added {first} {last}.")
            except Exception as e:
                st.error(f"Adding person failed: {e}")
        if clear_col.form_submit_button("Clear changes", type="primary", key="clear_btn_addperson", width="stretch"):
            st.rerun()


def person_panel(person_id):
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
            st.rerun()
        return

    st.write("Enter new values:")
    first = st.text_input("First name", value=info["first_name"])
    last = st.text_input("Last name", value=info["last_name"])
    dob = st.date_input(
        "Date of birth", value=None,
        min_value=date(1900, 1, 1),
        max_value=date.today(),
    )
    gender = st.selectbox("Gender", GENDER_OPTIONS,
                          index=GENDER_OPTIONS.index(info["gender"]))
    countries = country_options()
    country_ids = [c["country_id"] for c in countries]
    country = st.selectbox(
        "Country", countries,
        index=country_ids.index(info["country_id"]),
        format_func=lambda c: c["name"],
    )

    save_col, clear_col = st.columns(2)
    if save_col.button("Save", type="primary", key="save_btn_edit", width="stretch"):
        update_person(person_id, first, last, dob, gender, country["country_id"])
        st.session_state[_EDIT_FLAG] = False
        st.rerun()
    if clear_col.button("Clear changes", type="primary", key="clear_btn_edit", width="stretch"):
        st.session_state[_EDIT_FLAG] = False
        st.rerun()
