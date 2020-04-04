#!/usr/bin/env bash

dumpdir="reports_2020-03-29"

mkdir -p $dumpdir
cd $dumpdir

for cc in `awk -F "," '{print $NF}' ../country_code.csv`; do
  toget="http://www.gstatic.com/covid19/mobility/2020-03-29_${cc}_Mobility_Report_en.pdf"
  cmd="wget $toget"
  echo $cmd
  $cmd
done
