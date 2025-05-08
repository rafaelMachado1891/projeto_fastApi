import streamlit as st
import os

uploaded_files = st.file_uploader(
    "import to PDF file", accept_multiple_files=True, type="pdf"
)

save_path = os.path.join("..\\data")


if uploaded_files:
    for file in uploaded_files:
        file_path = os.path.join(save_path, file.name)
        with open(file_path, "wb") as f:
            f.write(file.read())
        st.success(f"Arquivo salvo: {file.name}")