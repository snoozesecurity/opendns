# nslookup-based OpenDNS Virtual Appliance monitor.  Place this on a VM somewhere and create a cron job to run it 
# on whichever interval you prefer.  The cURL statement can be replaced with email, etc, but I found Slack incoming
# webhook integration works well for this use case.
# More info at https://snoozesecurity.blogspot.com/

#!/bin/bash

DATE=`date +%Y-%m-%d:%H:%M:%S`
SITE1_VA1="192.168.1.100"
SITE1_VA2="192.168.1.200"
SITE2_VA1="172.20.1.100"
SITE2_VA2="172.20.1.200"

VALIST=($SITE1_VA1 $SITE1_VA2 $SITE2_VA1 $SITE2_VA2)

for i in "${VALIST[@]}"
do
        :
        (timeout -k 6 6 nslookup microsoft.com $i || timeout -k 6 6 nslookup google.com $i) | grep -q "authoritative" || curl -X POST \
		-H 'Content-type: application/json' \
		--data "{\
		\"text\":\"$DATE OpenDNS Virtual Appliance address $i nslookup timed out!\"\
		}" \
		<Slack incoming web hook URL>
done