# Visualizing Google's COVID-19 Mobile Data Reports

In early April 2020, Google published a series of pdf reports describing how people's behavior was modified during the worldwide COVID-19 crisis. Their methodology consisted in aggregating mobile user data per geographical areas and looking at changes from baseline. The original reports and a lot of interesting background on this data source are available on: https://www.google.com/covid19/mobility/ 

The code in this repo shows how to extract this data and plot it as cartograms, where the average activity change in each country affects the size of this country on the world map.

## Retail & recreation

![alt text](https://github.com/jealie/google_covid19/raw/master/Google_0%20Stopped%20Going%20Out.gif "COVID-19: How The World Stopped Going Out")

## Grocery & pharmacy

![alt text](https://github.com/jealie/google_covid19/raw/master/Google_1%20Stopped%20Shopping.gif "COVID-19: How The World Stopped Shopping")

## Transit Stations

![alt text](https://github.com/jealie/google_covid19/raw/master/Google_3%20Stopped%20Moving.gif "COVID-19: How The World Stopped Moving")

## Workplaces

![alt text](https://github.com/jealie/google_covid19/raw/master/Google_4%20Stopped%20Working.gif "COVID-19: How The World Stopped Working")

### Reproduce these maps

To extract the data from the pdf reports, you need a linux system and to rin the first two scripts:

- The first script `report_downloader.sh` downloads all the reports from google.

- The second script `pdf_extract.sh` unpacks the data from the pdf and create a series of CSV files per country, containing the data of the first six graphs of each pdf. You may want to check the dump extracted from the many pdfs in the archive `graph_dump.zip` to analyze this data yourself.

To plot the maps, you need a working R install and to run the script viz.R.


### Credits

First thanks goes to Google for releasing these reports.

Doing these maps was easy because of great open-source community, from low-level tools (grep, awk or qpdf) to high-level libraries (R and its many packages) to blogs (visualization code was heavily inspired by https://nowosad.github.io/post/maps-distortion/ ).
