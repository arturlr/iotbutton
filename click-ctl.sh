#!/bin/sh
input="/etc/iot/srcmacs.csv"
while IFS=',' read -r f1 f2 f3
do
  # echo "$f1 $f2 $f3"
  if [ "$f1" == "device" ]; then
     continue
  else
     # $1 is the clickEvent
     echo "click event: $1"
     if [ "$1" == "SINGLE" ]; then
        echo adding rule for "$f2"
        iptables -A forwarding_rule -m comment --comment "blocking $f1" -p tcp -m mac --mac-source "$f2" -j REJECT
     elif [ "$1" == "DOUBLE" ]; then
        rule=$(iptables -L --line-numbers | grep "$f2" | awk '{print $1}')
        echo removing rule for "$f2"
        iptables -D forwarding_rule $rule
     fi
  fi
done < "$input"
