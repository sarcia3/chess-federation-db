"""Chess tournament manager — Streamlit front-end for the project database.

Run with:   streamlit run app.py

This file is just the menu. It groups the screens into sidebar sections using
st.navigation: each dict key is a section header, each value is the list of
pages in that section. Every screen lives in its own module under screens/ and
exposes a render() function. Shared SQL helpers live in queries.py; the
connection in db.py.
"""

import streamlit as st

st.set_page_config(page_title="Chess Federation Manager", page_icon="♟", layout="wide")

from theme import load_styles
from screens import (
    landing_page, enter_results, add_game, browse, players, clubs,
    tournament_creator, rating_lists, rating_history, persons,
)

load_styles()  # Catppuccin CSS vars + styles/app.css, injected once per rerun

home = st.Page(landing_page.render, title="Home", url_path="home", default=True)

sections = {
    "Tournament": [
        st.Page(tournament_creator.render, title="Create tournament", url_path="tournament"),
        st.Page(enter_results.render, title="Enter results", url_path="enter-results"),
        st.Page(add_game.render, title="Add game", url_path="add-game"),
    ],
    "Registry": [
        st.Page(browse.render, title="Browse data", url_path="browse"),
        st.Page(persons.render, title="Persons", url_path="persons"),
        st.Page(players.render, title="Players", url_path="players"),
        st.Page(clubs.render, title="Clubs", url_path="clubs"),
    ],
    "Ratings": [
        st.Page(rating_lists.render, title="Rating lists", url_path="ratings"),
        st.Page(rating_history.render, title="Rating history", url_path="rating_history"),
    ],
}

all_pages = [home] + [page for pages in sections.values() for page in pages]
nav = st.navigation(all_pages, position="hidden")

with st.sidebar:
    st.page_link(home, label="♟ Chess Federation Manager")
    for header, pages in sections.items():
        st.subheader(header)
        for page in pages:
            st.page_link(page)

nav.run()
