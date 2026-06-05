"""Chess tournament manager — Streamlit front-end for the project database.

Run with:   streamlit run app.py

This file is just the menu. It groups the screens into sidebar sections using
st.navigation: each dict key is a section header, each value is the list of
pages in that section. Every screen lives in its own module under screens/ and
exposes a render() function. Shared SQL helpers live in queries.py; the
connection in db.py.
"""

import streamlit as st

st.set_page_config(page_title="Chess Tournament Manager", page_icon="♟", layout="wide")

from theme import load_styles
from screens import enter_results, add_game, browse, players

load_styles()  # Catppuccin CSS vars + styles/app.css, injected once per rerun

st.sidebar.title("♟ Tournament Manager")

# Dict -> sections. The keys ("Tournament", "Data view") become the submenu
# headers; each screen is an st.Page wrapping that module's render() function.
# url_path must be set explicitly because all the functions are named "render"
# (otherwise their auto-generated paths would collide).
nav = st.navigation(
    {
        "Tournament": [
            st.Page(enter_results.render, title="Enter results",
                    url_path="enter-results", default=True),
            st.Page(add_game.render, title="Add game",
                    url_path="add-game"),
        ],
        "Data view": [
            st.Page(browse.render, title="Browse data",
                    url_path="browse"),
            st.Page(players.render, title="Players",
                    url_path="players"),
        ],
    }
)

nav.run()
