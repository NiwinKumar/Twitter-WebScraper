"""
database.py
Author: Niwin Kumar
Created: January 2025
"""

from pymongo import MongoClient
import os
from dotenv import load_dotenv

load_dotenv()

MONGO_URI = os.environ.get("MONGO_URI")
MONGO_DB = os.environ.get("MONGO_DB")
MONGO_COLLECTION = os.environ.get("MONGO_COLLECTION")

class Database:
    @staticmethod
    def store_results(trends, unique_id, end_time, ip_address):
        try:
            with MongoClient(MONGO_URI) as client:
                collection = client[MONGO_DB][MONGO_COLLECTION]
                document = {
                    "unique_id": unique_id,
                    "trends": trends,
                    "end_time": end_time,
                    "ip_address": ip_address,
                }
                collection.insert_one(document)
                print("Results stored in MongoDB:", document)
                return True
        except Exception as e:
            print(f"Error storing in MongoDB: {e}")
            return False

    @staticmethod
    def get_latest_result():
        try:
            with MongoClient(MONGO_URI) as client:
                collection = client[MONGO_DB][MONGO_COLLECTION]
                return collection.find_one(sort=[("_id", -1)])
        except Exception as e:
            print(f"Error fetching from MongoDB: {e}")
            return None