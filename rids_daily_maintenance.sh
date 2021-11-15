#!/bin/bash

rwpswd='password'

# Function with a Read-Write user to get mysql datas and write datas in the database
sql_request_RW(){
	mysql -u alarm_read_write crids -sN -e "${1};" -p"${rwpswd}";
}


retention_duration_cctv=$(sql_request_RW "select retention_duration_cctv from SETTINGS")
retention_duration_event_logs=$(sql_request_RW "select retention_duration_event_logs from SETTINGS")
retention_duration_debug_logs=$(sql_request_RW "select retention_duration_debug_logs from SETTINGS")
retention_duration_arduino_captures=$(sql_request_RW "select retention_duration_arduino_captures from SETTINGS")

# cctv
full_rentention_date_cctv=$(date +%Y-%m-%d  --date="$((1+${retention_duration_cctv})) days ago")
while read -a row
	do	rm cctv_captures/"${row[1]}"
done <<< $(sql_request_RW "SELECT ID FROM CCTV_CAPTURES WHERE FILENAME <= '${full_rentention_date_cctv}' ")
sql_request_RW "DELETE FROM CCTV_CAPTURES WHERE FILENAME <= '${full_rentention_date_cctv}' "

# event_logs
full_rentention_date_logs=$(date +%Y-%m-%d  --date="$((1+${retention_duration_logs})) days ago")
sql_request_RW "DELETE FROM EVENT_LOG WHERE LOG_TIMESTAMP <= '${full_rentention_date_logs}' "


# debug_logs
full_rentention_date_debug_logs=$(date +%Y-%m-%d  --date="$((1+${retention_duration_logs})) days ago")
find "logs/debug_$(date +%Y_%m_%d).txt" -mtime +"$((1+${retention_duration_debug_logs}))" -exec rm {} \;

# arduino_captures
> arduino_capture.txt
