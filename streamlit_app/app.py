"""
Główny plik frontedu bazy.
Duża część z tego była wygenerowana z użyciem LLMa, bo nie mam doświadczenia w pisaniu frontendu.
Jednak od momentu gdy zaczęłam rozumieć jak to mniej więcej działa, używałam go coraz mniej i
kod pisałam w większości sama. Wszystkie SQLowe rzeczy pisałam sama.

Rozumiem cały kod i jestem w stanie każdą linijkę wyjaśnić na obronie.
"""

import streamlit as st

st.set_page_config(page_title="Chess Federation Manager", page_icon="♟", layout="wide")

from theme import load_styles

from screens import (
    landing_page, enter_results, pairings, debug_browse, players, clubs,
    tournament_creator, rating_lists, rating_history, persons, tournament_players,
)

load_styles()

home = st.Page(landing_page.render, title="Home", url_path="home", default=True)

debug = st.session_state.get("debug_mode", False)

sections = {
    "Tournament": [
        st.Page(tournament_creator.render, title="Create tournament", url_path="tournament"),
        st.Page(tournament_players.render, title="Players and results", url_path="tournament_players"),
        st.Page(enter_results.render, title="Enter results", url_path="enter-results"),
        st.Page(pairings.render, title="Pairings", url_path="pairings"),
    ],
    "Registry": [
        st.Page(persons.render, title="Persons", url_path="persons"),
        st.Page(players.render, title="Players", url_path="players"),
        st.Page(clubs.render, title="Clubs", url_path="clubs"),
    ],
    "Ratings": [
        st.Page(rating_lists.render, title="Rating lists", url_path="ratings"),
        st.Page(rating_history.render, title="Rating history", url_path="rating_history"),
    ],
}

if debug:
    sections["Debug"] = [
        st.Page(debug_browse.render, title="Browse data", url_path="browse"),
    ]

all_pages = [home] + [page for pages in sections.values() for page in pages]
nav = st.navigation(all_pages, position="hidden")

with st.sidebar:
    st.page_link(home, label="♟ Chess Federation Manager")
    for header, pages in sections.items():
        st.subheader(header)
        for page in pages:
            st.page_link(page)
    st.toggle("Debug mode", key="debug_mode")

nav.run()
