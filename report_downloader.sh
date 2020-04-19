#!/usr/bin/env bash

date="2020-04-11"
dumpdir="reports_${date}"

mkdir -p $dumpdir
cd $dumpdir

for cc in `awk -F "," '{print $NF}' ../country_code.csv`; do
  toget="http://www.gstatic.com/covid19/mobility/${date}_${cc}_Mobility_Report_en.pdf"
  cmd="wget $toget"
  echo $cmd
  $cmd
done
