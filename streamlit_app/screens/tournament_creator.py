import streamlit as st

from queries import *
from components import person_panel

def new_tournament():
    st.subheader("Create a new tournament")
    # clear_on_submit wipes every field after any submit button, so Clear (and a
    # successful Add) reset the form without manually resetting widget state.
    with st.form("new_tournament_form", clear_on_submit=True):
        tournament_name = st.text_input("Tournament name")
        country = st.selectbox(
            "Country", country_options(),
            index=None,
            format_func=lambda c: c["name"],
        )
        city = st.text_input("City")
        street_address = st.text_input("Street address")
        chess_type = st.selectbox(
            "Chess type", chess_type_options(),
            index=None,
            format_func=lambda c: c["name"],
        )
        date_from = st.date_input("Date from")
        date_to = st.date_input("Date to", value=date_from, min_value=date_from)
        main_arbiter = (
            st.selectbox("Arbiter", arbiter_options(), index=None, format_func=lambda p: p["name"], key="white"))

        time_control = st.selectbox(
            "Time control" ,
            time_control_options(),
            index=None,
            format_func=lambda t: f'{t["starting_time"]} min + {t["increment"]} sec/move')

        save_col, clear_col = st.columns(2)
        if save_col.form_submit_button("Add", type="primary", key="save_btn", width="stretch"):
            try:
                insert_tournament(
                    tournament_name,
                    city,
                    street_address,
                    (country or {}).get("country_id"),
                    (chess_type or {}).get("chess_type_id"),
                    (main_arbiter or {}).get("arbiter_id"),
                    (time_control or {}).get("time_control_id"),
                    date_from,
                    date_to)
                st.success(f'Tournament "{tournament_name}" created successfully')
            except Exception as e:
                st.error(f'Tournament creation failed: {e}')
        if clear_col.form_submit_button("Clear changes", type="primary", key="clear_btn", width="stretch"):
            st.rerun()
def render():
    #TODO dodaj osobny tab na edycje. Postaraj sie DRY aby byly podpowiedzi dzialajace
    new_tournament()


