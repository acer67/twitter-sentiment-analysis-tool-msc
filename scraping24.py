import tweepy, json
from tweepy.api import API
from textblob import TextBlob
import preprocessor
import re

import config # Import api/access_token keys from credentials.py


from geopy.geocoders import Nominatim
from functools import partial

import mysql.connector
from datetime import timezone 
import datetime
import time

# Twitter API needs to be validated
auth  = tweepy.OAuthHandler(config.API_KEY, config.API_SECRET_KEY)
auth.set_access_token(config.ACCESS_TOKEN, config.ACCESS_TOKEN_SECRET)
api = tweepy.API(auth)

#connects to mySQL database 
mydb = mysql.connector.connect(
    host='XXXXXXX',
    user='XXXXXXX',
    passwd="XXXXXX",
    database='XXXXXXX',
    charset = 'XXXXXX'
)

#Function that logs messages to text file
def log_message(message):
    print(message)
    
    hs = open("log.txt","a", encoding="utf8")
    hs.write(message + "\n")
    hs.close() 
    

gb_insert_arr = []

#INSERT TWEET INFO INTO LIST OF PROCESSED TWEETS
def insert_tweet(db, tweet_info):
    global gb_insert_arr    
    gb_insert_arr.append(tweet_info)

#function that saves tweets to the MySQL database db
def save_tweets_to_database(db):
    global gb_insert_arr

    cc = len(gb_insert_arr)
    if cc == 0:
        return

    query = "INSERT INTO tweets(keyword, tweet_id, username, polarity, subjectivity, location, country_code, created_at,  cleaned_text, hash_tag_str, favorite_count, retweet_count, lang, user_mentions_str) VALUES "

    for r in gb_insert_arr:

        location = r["location"].replace("\\", "\\\\'") 
        location = location.replace("'", "\\'") 


        cleaned_text = r["cleaned_text"].replace("\\", "\\\\'") 
        cleaned_text = cleaned_text.replace("'", "\\'") 

        hash_tag_str = r["hash_tag_str"].replace("\\", "\\\\'") 
        hash_tag_str = hash_tag_str.replace("'", "\\'") 

        user_mentions_str = r["user_mentions_str"].replace("\\", "\\\\'") 
        user_mentions_str = user_mentions_str.replace("'", "\\'") 

        query = query + "('{}', '{}', '{}', {}, {}, '{}', '{}', '{}', '{}', '{}', {}, {}, '{}', '{}'),".format(r["keyword"], r["tweet_id"], r["username"], r["polarity"], r["subjectivity"], location, r["country_code"], r["created_at"], 
        cleaned_text, hash_tag_str, r["favorite_count"], r["retweet_count"], r["lang"], user_mentions_str)

    query = query[0:-1]   

    if db.is_connected():        
        try:
            mycursor = db.cursor()                        
            mycursor.execute(query)
            db.commit() # saves data to database
            mycursor.close() # closes connection

            gb_insert_arr.clear() #clears tweet info after each page so they are not pushed to the database twice

            log_message("--- save data cc=> " + str(cc) )
            
        except Exception as error:
            log_message("--- MySQL insert_tweet error=>{}, sql=>{} ".format(str(error), query))
            exit()



address_final_words = {}

dt = datetime.datetime.utcnow() - datetime.timedelta(minutes=3) # time now
start_time = str(dt.date()) + " " + str(dt.time()).split(".")[0] 

# creates loop of retrieving page of 100 tweets
while(True):    
    today = start_time.split(" ")[0]
    f = open("tweet_key.txt", "r")
    search_words = f.read()

   
    log_message("=== start => start_time:{}, today:{}, search_word:{}".format(start_time, today, search_words))

    tweet_pages = tweepy.Cursor(api.search, q=search_words + " -filter:retweets", since=today, tweet_mode='extended', lang='en', count=100).pages() #page = list of statuses, count = number of pages
    
    cc = 0
    cc_location = 0
    cc_coordinate = 0
    cc_place = 0

    first_time = ""

    is_process = True
    try:
        for page in tweet_pages:            
            log_message("--- New Page") # logs when there is a new page
            save_tweets_to_database(mydb)

            for tweet in page:
                
                created_at = str(tweet.created_at)

                if first_time == "":
                    first_time = created_at

                if created_at < start_time:                
                    log_message("--- meet start time => start_time:{}, first_time:{}".format(start_time, first_time))
                    start_time = first_time
                    time.sleep(20) 
                    is_process = False
                    break



                # for each tweet obtains tweet data
                cc = cc + 1
                id_str = tweet.id_str
                username = tweet.user.screen_name
                full_text = tweet.full_text #unprocessed tweet text
                cleaned_text = preprocessor.clean(full_text) #cleaned tweet text
                sentiment = TextBlob(cleaned_text).sentiment #obtains sentiment
                polarity = sentiment.polarity #obtains polarity score
                subjectivity = sentiment.subjectivity
                if polarity < 0:
                    polarity = -1
                elif polarity > 0:
                    polarity = 1
                else:
                    polarity = 0

                favorite_count = tweet.favorite_count
                retweet_count = tweet.retweet_count
                hash_tags = tweet.entities["hashtags"]
                hash_tag_str = ""
                for tag in hash_tags:
                    hash_tag_str = hash_tag_str + tag["text"] + ","

                hash_tag_str = hash_tag_str[0:-1]    
                user_mentions = tweet.entities["user_mentions"]
                user_mentions_str = ""
                for mention in user_mentions:
                    user_mentions_str = user_mentions_str + mention["screen_name"] + ","
                user_mentions_str = user_mentions_str[0:-1]
                
                lang = tweet.lang
                location = tweet.user.location
                coordinates = tweet.coordinates
                place = tweet.place


                lo = ""
                if location: 
                    cc_location = cc_location + 1
                    lo = location
                    try:
                        lo_words = lo.split(" ")
                        lo_words_len = len(lo_words)
                        final_word = lo_words[lo_words_len-1]
                        final_word = final_word.replace("'", "\\'")

                        if final_word in address_final_words.keys():
                            country_code = address_final_words[final_word]
                        else:

                            geolocator = Nominatim(user_agent="aaa")
                            geocode = geolocator.geocode(lo, addressdetails=True)
                            address = geocode.raw['address']
                            if address == None:
                                print("failed: ", lo)
                                continue
                            else:
                                country_code = address.get('country_code', '')
                                #
                                address_final_words[final_word] = country_code 

                    except:
                        continue
                elif coordinates:
                    cc_coordinate = cc_coordinate + 1
                    lo = coordinates
                    continue
                elif place:
                    cc_place = cc_place + 1
                    lo = place.full_name
                    country_code = place.country_code
                else:
                    continue

               

                #makes tweet info
                tweet_info = {}
                tweet_info["tweet_id"] = id_str
                tweet_info["keyword"] = search_words
                tweet_info["username"] = username
                tweet_info["polarity"] = polarity
                tweet_info["subjectivity"] = subjectivity
                tweet_info["location"] = lo
                tweet_info["country_code"] = country_code
                tweet_info["created_at"] = created_at
                tweet_info["cleaned_text"] = cleaned_text
                tweet_info["hash_tag_str"] = hash_tag_str
                tweet_info["favorite_count"] = favorite_count
                tweet_info["retweet_count"] = retweet_count
                tweet_info["lang"] = lang
                tweet_info["user_mentions_str"] = user_mentions_str


                insert_tweet(mydb, tweet_info)
                log_message(cleaned_text) #logs cleaned text to text log

                f = open("tweet_key.txt", "r")
                search_words1 = f.read()       
                if search_words != search_words1:
                    dt = datetime.datetime.utcnow() - datetime.timedelta(minutes=5)
                    start_time = str(dt.date()) + " " + str(dt.time()).split(".")[0]
                    log_message("--- Keyword changed, new key:{}".format(search_words1)) 
                    is_process = False
                    break            

            if is_process == False:
                break

              
    except tweepy.TweepError as e:  #STOP ITERATION IF TWEEPY ERROR
        log_message("--- tweepy error : " + e.reason)        
        time.sleep(900)
        dt = datetime.datetime.utcnow() - datetime.timedelta(minutes=5)
        start_time = str(dt.date()) + " " + str(dt.time()).split(".")[0]
        
    except StopIteration: #stop iteration when last tweet is reached
        log_message("--- end iterator =>start_time:{}, first_time:{}".format(start_time, first_time))
        start_time = first_time
        time.sleep(150)
        
         

