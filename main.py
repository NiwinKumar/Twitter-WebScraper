"""
main.py
Author: Niwin Kumar
Created: January 2025
"""

from twitter_scraper import TwitterScraper
from database import Database
from datetime import datetime
import uuid

def fetch_trending_topics():
    scraper = TwitterScraper()
    try:
        if scraper.login("iamniwin", "Very@sec7#"):
            trends = scraper.get_trending_topics()
            if trends:
                unique_id = str(uuid.uuid4())
                ip_info = scraper.get_external_ip()
                end_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                Database.store_results(trends, unique_id, end_time, ip_info)
                return True
        return False
    except Exception as e:
        print(f"Error in fetch_trending_topics: {e}")
        return False
    finally:
        scraper.close()