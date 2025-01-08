import os
from dotenv import load_dotenv

load_dotenv()

PASSWORD = os.environ.get("PASSWORD")
TWTUSERNAME = os.environ.get("TWTUSERNAME") 
MONGO_URI = os.environ.get("MONGO_URI")
MONGO_DB = os.environ.get("MONGO_DB")
MONGO_COLLECTION = os.environ.get("MONGO_COLLECTION")
PROXY_LIST = os.environ.get("PROXY_LIST")

print (PASSWORD)
print (TWTUSERNAME)
print (MONGO_URI)
print (MONGO_DB)
print (MONGO_COLLECTION)
print (PROXY_LIST)