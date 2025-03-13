from flask import Flask, request, jsonify, session
import firebase_admin
from firebase_admin import auth, credentials
from flask_cors import CORS

# Initialize Flask app
app = Flask(__name__)
app.secret_key = "your_secret_key"  # Required for session management
CORS(app)

# Initialize Firebase Admin SDK
cred = credentials.Certificate("path/to/your/firebase_credentials.json")
firebase_admin.initialize_app(cred)

@app.route("/signup", methods=["POST"])
def signup():
    data = request.json
    email = data.get("email")
    password = data.get("password")
    try:
        user = auth.create_user(email=email, password=password)
        return jsonify({"message": "User created successfully", "uid": user.uid}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 400

@app.route("/login", methods=["POST"])
def login():
    data = request.json
    email = data.get("email")
    password = data.get("password")
    try:
        user = auth.get_user_by_email(email)
        session['user_id'] = user.uid  # Store user session
        return jsonify({"message": "Login successful", "uid": user.uid}), 200
    except Exception as e:
        return jsonify({"error": "Invalid credentials"}), 401

@app.route("/logout", methods=["POST"])
def logout():
    session.pop("user_id", None)
    return jsonify({"message": "Logged out successfully"}), 200

@app.route("/main_screen", methods=["GET"])
def main_screen():
    if "user_id" in session:
        return jsonify({"message": "Welcome to the Main Screen!", "user_id": session["user_id"]}), 200
    return jsonify({"error": "Unauthorized"}), 401

if __name__ == "__main__":
    app.run(debug=True)
