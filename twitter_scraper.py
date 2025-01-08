"""
twitter_scraper.py
Author: Niwin Kumar
Created: January 2025
"""

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.proxy import Proxy, ProxyType
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException, NoSuchElementException
from webdriver_manager.chrome import ChromeDriverManager
import random
import requests
import uuid
from datetime import datetime
import os
from dotenv import load_dotenv

load_dotenv()

PROXY_LIST = os.environ.get("PROXY_LIST").split(',')

class TwitterScraper:
    def __init__(self):
        self.proxy_address = self._get_new_proxy()
        self.driver = self._configure_driver()
        self.results = []

    def _get_new_proxy(self):
        return random.choice(PROXY_LIST)

    def _configure_driver(self):
        proxy = Proxy()
        proxy.proxy_type = ProxyType.MANUAL
        proxy.http_proxy = proxy.ssl_proxy = self.proxy_address

        options = Options()
        options.add_argument("--headless")  # Run in headless mode for Docker
        options.add_argument("--no-sandbox")  # Required for Docker
        options.add_argument("--disable-dev-shm-usage")  # Overcome limited shared memory
        options.add_argument("--disable-notifications")  # Disable notifications
        options.add_argument("--start-maximized")  # Maximize window size (optional for headless mode)
        options.add_argument("--disable-gpu")  # Disable GPU hardware acceleration in headless mode
        options.proxy = proxy

        # Setup Chrome driver
        return webdriver.Chrome(
            service=Service(ChromeDriverManager().install()), 
            options=options
        )

    def _log_result(self, step, status, message=""):
        self.results.append({
            "Step": step, 
            "Status": status, 
            "Message": message
        })

    def get_external_ip(self, retries=3, timeout=10):
        if not isinstance(self.proxy_address, str) or not self.proxy_address.startswith("http"):
            return {"ip": None, "error": "Invalid proxy address format"}
        
        proxies = {
            "http": self.proxy_address, 
            "https": self.proxy_address
        }
        
        for attempt in range(1, retries + 1):
            try:
                response = requests.get(
                    "https://api.ipify.org?format=json", 
                    proxies=proxies, 
                    timeout=timeout
                )
                response.raise_for_status()
                ip_address = response.json().get("ip")
                return {"ip": ip_address, "error": None} if ip_address else {"ip": None, "error": "IP address not found"}
            except requests.exceptions.ProxyError:
                return {"ip": None, "error": "Proxy authentication failed"}
            except requests.exceptions.ConnectTimeout:
                print(f"Attempt {attempt}: Connection timed out. Retrying...")
            except requests.exceptions.RequestException as e:
                print(f"Attempt {attempt}: Error occurred - {e}")
            
            if attempt < retries:
                print("Retrying...")
        
        return {"ip": None, "error": "Failed after retries"}

    def login(self, username, password):
        try:
            self.driver.get("https://twitter.com/login")
            print("Navigating to Twitter login page...")

            username_field = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.XPATH, "//input[@name='text']"))
            )
            username_field.send_keys(username)
            username_field.send_keys(Keys.RETURN)
            print("Entered username")

            password_field = WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.XPATH, "//input[@name='password']"))
            )
            password_field.send_keys(password)
            password_field.send_keys(Keys.RETURN)
            print("Entered password")

            WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.XPATH, "//div[@aria-label='Timeline: Trending now']"))
            )
            self._log_result("Login", "Success")
            print("Login successful")
            return True

        except Exception as e:
            self._log_result("Login", "Failure", str(e))
            print(f"Login failed: {str(e)}")
            return False

    def get_trending_topics(self):
        try:
            trending_section = WebDriverWait(self.driver, 30).until(
                EC.presence_of_element_located((By.XPATH, "//div[contains(@aria-label, 'Timeline: Trending now')]"))
            )
            trending_topics = trending_section.find_elements(By.XPATH, ".//span[contains(@dir, 'ltr')]")
            return [topic.text for topic in trending_topics if topic.text][:5]
        except NoSuchElementException:
            self._log_result("Fetch Trending Topics", "Failure", "Trending section not found")
            return []

    def close(self):
        self.driver.quit()
