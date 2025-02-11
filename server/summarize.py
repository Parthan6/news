from flask import Flask, request, jsonify
from newspaper import Article
from transformers import pipeline

app = Flask(__name__)

# Load the summarization model
summarizer = pipeline("summarization", model="sshleifer/distilbart-cnn-12-6")

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

        max_input_length = 1024
        chunks = split_text(article.text, max_input_length)


        # Summarize the article
        summaries = [summarizer(chunk, max_length=130, min_length=30, do_sample=False)[0]['summary_text'] for chunk in chunks]
        combined_summary = " ".join(summaries)
        return jsonify({'title': article.title, 'summary': combined_summary})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
