"""
stuprocentowy LLM, jest tu tylko po to, żeby aplikacja używała palety kolorów, którą lubie


Bridge between the Catppuccin palette in .streamlit/config.toml and our CSS.

config.toml is the single source of truth for the hex values. This module reads
the per-flavor semantic colors out of it, exposes them to the page as CSS custom
properties (--ctp-*), then appends styles/app.css (which references those
variables, never raw hex). Call load_styles() once per run, from app.py.

The light values apply by default; the dark values kick in under a dark color
scheme via a prefers-color-scheme media query. (That follows the OS setting, not
Streamlit's manual ⋮ -> Settings theme picker — there's no CSS hook for that.)
"""

from functools import lru_cache
from pathlib import Path
import tomllib

import streamlit as st

_ROOT = Path(__file__).parent
_CONFIG = _ROOT / ".streamlit" / "config.toml"
_CSS = _ROOT / "styles" / "app.css"

# CSS variable  ->  config.toml [theme.*] key. Add a row to expose more colors.
_VARS = {
    "--ctp-green": "greenColor",
    "--ctp-red": "redColor",
    "--ctp-on-accent": "backgroundColor",  # Base: light in Latte, dark in Mocha
}


@lru_cache
def _flavors():
    theme = tomllib.loads(_CONFIG.read_text())["theme"]
    return theme["light"], theme["dark"]


def _vars_block(flavor):
    decls = "".join(f"{var}:{flavor[key]};" for var, key in _VARS.items())
    return f":root{{{decls}}}"


@lru_cache
def _stylesheet():
    light, dark = _flavors()
    return (
        _vars_block(light)
        + f"@media (prefers-color-scheme: dark){{{_vars_block(dark)}}}"
        + _CSS.read_text()
    )


def load_styles():
    """Inject the Catppuccin CSS variables + app stylesheet. Call once per run."""
    st.html(f"<style>{_stylesheet()}</style>")
