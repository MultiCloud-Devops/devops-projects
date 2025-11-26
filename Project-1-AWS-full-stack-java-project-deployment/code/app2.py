import streamlit as st
import requests
import os
import json
from urllib.parse import urlparse, parse_qs

# --- Config ---
st.set_page_config(page_title="Students DataStore", page_icon="📚", layout="wide")
st.markdown("<style>#MainMenu {visibility: hidden;} footer {visibility: hidden;}</style>", unsafe_allow_html=True)

API_URL = os.environ.get("API_URL", "http://localhost:8081")
COGNITO_DOMAIN = "https://us-east-19jcz6z2bp.auth.us-east-1.amazoncognito.com"
CLIENT_ID = "46skrkuolbk61crp84r74s39ar"
REDIRECT_URI = "https://datastore.krishnal.shop"
TOKEN_ENDPOINT = f"{COGNITO_DOMAIN}/oauth2/token"
USERINFO_ENDPOINT = f"{COGNITO_DOMAIN}/oauth2/userInfo"
SESSION_FILE = "user_session.json"

# --- Auth Helpers ---
def save_session(data):
    with open(SESSION_FILE, "w") as f:
        json.dump(data, f)

def load_session():
    try:
        with open(SESSION_FILE, "r") as f:
            return json.load(f)
    except:
        return None

def exchange_code_for_token(code):
    data = {
        "grant_type": "authorization_code",
        "client_id": CLIENT_ID,
        "code": code,
        "redirect_uri": REDIRECT_URI
    }
    headers = {"Content-Type": "application/x-www-form-urlencoded"}
    response = requests.post(TOKEN_ENDPOINT, data=data, headers=headers)
    return response.json() if response.status_code == 200 else None

def fetch_user_info(access_token):
    headers = {"Authorization": f"Bearer {access_token}"}
    response = requests.get(USERINFO_ENDPOINT, headers=headers)
    return response.json() if response.status_code == 200 else None

# --- Handle Redirect with Code ---
query_params = st.query_params
if "code" in query_params:
    token_data = exchange_code_for_token(query_params["code"])
    if token_data and "access_token" in token_data:
        user_info = fetch_user_info(token_data["access_token"])
        if user_info:
            save_session({
                "access_token": token_data["access_token"],
                "email": user_info.get("email", "Unknown")
            })
            st.experimental_set_query_params()  # Clear URL
            st.rerun()

# --- Load Session ---
user = load_session()
if not user:
    login_url = (
        f"{COGNITO_DOMAIN}/login?response_type=code"
        f"&client_id={CLIENT_ID}&redirect_uri={REDIRECT_URI}"
        f"&scope=email+openid+phone"
    )
    st.warning(f"🔒 You are not logged in. [Click here to login]({login_url})")
    st.stop()
else:
    st.success(f"Welcome, {user.get('email', 'User')}! [Logout](https://datastore.krishnal.shop/logout)")

# --- Main App ---
st.title("Student DataStore")
tab1, tab2, tab3 = st.tabs(["Add Student", "Search Student", "List Students"])

with tab1:
    st.header("Add a new student")
    with st.form("add_student_form"):
        name = st.text_input("Name")
        age = st.number_input("Age", min_value=1, max_value=100, value=18)
        submit_button = st.form_submit_button("Add Student")
        if submit_button:
            if name:
                try:
                    headers = {"Authorization": f"Bearer {user['access_token']}"}
                    response = requests.post(f"{API_URL}/student/post", json={"name": name, "age": age}, headers=headers)
                    if response.status_code == 200:
                        st.success(f"✅ Student {name} added successfully!")
                    else:
                        st.error(f"❌ Error adding student: {response.text}")
                except requests.exceptions.RequestException as e:
                    st.error(f"⚠️ Connection error: {e}")
            else:
                st.warning("⚠️ Please fill in all required fields.")

with tab2:
    st.header("Search for a student")
    search_name = st.text_input("Enter student name to search")
    if st.button("Search") and search_name:
        try:
            headers = {"Authorization": f"Bearer {user['access_token']}"}
            response = requests.get(f"{API_URL}/student/get/{search_name}", headers=headers)
            if response.status_code == 200:
                student = response.json()
                st.subheader("Student Information")
                st.write(f"**Name:** {student.get('name', 'N/A')}")
                st.write(f"**Age:** {student.get('age', 'N/A')}")
            else:
                st.warning(f"Student with name '{search_name}' not found.")
        except requests.exceptions.RequestException as e:
            st.error(f"⚠️ Connection error: {e}")

with tab3:
    st.header("List of all students")
    if st.button("Refresh List"):
        try:
            headers = {"Authorization": f"Bearer {user['access_token']}"}
            response = requests.get(f"{API_URL}/student/all", headers=headers)
            if response.status_code == 200:
                students = response.json()
                if students:
                    student_data = [{"Name": s.get("name", "N/A"), "Age": s.get("age", "N/A")} for s in students]
                    st.table(student_data)
                else:
                    st.info("No students found in the database.")
            else:
                st.error("Failed to retrieve student list.")
        except requests.exceptions.RequestException as e:
            st.error(f"⚠️ Connection error: {e}")
