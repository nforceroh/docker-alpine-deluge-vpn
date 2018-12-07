#!/bin/bash


echo "cleaning up work files"
rm -f *.ovpn.tmp locations.html

echo "Fetching configs"
curl -k https://www.slickvpn.com/locations/ -o locations.html

configdata=$(html2text -b 0 locations.html |grep ovpn|sort|awk -F '|' '{print $2"^"$3"^"$4}')
IFS=$'\n'
for line in ${configdata}; do
  country=$(echo ${line}|cut -f1 -d^|sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'| sed -e 's/[[:space:]]/-/g'| iconv -f utf-8 -t us-ascii//TRANSLIT)
  city=$(echo ${line}|cut -f2 -d^|sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'| sed -e 's/[[:space:]]/-/g'| iconv -f utf-8 -t us-ascii//TRANSLIT)
  cfg=$(echo ${line}|cut -f3 -d^|sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'|egrep -o 'https?://[^ ]+ovpn')
  echo "--${country}-${city}-${cfg}--"
  echo "fetching  ${cfg}"
  ovpn="${country}-${city}.ovpn.tmp"
  curl -ks ${cfg}|grep "^remote\s" >> ${ovpn}
  echo "Added to ${ovpn}"
done

for cfg in `ls *.ovpn.tmp`; do
 echo "Post-Processing ${cfg}"
 newcfg=$(echo ${cfg}|sed 's/\.tmp//g')
 cat template >> ${cfg}
 echo "Copying ${cfg} to ${newcfg}"
 cat ${cfg} > ${newcfg}
 rm -f ${cfg}
done

echo "cleaning up work files"
rm -f *.ovpn.tmp locations.html

