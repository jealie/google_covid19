# Visualizing Google's COVID-19 Mobile Data Reports

In early April, Google published a series of pdf report describing how people's behavior, as recorded in their mobile user data, was modified during the worldwide COVID-19 crisis. The original reports and a lot of interesting information on this data source are available on: https://www.google.com/covid19/mobility/ 

The code in this repo shows how to extract the info from the first six graph of each country report and plot them as cartograms.

## Retail & recreation

![alt text](https://github.com/jealie/google_covid19/raw/master/Google_0 Stopped%20Going%20Out.gif "COVID-19: How The World Stopped Going Out")

## Grocery & pharmacy

![alt text](https://github.com/jealie/google_covid19/raw/master/Google_1%20Stopped%20Shopping.gif "COVID-19: How The World Stopped Shopping")

## Transit Stations

![alt text](https://github.com/jealie/google_covid19/raw/master/Google_3%20Stopped%20Moving.gif "COVID-19: How The World Stopped Moving")

## Workplaces

![alt text](https://github.com/jealie/google_covid19/raw/master/Google_4%20Stopped%20Working.gif "COVID-19: How The World Stopped Working")

### Reproduce these maps

To use the code available here and redo these maps, you need a linux system and R installed:

- The first script `report_downloader.sh` downloads all the reports from google.

- The second script `pdf_extract.sh` unpacks the data from the pdf and create a series of CSV files per country, containing the data of the first six graphs of each pdf. You may want to check the dump extracted from the many pdfs in the archive `graph_dump.zip` to analyze this data yourself.

- The R script viz.R makes the maps.


### Credits

First thanks goes to Google for releasing these reports.

Doing these maps was easy because of great open-source community, from low-level tools (grep, awk or qpdf) to high-level libraries (R and its many packages) to blogs (in particular, visualization code was heavily inspired by https://nowosad.github.io/post/maps-distortion/ ).
