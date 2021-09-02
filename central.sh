#!/bin/bash

# Made by : Tuxpilot.eu

# Licence GNU v3






# List of all the functions 

pgrep mysql || sudo systemctl restart mysql

led_status(){
	if [[ "${gpio_status_led_enabled}" -eq 1 && "${led_type}" == 'SINGLE_led_status' ]]
		then	case "${1}" in
					set_up_gpio)
						gpio -g mode "${gpio_status_led_pwr}" OUT
						gpio -g write "${gpio_status_led_pwr}" 0
						;;
						
					*)
						pkill -f SINGLE_led_status
						gpio -g write "${gpio_status_led_pwr}" 1
						if [[ "${2}" -ne 999 ]]
							then	sleep "${2}"
						fi
						gpio -g write "${gpio_status_led_green}" 0
						;;
				esac
	fi
	
	if [[ "${gpio_status_led_enabled}" -eq 1 && "${led_type}" == 'RGB_led_status' ]]
		then	case "${1}" in
					set_up_gpio)
						gpio -g mode "${gpio_status_led_pwr}" OUT
						gpio -g mode "${gpio_status_led_red}" OUT
						gpio -g mode "${gpio_status_led_blue}" OUT
						gpio -g mode "${gpio_status_led_green}" OUT
						gpio -g write "${gpio_status_led_pwr}" 0
						gpio -g write "${gpio_status_led_red}" 0
						gpio -g write "${gpio_status_led_blue}" 0
						gpio -g write "${gpio_status_led_green}" 0
						;;
						
					green)
						pkill -f RGB_led_status
						gpio -g write "${gpio_status_led_green}" 1
						if [[ "${2}" -ne 999 ]]
							then	sleep "${2}"
						fi
						gpio -g write "${gpio_status_led_green}" 0
						;;
						
					blue)
						pkill -f RGB_led_status
						gpio -g write "${gpio_status_led_blue}" 1
						if [[ "${2}" -ne 999 ]]
							then	sleep "${2}"
						fi
						gpio -g write "${gpio_status_led_blue}" 0
						;;
						
					red)
						pkill -f RGB_led_status
						gpio -g write "${gpio_status_led_red}" 1
						if [[ "${2}" -ne 999 ]]
							then	sleep "${2}"
						fi
						gpio -g write "${gpio_status_led_red}" 0
						;;
						
					purple)
						pkill -f RGB_led_status
						gpio -g write "${gpio_status_led_red}" 1
						gpio -g write "${gpio_status_led_blue}" 1
						if [[ "${2}" -ne 999 ]]
							then	sleep "${2}"
						fi
						gpio -g write "${gpio_status_led_red}" 0
						gpio -g write "${gpio_status_led_blue}" 0
						;;
						
					yellow)
						pkill -f RGB_led_status
						gpio -g write "${gpio_status_led_red}" 1
						gpio -g write "${gpio_status_led_green}" 1
						if [[ "${2}" -ne 999 ]]
							then	sleep "${2}"
						fi
						gpio -g write "${gpio_status_led_red}" 0
						gpio -g write "${gpio_status_led_green}" 0
						;;
						
					cyan)
						pkill -f RGB_led_status
						gpio -g write "${gpio_status_led_green}" 1
						gpio -g write "${gpio_status_led_blue}" 1
						if [[ "${2}" -ne 999 ]]
							then	sleep "${2}"
						fi
						gpio -g write "${gpio_status_led_green}" 0
						gpio -g write "${gpio_status_led_blue}" 0
						;;
						
					white)
						pkill -f RGB_led_status
						gpio -g write "${gpio_status_led_red}" 1
						gpio -g write "${gpio_status_led_blue}" 1
						gpio -g write "${gpio_status_led_green}" 1
						if [[ "${2}" -ne 999 ]]
							then	sleep "${2}"
						fi
						gpio -g write "${gpio_status_led_red}" 0
						gpio -g write "${gpio_status_led_blue}" 0
						gpio -g write "${gpio_status_led_green}" 0
						;;
						
					off)
						pkill -f RGB_led_status
						gpio -g write "${gpio_status_led_red}" 0
						gpio -g write "${gpio_status_led_blue}" 0
						gpio -g write "${gpio_status_led_green}" 0
						;;
						
				esac
	fi
	
	
}
gpio_array["${current_access_points_to_monitor}"]

# Function made to check the state of every access point which is declared in the system.
# ID 	monitoring_gpio_number 	monitoring_gpio_value_access_closed 	monitoring_gpio_name 	monitoring_gpio_current_state 	tempo_trigger_alarm 	gpio_open_flag 	mandatory_closed_access_on_arming
check_gpio_point_monitoring(){
	current_access_points_to_monitor=0
	while [[ "${current_access_points_to_monitor}" -lt "${total_access_points_to_monitor}" ]]
		do	monitoring_gpio_number=$(echo $gpio_array["${current_access_points_to_monitor}"] | awk -F ' ' '{ print $2 }')
			monitoring_gpio_value_access_closed=$(echo $gpio_array["${current_access_points_to_monitor}"] | awk -F ' ' '{ print $3 }')
			monitoring_gpio_name=$(echo $gpio_array["${current_access_points_to_monitor}"] | awk -F ' ' '{ print $4 }')
			monitoring_gpio_current_state=$(gpio -g read "${monitoring_gpio_number}")
			tempo_trigger_alarm=$(echo $gpio_array["${current_access_points_to_monitor}"] | awk -F ' ' '{ print $6 }')
			# gpio_open_flag=$(echo $gpio_array["${current_access_points_to_monitor}"] | awk -F ' ' '{ print $7 }')
			gpio_open_flag="${gpio_flag[$monitoring_gpio_number]}"
			debug "The FLAG for the gpio ${monitoring_gpio_number} is ${gpio_open_flag}, it is read from the array with the following datas : ${gpio_flag[$monitoring_gpio_number]}"
			mandatory_closed_access_on_arming=$(echo gpio_array["${current_access_points_to_monitor}"] | awk -F ' ' '{ print $8 }')
			debug  "The GPIO ${monitoring_gpio_number} has a value of : ${monitoring_gpio_current_state} // when the access is closed, it must return a value of : ${monitoring_gpio_value_access_closed}, and it has a tempo trigger time of : ${tempo_trigger_alarm}" 
			
			if [[ "${monitoring_gpio_current_state}" -eq "${monitoring_gpio_value_access_closed}" && "${gpio_open_flag}" -eq 1 ]]
				then	event_log "door_closed.png" "The access ${monitoring_gpio_name} is detected as closed"
						# sql_request_RW "UPDATE GPIO SET monitoring_gpio_current_state = '${monitoring_gpio_current_state}', gpio_open_flag = '0'" & disown >> /dev/null 2>&1
						gpio_flag[$monitoring_gpio_number]="0"
			fi
			
			# If the currently checked access point is opened, and is a temporized access, and the alarm is not idle or being armed, then someone is entering a monitored area and has to authenticate quickly. Menwhile the alarm is waiting for authentication
			if [[ "${monitoring_gpio_current_state}" -ne "${monitoring_gpio_value_access_closed}" && "${tempo_trigger_alarm}" -ne 0 && ! "${alarm_status}" =~ ('0'|'1') && "${gpio_open_flag}" -ne 1 ]]
				then	alarm_status=3
						debug "The access point linked to the GPIO : ${monitoring_gpio_number}, named : ${monitoring_gpio_name}, is detected as open. We proceed to the alarm status 3"
						event_log "alarm_state_3.png" "The access ${monitoring_gpio_name} triggered the temporisation of the alarm!!!"
						# capture_image_cctv
			fi
			
			# If the currently checked access point is opened, and is NOT a temporized access, and the alarm is not idle or being armed, then an intrusion is confirmed 
			if [[ "${monitoring_gpio_current_state}" -ne "${monitoring_gpio_value_access_closed}" && "${tempo_trigger_alarm}" -eq 0 && ! "${alarm_status}" =~ ('0'|'1') && "${gpio_open_flag}" -ne 1 ]]
				then	alarm_status=4
						event_log "alarm_state_4.png" "The access ${monitoring_gpio_name} triggered the alarm!!!"
						debug "The access point linked to the GPIO : ${monitoring_gpio_number}, named : ${monitoring_gpio_name}, is detected as open. We proceed to the alarm status 4" 
			fi
			
			if [[ "${monitoring_gpio_current_state}" -ne "${monitoring_gpio_value_access_closed}" && "${gpio_open_flag}" -eq 0 ]]
				then	event_log "door_open.png" "The access ${monitoring_gpio_name} is detected as open"
						# sql_request_RW "UPDATE GPIO SET monitoring_gpio_current_state = '${monitoring_gpio_current_state}', gpio_open_flag = '1'" & disown >> /dev/null 2>&1
						gpio_flag[$monitoring_gpio_number]="0"
						case "${alarm_status}" in
							0|1)	capture_video_cctv notification_door_opened
									gpio_flag[$monitoring_gpio_number]="1"
									;;
							
							2|3|4)	capture_video_cctv alert_intrusion
									gpio_flag[$monitoring_gpio_number]="1"
									;;	
						esac
						break
			fi
			
			if [[ "${monitoring_gpio_current_state}" -ne "${monitoring_gpio_value_access_closed}" && "${1}" == "pre_arming_check" ]]
				then	if [[ "${mandatory_closed_access_on_arming}" -eq 1 ]]
							then	debug "Mandatory closed access point for arming is found opened! GPIO number ${monitoring_gpio_number} returns the access is still open, it should have a value of: ${monitoring_gpio_value_access_closed}, but instead we find a value of ${monitoring_gpio_current_state} " 
									sound_player "${audio_signal_type}" alterna_3 notification
									sound_player "${audio_signal_type}" message_alarm_auto_cancel_arming
									alarm_status=0
									pre_arming_check_result="NOK"
									event_log "door_still_opened.png" "Warning! The alarm is arming but the access ${monitoring_gpio_name} is still detected as opened"
							else	debug "GPIO number ${monitoring_gpio_number} returns the access is still open, it should have a value of: ${monitoring_gpio_value_access_closed}, but instead we find a value of ${monitoring_gpio_current_state} " 
									event_log "door_still_opened.png" "Warning! The alarm is arming but the access ${monitoring_gpio_name} is still detected as opened"
									sound_player "${audio_signal_type}" alterna_3 notification
									sound_player "${audio_signal_type}" message_alarm_arming_still_open
						fi
			fi			
			
			debug "monitoring_gpio_current_state ${monitoring_gpio_current_state}"
			debug "monitoring_gpio_name ${monitoring_gpio_name}"
			let "current_access_points_to_monitor=current_access_points_to_monitor+1"
	done
}


# Function made to send SMS based on a list of recipients in the database, and the SMS API from OVH (paid functionnality, transiting through the web).
send_sms(){
	# We retrieve the datas for every recipient for who the setting 'SEND_SMS' is set to 1, and we send a SMS which content is based on the event which triggered the function.
	if [[ "${sms_sent}" -ne 1 ]]
		then	while read -a row
					do	FIRST_NAME="${row[1]}"
						LAST_NAME="${row[2]}"
						SEND_SMS="${row[3]}"
						SEND_EMAIL="${row[4]}"
						SMS_NUMBER="${row[5]}"
						EMAIL_ADDRESS="${row[6]}"
						recipient_name="${FIRST_NAME}_${LAST_NAME}"
						# Based on the argument {1} retrieved from the function, we fetch the body of the sms and we send it to the recipient
						sms_message_body=$(grep "${1}" "language/${language}/sms_messages.txt" | awk -F '=' '{ print $2 }' )
						if [[ "${sms_sent}" -ne 1 && "${SEND_SMS}" -eq 1 ]]
							then	php bin/OVH_API/php-ovh-dep/sms-sender.php "${SMS_NUMBER}" "${sms_message_body}" & disown >> /dev/null 2>&1						
						fi
						# We add to the database the information regarding the fact that we just sent a SMS
						sql_request_RW "UPDATE ALERT_TRACKING SET LAST_SMS_TIMESTAMP = `date +%s`"
						echo "date +%Y_%m_%d__@__%H:%M_sent-to_${recipient_name}_AND_MESSAGE_${sms_message_body}"
				done <<< $(sql_request_RO "select * from ALERTS_RECIPIENTS")
	fi
}


# This is the function where we use the RFID MFRC-522 to read RFID cards and let users authenticate
rfid_reader(){ 
	rfid_reader_result=0 # We make sure to reset the potential previous results of RFID readings
	valid_rfid_detected='u'
	if [[ $SECONDS -lt $RFID_reader_resting ]]
		then	echo "" > rfid_reader_capture.txt
				debug "We are still in the resting time of the RFID, we reset the file content so no further RFIS scan is possible until the rest time is reached."
	fi
	debug "The function RFID is initiated from the status: ${1}" 
	rfid_reader_capture=$(cat rfid_reader_capture.txt)
	debug "RFID function: the reader file contains : ${rfid_reader_capture}" 
	last_alarm_known_status="${alarm_status}"
	debug "function rfid : last_alarm_known_status = ${last_alarm_known_status}"
	if 	[[ ! -z "${rfid_reader_capture}" ]]
		then	valid_rfid_request=$(sql_request_RO "select * from RFID WHERE rfid_card_ID = ${rfid_reader_capture} AND rfid_card_flag <>'disabled'")
				if 	[[ -z "${valid_rfid_request}" ]] 
					then	if	[[ "${alarm_status}" -eq 5 ]]
								then	debug "A new RFID card has been in contact with the RFID reader" 
										sql_request_RW "INSERT INTO RFID (ID, rfid_card_ID, attribution_first_name, attribution_last_name, rfid_card_flag ) VALUES ( NULL, '${rfid_reader_capture}', 'TO_CUSTOMIZE', 'TO_CUSTOMIZE', 'active')"
										sound_player "${audio_signal_type}" message_alarm_rfid_added
										event_log "added_rfid_card.png" "New RFID added with success."
								
								else	debug "Unknown RFID!: ${rfid_reader_capture}" 
										event_log "wrong_rfid_card.png" "Unknown RFID detected !"
										sound_player "${audio_signal_type}" alterna_2 notification
										sound_player "${audio_signal_type}" message_alarm_unkown_rfid_card
										rfid_reader_result=2
										echo "" > rfid_reader_capture.txt
							fi
							
					else	rfid_reader_result=1
							sound_player "${audio_signal_type}" alterna_1 notification
							debug "function rfid not void : last_alarm_known_status = ${last_alarm_known_status} AND We found a known RFID : @${valid_rfid_request}@ "
							valid_rfid_detected=1
							password_attempt=0 # we reset the number of detected password attemps (password or RFID) since a valid one has been detected
							while read -a row
								do	rfid_card_ID="${row[1]}"
									attribution_first_name="${row[2]}"
									attribution_last_name="${row[3]}"
									rfid_attribution="${attribution_first_name} ${attribution_last_name}"
									rfid_card_flag="${row[4]}"
									echo "${rfid_attribution}"
							done <<< "${valid_rfid_request}"
							if 	[[ "${rfid_attribution}" == *"TO_CUSTOMIZE"* ]]
								then	debug "That RFID card is in the database but has no name attributed. We can't let an access to a card which has no attribution name for security reasons."
										sound_player "${audio_signal_type}" alterna_2 notification
										sound_player "${audio_signal_type}" message_alarm_rfid_has_no_name	
										valid_rfid_detected=0
										event_log "wrong_rfid_card.png" "The RFID card number ${rfid_card_ID} was detected and is part of the database, but has no user attributed to it. We can't let an access to a card which has no attribution name for security reasons"
							fi
							if 	[[ "${rfid_card_flag}" =~ ("lost"|"stolen") ]]
								then	debug "That RFID card ${rfid_card_ID} is detected, is in the database but the ID is referenced as stolen or lost!."
										valid_rfid_detected=0
										if 	[[ "${trigger_alarm_on_lost_or_stolen_card}" -eq 1 ]]
											then	sound_player "${audio_signal_type}" alterna_2 intrusion
													sound_player "${audio_signal_type}" message_alarm_rfid_revoked	
													alarm_status=4
													event_log "wrong_rfid_card.png" "The RFID card number ${rfid_card_ID} was detected and is referenced as lost or stolen! Alarm is triggered!"
											else	sound_player "${audio_signal_type}" alterna_2 notification
													sound_player "${audio_signal_type}" message_alarm_rfid_revoked	
													event_log "wrong_rfid_card.png" "The RFID card number ${rfid_card_ID} was detected and is referenced as lost or stolen!"
										fi
										
							fi
							if [[ "${alarm_status}" -eq 5 ]]
								then	debug "We noticed that the RFID card @${valid_rfid_request}@ attributed to ${rfid_card_ID} already exists" 
										sound_player "${audio_signal_type}" message_alarm_rfid_already_exists	
							fi
							if [[ "${alarm_status}" -eq 4 && "${valid_rfid_detected}" == 1 ]]
								then	debug "We kill the piezo alarm" 
										pkill -f piezo
										debug "Sending the reset of the piezo gpio"
										gpio -g write "${gpio_piezo_number}" 0
										sound_player "${audio_signal_type}" message_alarm_password_success
										alarm_status=0
										event_log "good_rfid_card.png" "Alarm disabled with the RFID card attributed to ${rfid_attribution}"
							fi
							if [[ "${alarm_status}" =~ ^('2'|'3')$ && "${valid_rfid_detected}" == 1 ]]
								then	sound_player "${audio_signal_type}" message_alarm_password_success
										alarm_status=0
										event_log "alarm_unlocked.png" "The RFID attributed to ${rfid_attribution} successfully unlocked the alarm"
							fi
							if [[ "${alarm_status}" -eq 1 && "${valid_rfid_detected}" == 1 ]]
								then	alarm_status=0
										event_log "alarm_unlocked.png" "The RFID attributed to ${rfid_attribution} successfully unlocked the alarm"
							fi
							if [[ "${alarm_status}" -eq 0 && "${valid_rfid_detected}" == 1 && "${arming_cancellation}" -ne 1 && "${triggered_alarm}" -ne 1 && "${last_alarm_known_status}" -ne 2 && "${last_alarm_known_status}" -ne 3 && "${last_alarm_known_status}" -ne 4 ]]
								then	alarm_status=1
										password_attempt=0
										echo "" > rfid_reader_capture.txt
										event_log "alarm_armed.png" "The RFID attributed to ${rfid_attribution} successfully armed the alarm"
							fi
							if [[ "${triggered_alarm}" -eq 1 && "${valid_rfid_detected}" == 1 ]]
								then	triggered_alarm=0
										alarm_status=0
										event_log "alarm_siren_off.png" "The RFID attributed to ${rfid_attribution} successfully shut down the sonore alarm"
							fi
							echo "" > rfid_reader_capture.txt
							sudo systemctl restart rfid_reader.service
							RFID_reader_resting=$((SECONDS+10))
							debug "We apply a no RFID scan timezone.  The system time is $SECONDS, and the next system tme where the scan will be available is : ${RFID_reader_resting}"
				fi
		else	debug "No RFID card seems to have been in contact with the reader" 
	fi
}


# Function made to play pre-recorded TTS voices, made to announce what the alarm is doing, and have a better user experience.
# 	This function is available only if in the settings, the value "silent_voice" is set to 0, which means we don't make it silent.
#	Based on the setting value 'language' the voices are played in the selected language. If no language suits you, you are able to create it.
#	The available choices for the "${audio_signal_type}" are : piezo_only | voice_only | piezo_voice
sound_player(){
	if [[ "${silent_voice}" -eq 0 && "${2}" != *"alterna"* && "${audio_signal_type}" == *"voice"* ]]
		then	if [[ ! "${alarm_status}" =~ ^('3'|'4')$ ]]
					then	omxplayer --no-keys -o local "language/${language}/${2}.wav" Audio codec pcm_s16le channels 1 samplerate 16000 bitspersample 16 > /dev/null 2>&1
							debug "We play ${2}.wav"
					else	omxplayer --no-keys -o local "language/${language}/${2}.wav" Audio codec pcm_s16le channels 1 samplerate 16000 bitspersample 16 > /dev/null 2>&1 &
							debug "We play ${2}.wav"
				fi
	fi
	if [[ "${2}" == *"alterna"* && "${audio_signal_type}" != "voice_only" ]]
		then	if [[ "${3}" == "notification" && "${silent_buzzer}" -eq 0 && "${gpio_piezo_number}" -ne 99 ]]
					then	./piezo_alarm_sound.sh "${2}" "${gpio_piezo_number}" & disown
				fi
				if [[ "${3}" == "alert" && "${silent_alarm}" -eq 0 && "${gpio_piezo_number}" -ne 99 ]]  
					then	./piezo_alarm_sound.sh "${2}" "${gpio_piezo_number}" & disown
				fi
	fi
}







# Function made to initiate necessary items and GPIOs related to the way of the users have to authenticate (RFID, external system link with a dry_contact, etc.)
initiate_user_input(){
	if [[ "${user_input_method}" == "dry_contact" ]]
		then	gpio_user_input_method=$(sql_request_RO "select gpio_user_input_method from SETTINGS")
				gpio_user_input_method_circuit_mode=$(sql_request_RO "select gpio_user_input_method_circuit_mode from SETTINGS")
				declare -n ref="opened_access_gpio_${gpio_user_input_method}"
				ref=0
				gpio -g mode "${gpio_user_input_method}" OUT
				if [[ "${gpio_user_input_method_circuit_mode}" == "1" ]]
					then	gpio -g write "${gpio_user_input_method}" 1
					else	gpio -g write "${gpio_user_input_method}" 0
				fi
	fi
}

# Function made to capture still images from an IP camera
capture_image_cctv(){
    outfilename=`date +"img-%Y-%m-%d_%H-%M-%S.jpg"`
	ffmpeg -loglevel fatal -rtsp_transport tcp -i "${video_capture_url}" -r 1 -vframes 1 "${image_capture_folder}${outfilename}"
    #function sendmail avec piece jointe image
}


# Function set to capture the stream from a Ip Camera, streaming with RTSP functionnality // This function is available only if in the settings, the value "video_capture_enabled" is set to 1
# By definition, if their is an IP Camera available and linked to the system, everytime an 'alert' event is detected, a video capture is made. Only if their is a notification kind of event and the 'video_capture_on_alert_only' value is set to 1 in the settings, then no video is made.
capture_video_cctv(){
	if [[ "${video_capture_enabled}" -eq 1 ]]
		then	# Setting up the name of the video clip
				cctv_actual_filename=$(date +%Y-%m-%d_%H-%M-%S.mp4)
				
				# If the argument is NOT 'alert' AND if the setting 'video_capture_on_alert_only' is set to 0 (disabled), then we capture the stream and put it in a video file, and we upload the datas to the database to be able to retrieve it in the WebUI
				if [[ "${1}" -ne "alert" && "${video_capture_on_alert_only}" -eq 0 ]]
					then	nohup ffmpeg -t "${video_capture_timing}" -i rtsp://"${video_capture_username}":"${video_capture_password}"@"${video_capture_url}" -c copy -map 0 -f segment -segment_time 600 -segment_format mp4 -strftime 1 "cctv_captures/${cctv_actual_filename}" -s '1920x1080' &
							sql_request_RW "INSERT INTO CCTV_CAPTURES ( ID, FILENAME, TRIGGERING_EVENT ) VALUES ( NULL, '${cctv_actual_filename}', '${1}' )"
				fi    
				
				# If the argument is 'alert', then we capture the stream and put it in a video file, and we upload the datas to the database to be able to retrieve it in the WebUI
				if [[ "${1}" -eq "alert" ]]
					then	nohup ffmpeg -t "${video_capture_timing}" -i rtsp://"${video_capture_username}":"${video_capture_password}"@"${video_capture_url}" -c copy -map 0 -f segment -segment_time 600 -segment_format mp4 -strftime 1 "cctv_captures/${cctv_actual_filename}" -s '1920x1080' &
							sql_request_RW "INSERT INTO CCTV_CAPTURES ( ID, FILENAME, TRIGGERING_EVENT ) VALUES ( NULL, '${cctv_actual_filename}', '${1}' )"
				fi
	fi
}



# Function set to kill a specific job which was detached from the script with the 'disown' command
kill_specific_job(){
	jobs | grep "${1}" | awk '{print substr($1,2,1)}' | while IFS= read -r job_number_to_kill; do
		kill "%${job_number_to_kill}"
	done
}

# Function to write datas in a .txt debug file // This function is available only if in the settings, the value "debug_activated" is set to 1
debug(){
	if [[ "${debug_activated}" -eq 1 ]]
		then	date +%Y_%m_%d__@__%H:%M:%S" / ${1}" >> "${debug_path}" 2>&1
	fi
}

event_log(){
	sql_request_RW "INSERT INTO EVENT_LOG ( ID, LOG_TIMESTAMP, EVENT_LOG_ILLUSTRATION, LOG_CONTENT ) VALUES ( NULL, NOW(), '${1}', '${2}' )"
}

# Function with a Read-Only user to fetch mysql datas from the database
sql_request_RO(){ 
	mysql -u alarm_read_only crids -sN -e "${1};" -p"${ropswd}";
}

# Function with a Read-Write user to get mysql datas and write datas in the database
sql_request_RW(){ 
	mysql -u alarm_read_write crids -sN -e "${1};" -p"${rwpswd}";
}

# Function to retrieve the timestamp of the last time a SMS was sent
timestamp_last_sms(){
	sql_request_RO "SELECT LAST_SMS_TIMESTAMP FROM ALERT_TRACKING"
}

# Function to know how much seconds have elapsed since the last time a SMS was sent
check_timestamp_last_sms(){
	expr $(date +%s) - $(timestamp_last_sms)
}

gpio_array_load_up(){
	mapfile gpio_array < <(sql_request_RO "select * from GPIO")
}

# Function to 'declare' and initiate all the variables and settings which will be used in the script
global_settings_load_up(){
	ropswd='password'
	rwpswd='password'
	
	while read -a row
		do	language="${row[1]}"
			log_folder="${row[2]}"
			alarm_set_on_delay="${row[3]}"
			debug_file="${row[4]}"
			default_alarm_status="${row[5]}"
			gpio_piezo_number="${row[6]}"
			user_input_method="${row[7]}"
			gpio_user_input_method="${row[8]}"
			gpio_user_input_method_circuit_mode="${row[9]}"
			silent_alarm="${row[10]}"
			silent_buzzer="${row[11]}"
			image_capture_folder="${row[12]}"
			alarm_temporisation_delay="${row[13]}"
			alarm_siren_max_time="${row[14]}"
			debug_activated="${row[15]}"
			gpio_status_led_pwr="${row[16]}"
			gpio_status_led_red="${row[17]}"
			gpio_status_led_blue="${row[18]}"
			gpio_status_led_green="${row[19]}"
			gpio_status_led_enabled="${row[20]}"
			send_sms_on_reboot="${row[21]}"
			video_capture_timing="${row[22]}"
			video_capture_password="${row[23]}"
			video_capture_username="${row[24]}"
			video_capture_url="${row[25]}"
			video_capture_on_alert_only="${row[26]}"
			trigger_alarm_on_lost_or_stolen_card="${row[27]}"
			# central_mode_override="${row[28]}" # Useless recovery of this setting
			silent_voice="${row[29]}"
			video_capture_enabled="${row[30]}"
			# led_status="${row[31]}"
			led_type='RGB_led_status'
			# audio_signal_type="${row[32]}"
			audio_signal_type='piezo_voice'
			# sms_provider="${row[33]}"
	done <<< $(sql_request_RO "select * from SETTINGS")
	total_access_points_to_monitor=$(sql_request_RO "SELECT COUNT(*) FROM GPIO")
	led_status set_up_gpio
	password_attempt=0
	debug_path="${log_folder}/${debug_file}"
	alarm_status="${default_alarm_status}"
	if	[[ "${gpio_piezo_number}" -ne 99 ]] # If the GPIO is not 99, then their is a piezo connected and we have to initiate it.
		then	gpio -g mode "${gpio_piezo_number}" out
				gpio -g write "${gpio_piezo_number}" 0
	fi
	while read -a row
		do	gpio -g mode "${row[0]}" OUT
			gpio -g write "${row[0]}" 1
			monitoring_gpio_number="${row[0]}"
			gpio_flag[$monitoring_gpio_number]="0"
	done <<< $(sql_request_RO "select monitoring_gpio_number from GPIO")
	echo "" > rfid_reader_capture.txt
	sudo systemctl restart rfid_reader.service
	gpio_array_load_up
}

# We call the function to load up all the global settings
global_settings_load_up

# This is the point where we check if the system was rebooted less than 2 minutes ago and if a SMS was already sent or not.
#	Since the Rpi is not supposed to be rebooted, and if the setting value 'send_sms_on_reboot' is set to 1 (enable), then we send a SMS because their was an unexpected event which might be sabotage
if [[ $(awk '{print $1}' /proc/uptime | awk -F '.' '{ print $1 }') -lt 120 && "${send_sms_on_reboot}" -eq 1 ]]
	then	send_sms central_rebooted
			sql_request_RW "UPDATE ALERT_TRACKING SET LAST_SMS_TIMESTAMP = `date +%s`"
			sound_player "${audio_signal_type}" message_alarm_central_rebooted
			capture_video_cctv alert_intrusion
fi

# Everytime the Rasberry restart or the service restart, we need to know it. So we add this as an event to the event log.
event_log "alarm_restart_loading.png" "The alarm finished to load the parameters, the alarm is starting now in the status ${default_alarm_status}"

# The system is based on a infinite loop, with time spacing to prevent it from overloading the OS
while true; do
	debug "_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-GENERAL LOOP START_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-" 
	debug "Start of general loop, here are the content of the following variables :"
	debug "rfid_reader_result = ${rfid_reader_result} // alarm_status = ${alarm_status} // last_alarm_known_status = ${last_alarm_known_status} // password_attempt = ${password_attempt} // sms_sent = ${sms_sent}"
	arming_cancellation=0

	# This is the alarm state where the alarm is not active and waiting for being armed or being under maintenance.
	case "${alarm_status}" in
		0)	sleep 0.8
			debug "We are in the status 0" 
			debug "At the moment, the alarm status is : ${alarm_status}, and at the moment, the rfid reader return value is : ${rfid_reader_result}" 
			debug "The central_mode_override read is : ${override_mode}"
			override_mode=$(sql_request_RO "select central_mode_override from SETTINGS")
			sql_request_RW "UPDATE ALARM_TRACKING SET CURRENT_STATUS = '${alarm_status}'"
			rfid_reader 0
			sms_sent=0
			pre_arming_check_result="OK"
			sql_request_RW "UPDATE ALARM_TRACKING SET CURRENT_STATUS = '${alarm_status}'"
			led_status off
			
			case "${override_mode}" in
				6)	global_settings_load_up
					event_log "alarm_restart_loading.png" "The alarm has finished reloading the global settings"
					sql_request_RW "UPDATE SETTINGS SET central_mode_override = '0'"
					sound_player "${audio_signal_type}" alterna_1 notification
				;;
				
				5)	sound_player "${audio_signal_type}" alterna_1 notification
					sound_player "${audio_signal_type}" message_alarm_management_mode_entered
					alarm_status=5
					event_log "alarm_management_mode_on.png" "The alarm has entered Management mode"
				;;
				
				2)	sound_player "${audio_signal_type}" alterna_1 notification
					sound_player "${audio_signal_type}" message_alarm_armed
					alarm_status=2
					sql_request_RW "UPDATE SETTINGS SET central_mode_override = '0'"
					event_log "alarm_monitoring.png" "Alarm was armed manually from the WebUI. The alarm is now activated and monitoring."
				;;
			esac
			if	[[ "${rfid_reader_result}" -eq 1 ]]
				then	alarm_status=1
						debug "We proceed to status 1" 
				else	sleep 1
			fi
			check_gpio_point_monitoring
		;;
		
	# This is the alarm state where the alarm is arming itself. The arming consists in making a self diagnostic of all the access point state, to make sure they are all closed, and let the user get out of the house before considering any opening of an access point being an possible intrusion
		1)	sleep 0.7
			debug "We are in the status 1"
			sql_request_RW "UPDATE ALARM_TRACKING SET CURRENT_STATUS = '${alarm_status}'"
			check_gpio_point_monitoring pre_arming_check
			if	[[ "${pre_arming_check_result}" == "OK" ]]
				then	sound_player "${audio_signal_type}" message_alarm_arming
						alarm_arming_end=$((SECONDS+"${alarm_set_on_delay}"))
						debug "It is ${SECONDS} in the system. With the variable ${alarm_set_on_delay}, we predict arming temporisation end time in ${alarm_arming_end}" 
						while [ $SECONDS -lt $alarm_arming_end ]
						  do	sleep 1
								rfid_reader 1
								check_gpio_point_monitoring
								led_status yellow "${alarm_set_on_delay}" & disown
								debug "The rfid reader return value is : ${rfid_reader_result}" 
								if	[[ "${rfid_reader_result}" -eq "1" ]]
									then	arming_cancellation=1
											sound_player "${audio_signal_type}" message_alarm_arming_canceled
											rfid_reader_result=0
											debug "Alarm arming canceled command received" 
											event_log "alarm_unlocked.png" "Alarm arming canceled command received from RFID attributed to ${rfid_attribution}"
											alarm_status=0
											led_status green 2 & disown
											break
								fi
						done
						if [[ $SECONDS -ge $alarm_arming_end && "${arming_cancellation}" -ne 1 ]]
							then	sound_player "${audio_signal_type}" message_alarm_armed
									alarm_status=2
									led_status red 999 & disown
									debug "We proceed to alarm status 2" 
									event_log "alarm_monitoring.png" "Alarm is now activated and monitoring."
						fi
						rfid_reader_result=0
				else	event_log "alarm_unlocked.png" "Alarm arming canceled command received because an access point configured as mandatory closed for arming is still detected as opened"
						alarm_status=0
			fi
		;;
		
	# This is the alarm state where the alarm is active and monitoring all the active access points.
		2)	sleep 0.5
			debug "We are in the status 2" 
			sql_request_RW "UPDATE ALARM_TRACKING SET CURRENT_STATUS = '${alarm_status}'" & disown >> /dev/null 2>&1
			check_gpio_point_monitoring
			if [[ "${password_attempt}" -lt 3 && ! "${alarm_status}" =~ ^('3'|'4')$ ]]
				then	rfid_reader 2
						if [[ "${rfid_reader_result}" -eq 2 ]]
							then	password_attempt=$(expr "${password_attempt}" + 1)
									event_log "wrong_rfid_card.png" "Unsuccessful attempt to unlock the alarm with RFID attributed to ${rfid_attribution}"
									# capture_image_cctv
						fi
						debug "We saw ${password_attempt} unsuccessful attempts of trying to unlock the alarm"
			fi
			if [[ "${password_attempt}" -ge 3 && ! "${alarm_status}" =~ ^('3'|'4')$ ]]
				then	alarm_status=4
						password_attempt=0
			fi
			rfid_reader_result=0
		;;
		
	# This is the alarm state where the alarm detected the opening of a temporised access point (ie :the front door), and is waiting for the user to authenticate as a legit human, getting inside the protected perimeter.
		3)	sleep 0.6
			debug "We are in the status 3  && Door opening detected !!!!"
			sound_player "${audio_signal_type}" alterna_4 notification
			sound_player "${audio_signal_type}" message_alarm_intrusion_detected
			open_tempo_end=$((SECONDS+"${alarm_temporisation_delay}"))
			last_call_sent=0
			sql_request_RW "UPDATE ALARM_TRACKING SET CURRENT_STATUS = '${alarm_status}'"
			last_call_before_alarm=$((open_tempo_end-7))
			debug "It is ${SECONDS} in the system. With the variable ${alarm_temporisation_delay}, we predict a temporisation end time at ${open_tempo_end}" 
			led_status purple 20 & disown
			while [[ $SECONDS -lt $open_tempo_end ]]
			  do	sleep 0.7
					rfid_reader 3
					if [[ $SECONDS -gt "${last_call_before_alarm}" && "${last_call_sent}" -eq 0 ]]
						then	send_sms intrusion
								sound_player "${audio_signal_type}" alterna_4 notification
								debug 'An acces point was detected as open, and still, no one has disabled the alarm, we are sending a last call sound if the legit user forgot to disable the alarm'
					fi
					if [[ "${password_attempt}" -lt 3 ]]
						then	if [[ "${rfid_reader_result}" -eq 2 ]]
									then	password_attempt=$(expr "${password_attempt}" + 1)
											# capture_image_cctv
											debug "We saw ${password_attempt} unsuccessful attempts of trying to unlock the alarm"
								fi
								if [[ "${rfid_reader_result}" -eq 1 ]] 
									then	debug "A valid RFID car have been checked, we disarm the alarm."
											led_status green 2 & disown
											alarm_status=0
											break
								fi
								check_gpio_point_monitoring
					fi
					if [[ "${password_attempt}" -ge 3 ]]
						then	send_sms intrusion
								alarm_status=4
								password_attempt=0
					fi
			done
			if [[ "${alarm_status}" -ne 0 ]]
				then	alarm_status=4
			fi
			rfid_reader_result=0
		;;
		
	# This is the alarm state where the alarm has detected a real intrusion!
		4)	sleep 0.6
			debug "We are in the status 4" 
			event_log "alarm_siren_on.png" "Intrusion alarm was triggered!"
			send_sms intrusion
			sms_sent=1
			sound_player "${audio_signal_type}" message_alarm_intrusion_confirmed
			led_status red 120 & disown
			triggered_alarm=1
			siren_end=$((SECONDS+"${alarm_siren_max_time}"))
			sound_player "${audio_signal_type}" alterna_120 intrusion
			sql_request_RW "UPDATE ALARM_TRACKING SET CURRENT_STATUS = '${alarm_status}'"
			capture_video_cctv alert_intrusion
			while [[ $SECONDS -lt $siren_end ]]
				do	sleep 0.7
					rfid_reader 4
					if [[ "${rfid_reader_result}" -eq 1 ]] 
						then	debug "A valid RFID car have been checked, we disarm the alarm." 
								led_status green 2
								break
					fi
			done
			alarm_status=0
			rfid_reader_result=0
		;;
		
	# This is the alarm state where the alarm is under maintenance, letting you see and modify the settings.
		5)	sleep 1
			debug "We are in the status 5" 
			rfid_reader 5
			override_mode=$(sql_request_RO "select central_mode_override from SETTINGS")
			debug "The central_mode_override read is : ${override_mode}"
			if [[ "${override_mode}" -eq 0 ]]
				then	debug "We leave the management mode"
						sound_player "${audio_signal_type}" alterna_1 notification
						alarm_status=0
						sound_player "${audio_signal_type}" message_alarm_management_mode_left
						sql_request_RW "UPDATE SETTINGS SET central_mode_override = '0'"
						event_log "alarm_management_mode_off.png" "The alarm has left Management mode"
			fi
		;;
	esac
	
	debug "_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-GENERAL LOOP END_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-" 
	debug "_________________________________________________________________________________" 
	

done



