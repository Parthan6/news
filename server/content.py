from flask import Flask, request, jsonify
import requests
from bs4 import BeautifulSoup
import nltk
from newspaper import Article

nltk.download('punkt')

app = Flask(__name__)


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
                    news_data.append({"title": headline, "content": link})

        if not news_data:
            return {"error": "No headlines found on The Hindu."}

        return {"news": news_data}

    except Exception as e:
        return {"error": str(e)}


@app.route('/fetch_news', methods=['GET'])
def get_news():
    news_data = fetch_todays_news()
    return jsonify(news_data)


@app.route('/summarize', methods=['POST'])
def summarize_news():
    try:
        data = request.json
        url = data.get('url')
        if not url:
            return jsonify({'error': 'URL is required'}), 400

        # Extract news from the URL
        article = Article(url)
        article.download()
        article.parse()
        article.nlp()

        return jsonify({'title': article.title, 'summary': article.summary})

    except Exception as e:
        return jsonify({'error': str(e)}), 500



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
