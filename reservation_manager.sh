#!/bin/bash

check_availability () {
  echo "$(curl -s 'https://reservations.ahlsmsworld.com/Yosemite/Search/GetInventoryCountData?callback=$.wxa.on_datepicker_general_availability_loaded&CresPropCode=000000&MultiPropCode=M&UnitTypeCode=&StartDate=Mon+Jul+08+2019&EndDate=Thu+Jul+11+2019&_=1556398397594' -H 'Accept: text/javascript, application/javascript, application/ecmascript, application/x-ecmascript, */*; q=0.01' -H 'Referer: https://reservations.ahlsmsworld.com/Yosemite/Plan-Your-Trip/Accommodation-Search/Results' -H 'DNT: 1' -H 'X-Requested-With: XMLHttpRequest' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.103 Safari/537.36' --compressed | grep -o "\[.*\]")"
}

old_availability="$(check_availability)"

# set log location
log_location="reservation_manager.log"

# command-line arguments
from_email=$1 # e.g. 'foo@gmail.com'
from_password=$2 # e.g. 'bar'
to_email=$3 # e.g. 'johndoe@gmail.com'
to_text=$4 # e.g. '5555555555@txt.att.net' or '5555555555@vtext.com'

# mail server login
from_login=$from_email":"$from_password # foo@gmail.com:bar

# log availability results for troubleshooting purposes
echo "$(date): $old_availability" > $log_location

while true; do
	
	sleep 300 #5 minutes

	new_availability="$(check_availability)"
	
	echo "$(date): $new_availability" >> $log_location

	# simply check whether new availability != old availability, if so, send messages
	if [ $new_availability != $old_availability ]; then
		old_availability=$new_availability
		echo "$(date): change in availability" >> $log_location
		# send notification
		echo "Change in availability at The Majestic Yosemite" > mail.txt
		echo "$new_availability" | jq '.' >> mail.txt
		echo "" >> mail.txt
		echo "For more information, proceed to https://reservations.ahlsmsworld.com/Yosemite/Search/AccomodationSearchResultsFromThreadResult" >> mail.txt
		# send text
		curl -s --url 'smtps://smtp.gmail.com:465' --ssl-reqd --mail-from $from_email --mail-rcpt $to_text --upload-file text.txt --user $from_login
		# send email
		curl -s --url 'smtps://smtp.gmail.com:465' --ssl-reqd --mail-from $from_email --mail-rcpt $to_email --upload-file mail.txt --user $from_login
	fi

done