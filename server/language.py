from flask import Flask, request, jsonify
import requests
from bs4 import BeautifulSoup
import nltk
#from newspaper import Article
from flask_cors import CORS
#from pymongo import MongoClient
#from datetime import datetime
#import schedule
#import time
#import threading

nltk.download('punkt')

app = Flask(__name__)

CORS(app)




def today_language_news(url):
    try:
        
        
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        response = requests.get(url, headers=headers,timeout=10)
        response.raise_for_status()
        soup = BeautifulSoup(response.text, 'html.parser')

        news_data = []

        

        if "manoramaonline.com" in url:
            # Adjusted selector for The Hindu
            news_items = soup.find_all("h2", class_="cmp-story-list__title")
            #print(news_items)
            for item in news_items:
                headline = item.get_text(strip=True)
                link_tag = item.find("a")
                if link_tag:
                    link = link_tag.get("href")
                    if link:
                        # Ensure absolute link
                        link = link if link.startswith('https') else f"https://www.manoramaonline.com{link}"
                        news_data.append({"title":headline,"link":link})

        if "jagran.com" in url:
            # Adjusted selector for The Hindu
            news_items = soup.find_all("article", class_="Editorial_CardStory__text__riX5H CardStory__text")
            #print(news_items)
            for item in news_items:
                headline = item.get_text(strip=True)
                link_tag = item.find("a")
                if link_tag:
                    link = link_tag.get("href")
                    if link:
                        # Ensure absolute link
                        link = link if link.startswith('https') else f"https://www.jagran.com{link}"
                        news_data.append({"title":headline,"link":link})



        
        if "bartamanpatrika.com" in url:
            # Adjusted selector for The Hindu
            news_items = soup.find_all("div", class_="entry-content align-self-center")
            #print(news_items)
            for item in news_items:
                headline = item.get_text(strip=True)
                link_tag = item.find("a")
                if link_tag:
                    link = link_tag.get("href")
                    if link:
                        # Ensure absolute link
                        link = link if link.startswith('https') else f"https://bartamanpatrika.com{link}"
                        news_data.append({"title":headline,"link":link})


        
        if "dinamalar.com" in url:
            # Adjusted selector for The Hindu
            news_items = soup.find_all("div", class_="MuiTypography-root MuiTypography-body1 MuiTimelineContent-root MuiTimelineContent-positionRight css-ej1xlt")
            #print(news_items)
            for item in news_items:
                title=item.find("h6")
                headline = title.get_text(strip=True)
                link_tag = item.find("a")
                if link_tag:
                    link = link_tag.get("href")
                    if link:
                        # Ensure absolute link
                        link = link if link.startswith('https') else f"https://www.dinamalar.com/latestmain{link}"
                        news_data.append({"title":headline,"link":link})



        if "vijaykarnataka.com" in url:
            # Adjusted selector for The Hindu
            news_items = soup.find_all("h3")
            #print(news_items)
            for item in news_items:
                headline = item.get_text(strip=True)
                link_tag = item.find("a")
                if link_tag:
                    link = link_tag.get("href")
                    if link:
                        # Ensure absolute link
                        link = link if link.startswith('https') else f"https://vijaykarnataka.com{link}"
                        news_data.append({"title":headline,"link":link})



        if "sakshi.com" in url:
            # Adjusted selector for The Hindu
            news_items = soup.find_all("a", class_="small-img-text d-flex")
            #print(news_items)
            for item in news_items:
                title= item.find("h5",class_="heading")
                headline = title.get_text(strip=True)
                link_tag = item #item.find("a")
                if link_tag:
                    link = link_tag.get("href")
                    if link:
                        # Ensure absolute link
                        link = link if link.startswith('https') else f"https://www.sakshi.com{link}"
                        news_data.append({"title":headline,"link":link})
            #news_data=news_data[:1]
            #print(news_data)




        if "lokmat.com" in url:
            # Adjusted selector for The Hindu
            news_items = soup.find_all("figcaption")
            #print(news_items)
            for item in news_items:
                headline = item.get_text(strip=True)
                link_tag = item.find("a")
                if link_tag:
                    link = link_tag.get("href")
                    if link:
                        # Ensure absolute link
                        link = link if link.startswith('https') else f"https://www.lokmat.com{link}"
                        news_data.append({"title":headline,"link":link})



        if "divyabhaskar.co.in" in url:
            # Adjusted selector for The Hindu
            news_items = soup.find_all("li", class_="c7ff6507 db9a2680")
            #print(news_items)
            for item in news_items:
                title = item.find("h3")
                headline = title.get_text(strip=True)
                link_tag = item.find("a")
                if link_tag:
                    link = link_tag.get("href")
                    if link:
                        # Ensure absolute link
                        link = link if link.startswith('https') else f"https://www.divyabhaskar.co.in{link}"
                        news_data.append({"title":headline,"link":link})


        if not news_data:
            return {"error": "No headlines found on The Hindu."}
        
        return {"news": news_data}

    except Exception as e:
        return {"error": str(e)}


@app.route('/language_news', methods=['GET'])
def get_news():
    url = request.args.get('url')
    news_data = today_language_news(url)
    return jsonify(news_data)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=6000)
