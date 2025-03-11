from flask import Flask, request, jsonify
import requests
from bs4 import BeautifulSoup
import nltk
from newspaper import Article
from flask_cors import CORS
from pymongo import MongoClient
from datetime import datetime
import schedule
import time
import threading





MONGO_URI = "mongodb+srv://news_db:newsdbPass%40123@news.pdam6.mongodb.net/?retryWrites=true&w=majority&appName=News"
client = MongoClient(MONGO_URI)
db = client["news_database"]
collection = db["daily_news"]



nltk.download('punkt')

app = Flask(__name__)

CORS(app)


def fetch_todays_news():
    try:
        url = "https://www.thehindu.com/"
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')

        news_data = []

        # Extracting news from The Hindu
        news_items = soup.find_all("h3", class_="title")
        for item in news_items:
            headline = item.get_text(strip=True)
            link_tag = item.find("a")
            if link_tag:
                link = link_tag.get("href")
                if link:
                    link = link if link.startswith('https') else f"https://www.thehindu.com{link}"
                    news_data.append({"title": headline, "content": summarize_content(link)})

        if not news_data:
            return {"error": "No headlines found on The Hindu."}

        return news_data

    except Exception as e:
        return {"error": str(e)}

def get_newsapi_data():
    """Fetch top news from NewsAPI."""
    try:
        api_key = "7becca76f77e4b62a4e73579f77250a3"
        url = f"https://newsapi.org/v2/top-headlines?country=us&apiKey={api_key}"
        response = requests.get(url)
        response.raise_for_status()
        json_data = response.json()

        news_data = []
        for article in json_data["articles"]:
            if "title" in article and "url" in article:
                summary = summarize_content(article["url"])
                news_data.append({"title": article["title"], "summary": summary, "link": article["url"]})

        return news_data
    except Exception as e:
        return []




def summarize_content(url):
    """Summarize news articles using newspaper3k."""
    try:
        article = Article(url)
        article.download()
        article.parse()
        article.nlp()
        return article.summary
    except:
        return "Failed to summarize."




def store_news():
    """Store today's news in MongoDB."""
    today = datetime.today().strftime('%Y-%m-%d')
    
    # Check if news for today already exists
    existing_data = collection.find_one({"date": today})

    if not existing_data:
        indian_news = fetch_todays_news()
        international_news = get_newsapi_data()

        if indian_news or international_news:
            collection.insert_one({
                "date": today,
                "indian_news": indian_news,
                "international_news": international_news
            })
            print("✅ Today's news stored successfully in MongoDB.")
        else:
            print("⚠️ No news found for today.")
    else:
        print("⚠️ News for today already exists in MongoDB.")





@app.route('/fetch_stored_news', methods=['GET'])
def get_stored_news():
    """Retrieve stored news from MongoDB."""
    # today = datetime.today().strftime('%Y-%m-%d')
    # news_data = collection.find_one({"date": today}, {"_id": 0})

    date = request.args.get('date', datetime.today().strftime('%Y-%m-%d'))  # Get date from request or default to today
    news_data = collection.find_one({"date": date}, {"_id": 0})

    if news_data:
        return jsonify(news_data)
    else:
        return jsonify({"error": "No news available for today"}), 404




# Schedule daily news storage at 6:00 AM
schedule.every().day.at("06:00").do(store_news)

def run_scheduler():
    """Run scheduled task in a separate thread."""
    while True:
        schedule.run_pending()
        time.sleep(60)

# Start scheduler in a background thread
threading.Thread(target=run_scheduler, daemon=True).start()



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
