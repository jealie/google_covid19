#!/usr/bin/env bash

date="2020-04-11"
date="2020-03-29"
dumpdir="reports_${date}"
cd ${dumpdir}

for pdf in *.pdf; do
  # Limit to first two pages
  ori_file="${pdf}"
  cut_file="${ori_file}_head"
  cmd="pdftk ${ori_file} cat 1-2 output ${cut_file}"
  echo $cmd
  eval $cmd

  # Unpack PDF streams
  unstream_file="${cut_file}_unstream"
  cmd="qpdf --qdf --object-streams=disable ${cut_file} ${unstream_file}"
  echo $cmd
  eval $cmd

  # Get first 6 graph data
  graph_file="${unstream_file}_graphdata"
  cmd="grep 'G11 gs' ${unstream_file} --binary-files=text -A 43 -m 6 > ${graph_file}"
  echo $cmd
  eval $cmd

  # Split into files, one per graph, using the country code
  cc=`echo ${pdf} | cut -d '_' -f 2`
  cmd="awk 'BEGIN{FS=\"G11\"} /G11/{close(file);file=HIT++; next} /^[^-]/{print > \"${cc}_\"file\".csv\"}' ${graph_file}"
  echo $cmd
  eval $cmd
done

