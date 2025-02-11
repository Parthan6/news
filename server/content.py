from flask import Flask, request, jsonify
import nltk
from newspaper import Article

# Ensure necessary NLTK data packages are downloaded
nltk.download('punkt_tab')


app = Flask(__name__)

# Load the summarization model


@app.route('/summarize', methods=['POST'])
def summarize_news():
    try:
        data = request.json
        url = data.get('url')
        if not url:
            return jsonify({'error': 'URL is required'}), 400

        # Extract news from the URL
        # Create an Article object
        article = Article(url)

        # Download and parse the article
        article.download()
        article.parse()

        # Perform Natural Language Processing (NLP)
        article.nlp()

        return jsonify({'title': article.title, 'summary': article.summary})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
