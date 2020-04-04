#!/usr/bin/env bash

dumpdir="reports_2020-03-29"
cd ${dumpdir}

for pdf in *.pdf; do
  # Unpack PDF streams
  ori_file="${pdf}"
  unstream_file="${pdf}_unstream"
  cmd="qpdf --qdf --object-streams=disable ${ori_file} ${unstream_file}"
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

