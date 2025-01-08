
# X / Twitter Trending Topics Web Application

This web application allows you to view the latest trending topics on Twitter (X) by using a Flask backend and a MongoDB database to store trending topics. The app uses Selenium for web scraping and Proxymesh for proxy rotation to fetch the trends.

## Features

- Fetch the latest trending topics on Twitter (X).
- Store trends data in MongoDB for later access.
- Use proxy rotation through Proxymesh to avoid scraping restrictions.
- Display the trending topics on a simple and user-friendly web interface.
- View detailed information about the latest trends in a JSON format.

## Technologies Used

- **Flask**: Python web framework for the backend.
- **Selenium**: Web scraping tool to fetch trending topics from Twitter.
- **MongoDB**: NoSQL database for storing trends data.
- **Proxymesh**: Proxy service for bypassing restrictions on web scraping.

## Setup Instructions

Follow the steps below to set up the project on your local machine.

### Prerequisites

- Python 3.7 or higher
- MongoDB (either local or cloud-based via MongoDB Atlas)
- Proxymesh account (for proxy access)

### Step 1: Clone the Repository

Clone the repository to your local machine:

```bash
git clone https://github.com/yourusername/trending-topics-app.git
cd trending-topics-app
```

### Step 2: Create a Virtual Environment

It's recommended to create a virtual environment for the project to manage dependencies:

```bash
python -m venv venv
source venv/bin/activate  # On Windows, use `venv\Scriptsctivate`
```

### Step 3: Install Dependencies

Install the required dependencies listed in `requirements.txt`:

```bash
pip install -r requirements.txt
```

### Step 4: Set Up MongoDB

1. **Create a MongoDB Cluster**:
   - Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas) and create a free-tier cluster.
   - Once the cluster is created, create a new database (e.g., `trending_topics`) and a collection (e.g., `trends`).

2. **Obtain MongoDB URI**:
   - In the MongoDB Atlas dashboard, click on **Connect** for your cluster.
   - Choose **Connect your application**, and copy the connection string (e.g., `mongodb+srv://<username>:<password>@cluster.mongodb.net/<dbname>`).

3. **Update MongoDB URI**:
   - Open the `app.py` file in your project.
   - Find the section where the MongoDB URI is configured and replace the placeholder `<username>`, `<password>`, and `<dbname>` with your MongoDB Atlas credentials and database name.

   ```python
   client = MongoClient('mongodb+srv://<username>:<password>@cluster.mongodb.net/<dbname>')
   ```

### Step 5: Set Up Proxymesh

1. **Sign Up for Proxymesh**:
   - Go to [Proxymesh](https://proxymesh.com/) and sign up for an account.
   - After signing up, you will receive your **Proxymesh username** and **password**.

2. **Update Proxy Credentials**:
   - Open the `app.py` file and find the section where proxy credentials are used.
   - Replace the `PROXY_USER` and `PROXY_PASS` with your Proxymesh username and password.

   ```python
   PROXY_USER = '<your-proxymesh-username>'
   PROXY_PASS = '<your-proxymesh-password>'
   ```

### Step 6: Run the Application

To start the Flask app, run:

```bash
python app.py
```

This will start the server, and the web app should be accessible at `http://127.0.0.1:5000`.

### Step 7: Access the Trending Topics

- Go to `http://127.0.0.1:5000` in your browser.
- Click on **Get Trending Topics** to fetch the latest trends from Twitter (X).
- You will see the trending topics displayed on the page along with additional information in JSON format.

## File Structure

```
trending-topics-app/
├── app.py                  # Main Flask application file
├── requirements.txt        # Dependencies for the project
├── templates/
│   └── index.html          # HTML template for displaying trends
├── static/
│   └── styles.css          # Custom CSS for styling
└── README.md               # Project documentation
```

## Troubleshooting

1. **Error: Proxy Authentication Failed**:
   - Ensure that your Proxymesh username and password are correct in the `app.py` file.

2. **Error: MongoDB Connection Failed**:
   - Double-check the MongoDB URI and credentials in the `app.py` file.
   - Ensure that your MongoDB Atlas cluster allows connections from your IP address.

3. **Selenium Issues**:
   - If you encounter issues with Selenium or the webdriver, try updating the WebDriver Manager or the browser driver.

## License

This project is open source and available under the [MIT License](LICENSE).

## Author

By [Niwin Kumar](https://github.com/yourusername)

---

Feel free to contribute or report issues in the repository!
