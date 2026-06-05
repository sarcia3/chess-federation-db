"""Database access layer. (created by an LLM)

Reads connection settings from the project's existing
"CRUD GUI config.conf" (the connection block at the top of the file) and
exposes three tiny helpers used by the rest of the app:

    run_query(sql, params)  -> list of dict rows  (SELECT)
    run_exec(sql, params)   -> affected row count  (INSERT/UPDATE/DELETE)
    run_many(statements)    -> None                (several writes, one transaction)

Keeping all SQL in the calling code (or in the Postgres functions you already
wrote) means there is no hidden ORM magic to explain at the defense.
"""

import os

import psycopg2
import psycopg2.extras
import streamlit as st

CONFIG_NAME = "CRUD GUI config.conf"


def _find_config():
    """Look for the config file next to this script, then one level up."""
    here = os.path.dirname(os.path.abspath(__file__))
    for folder in (here, os.path.dirname(here)):
        candidate = os.path.join(folder, CONFIG_NAME)
        if os.path.exists(candidate):
            return candidate
    raise FileNotFoundError(f"Could not find '{CONFIG_NAME}'")


def _load_conn_params():
    """Parse the connection block (key: value lines) at the top of the config."""
    params = {}
    with open(_find_config(), encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            key, _, val = line.partition(":")
            params[key.strip()] = val.strip()

    host, _, port = params.get("url", "localhost:5432").partition(":")
    return {
        "host": host or "localhost",
        "port": port or "5432",
        "dbname": params["database"],
        "user": params["user"],
        "password": params["password"], # todo: make the app ask for the password
    }


@st.cache_resource
def get_connection():
    """One shared connection for the app (cached across reruns by Streamlit)."""
    conn = psycopg2.connect(**_load_conn_params())
    conn.autocommit = False
    return conn


def run_query(sql, params=None):
    conn = get_connection()
    try:
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            cur.execute(sql, params or ())
            rows = cur.fetchall()
        conn.commit()
        return [dict(r) for r in rows]
    except Exception:
        conn.rollback()  # leave the connection usable after an error
        raise


def run_exec(sql, params=None):
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, params or ())
            affected = cur.rowcount
        conn.commit()
        return affected
    except Exception:
        conn.rollback()
        raise


def run_many(statements):
    """Run several (sql, params) writes atomically in one transaction."""
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            for sql, params in statements:
                cur.execute(sql, params or ())
        conn.commit()
    except Exception:
        conn.rollback()
        raise
