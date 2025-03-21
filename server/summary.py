from flask import Flask, request, jsonify
import requests
import nltk
import os
from newspaper import Article
from flask_cors import CORS

#nltk.download('punkt')

#NLTK_DATA_PATH = "/opt/render/project/src/nltk_data"
#os.makedirs(NLTK_DATA_PATH, exist_ok=True)  # Ensure directory exists
#nltk.data.path.append(NLTK_DATA_PATH)  # Add it to NLTK's search path
#nltk.download('punkt', download_dir=NLTK_DATA_PATH)  # Download to custom directory



# Set a persistent NLTK data directory
NLTK_DATA_PATH = "/opt/render/project/src/nltk_data"
os.makedirs(NLTK_DATA_PATH, exist_ok=True)  # Ensure directory exists
nltk.data.path.append(NLTK_DATA_PATH)  # Add it to NLTK's search path

# Download 'punkt' and 'punkt_tab' explicitly
nltk.download('punkt', download_dir=NLTK_DATA_PATH)
nltk.download('punkt_tab', download_dir=NLTK_DATA_PATH)

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