"""
app.py
Author: Niwin Kumar
Created: January 2025
"""

from flask import Flask, jsonify, render_template
from main import fetch_trending_topics
from database import Database
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/run-script", methods=["GET"])
def run_script():
    try:
        success = fetch_trending_topics()
        return jsonify({
            "status": "success" if success else "error",
            "message": "Script executed successfully!" if success else "Failed to execute script"
        })
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

@app.route("/get-latest-results", methods=["GET"])
def get_latest_results():
    try:
        latest_record = Database.get_latest_result()
        if latest_record:
            latest_record["_id"] = str(latest_record["_id"])
            return jsonify(latest_record)
        return jsonify({
            "status": "error", 
            "message": "No records found in the database."
        })
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)})

if __name__ == "__main__":
    app.run(debug=True)