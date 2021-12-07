Installation guide & User manual

1: install python libraries
pip3 install -r requirements.txt

2. install flask migrate
pip3 install Flask-Migrate

3: Install MySQL
https://dev.mysql.com/downloads/mysql/

4. Create a mysql database named twittersample & load import the twittersample.sql file. 

6. Input your twitter API acces infomation into Config.py

7. Within scraping24.py and sampling/pages/views.py enter the credentials of your database database

8: run scraping module
python3 scraping24.pys

9: run the flask application 
python3 app.py



Disclaimer - Project file structure & source code

Much of this system application is built ontop of pre-existing Flask, html, Javascript and CSS framework provided by Victor 
available publicly on Github at - https://github.com/cspark777/htmlsampling_flask
This is a basic template for a flask web application that utilises a single database. Many of the files have been modified or deleted.

Below is a list of files and folders which contain my unique code or heavily modified code for this project as well as a description
 of what was done and what the file does within the program. All additional files can be regarded as part of the aforementioned web application template format for whcich it is not original source code.

config.py - Here the user enters their Twitter API acces information
scraping24.py - Here the user enters their database access information, This module also pulls tweet information from the Twitter API, processess the data and determines the sentiment of each tweet. The information is then commited to an MySQL Database 
sampling/ - This is  the folder that houses the webpage files for the flask application
sampling/page/view.py - This is the primary file for This pulling the tweet data from the MySQL database and exporting it to the front end dashboard. This also contains a function for retrieving the data as a csv.
sampling/static - these are css, font, images and js for the website. Most of this has not been changed from the template however some colours have been changed within the CSS files
sampling/templates - these are website page html files.
sampling/templates/index - This file extends the Html template already provided by the base.html file and creates the keyword input form, the CSV download button, as well as 3 div sections for the charts. 
sampling/templates/base -creates the html page and the header, title nd logo
Sampling/static/plugins - conatins plugoin for the web app. the flask js scripts were added here
/sampling/static/js/custom.js - contains chart formatting code. This i - Maps code utilised from https://codepen.io/jdnevins/pen/Baovora
twittersample.sql -Twitter database dump and stored procedures. Creates a table that will house the tweet data and stored procedures for the web app to pull the data in a useable format.
