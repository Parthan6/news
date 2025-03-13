from flask import Flask, request, jsonify
import requests
import nltk
from newspaper import Article
from flask_cors import CORS

nltk.download('punkt')

app = Flask(__name__)

CORS(app)


def summarize_news(url):
    try:
        
        #url = data.get('url')
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
    
@app.route('/summarize', methods=['GET'])
def summary():
    url = request.args.get('url')
    content = summarize_news(url)
    return content



if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)