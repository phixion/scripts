#!/usr/bin/python
 
import re
import urllib2
import random
import tweepy

def findComment():
	opener = urllib2.build_opener()
	opener.addheaders.append(('Cookie', 'age_verified=1'))
	f = opener.open("http://www.youporn.com/random/video/")
	htmlSource = f.read()
	f.close()
	comments = re.findall('<div class="commentContent">((?:.|\\n)*?)</p>', htmlSource)
	if len(comments) <=140:
		randomcomment = random.choice(comments).replace("<p>", "")
		return randomcomment

def postTweet(randomcomment):
	consumer_key, consumer_secret, access_token, access_token_secret = "YOURKEY", "YOURSECRET", "YOURTOKEN", "YOURTOKENSECRET"
	auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
	auth.set_access_token(access_token, access_token_secret)
	api = tweepy.API(auth)
	api.update_status(status=randomcomment)
	return False

if __name__ == "__main__":
	postTweet(findComment())
