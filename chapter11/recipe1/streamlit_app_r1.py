import streamlit as st
import pandas as pd
from snowflake.snowpark.context import get_active_session

session = get_active_session()

# Streamlit interface
st.title("Snowflake Data Viewer - SFCBed2 - Streamlit R1")

st.write("Fetching data from Snowflake...")

# Query the data from Snowflake and display the data as a table using pandas
st.write(session.table("sample_data_streamlit_r1").to_pandas())

