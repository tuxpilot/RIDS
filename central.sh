#!/bin/bash

# Made by : Tuxpilot.eu

# Licence GNU v3






echo "" > rfid_reader_capture.txt
sudo systemctl restart rfid_reader.service

# functions

RGB_led_status(){
	if [[ "${gpio_status_led_enabled}" -eq 1 ]]
		then	while :
				do
					case "${1}" in
					set_up_gpio)
						gpio_status_led_green=$(sql_request_RO "select gpio_status_led_green from SETTINGS")
						gpio_status_led_red=$(sql_request_RO "select gpio_status_led_red from SETTINGS")
						gpio_status_led_blue=$(sql_request_RO "select gpio_status_led_blue from SETTINGS")
						gpio_status_led_pwr=$(sql_request_RO "select gpio_status_led_pwr from SETTINGS")
						gpio -g mode "${gpio_status_led_pwr}" OUT
						gpio -g mode "${gpio_status_led_red}" OUT
						gpio -g mode "${gpio_status_led_blue}" OUT
						gpio -g mode "${gpio_status_led_green}" OUT
						gpio -g write "${gpio_status_led_pwr}" 0
						gpio -g write "${gpio_status_led_red}" 0
						gpio -g write "${gpio_status_led_blue}" 0
						gpio -g write "${gpio_status_led_green}" 0
						break
						;;
					green)
						pkill -f RGB_led
						gpio -g write "${gpio_status_led_green}" 1
						if [[ "${2}" -ne 999 ]]
							then	sleep "${2}"
						fi
						gpio -g write "${gpio_status_led_green}" 0
						break
						;;
					blue)
						pkill -f RGB_led
						gpio -g write "${gpio_status_led_blue}" 1
						if [[ "${2}" -ne 999 ]]
							then	sleep "${2}"
						fi
						gpio -g write "${gpio_status_led_blue}" 0
						break
						;;
					red)
						pkill -f RGB_led
						gpio -g write "${gpio_status_led_red}" 1
						if [[ "${2}" -ne 999 ]]
							then	sleep "${2}"
						fi
						gpio -g write "${gpio_status_led_red}" 0
						break
						;;
					purple)
						pkill -f RGB_led
						gpio -g write "${gpio_status_led_red}" 1
						gpio -g write "${gpio_status_led_blue}" 1
						if [[ "${2}" -ne 999 ]]
							then	sleep "${2}"
						fi
						gpio -g write "${gpio_status_led_red}" 0
						gpio -g write "${gpio_status_led_blue}" 0
						break
						;;				
					yellow)
						pkill -f RGB_led
						gpio -g write "${gpio_status_led_red}" 1
						gpio -g write "${gpio_status_led_green}" 1
						if [[ "${2}" -ne 999 ]]
							then	sleep "${2}"
						fi
						gpio -g write "${gpio_status_led_red}" 0
						gpio -g write "${gpio_status_led_green}" 0
						break
						;;
					cyan)
						pkill -f RGB_led
						gpio -g write "${gpio_status_led_green}" 1
						gpio -g write "${gpio_status_led_blue}" 1
						if [[ "${2}" -ne 999 ]]
							then	sleep "${2}"
						fi
						gpio -g write "${gpio_status_led_green}" 0
						gpio -g write "${gpio_status_led_blue}" 0
						break
						;;
					white)
						pkill -f RGB_led
						gpio -g write "${gpio_status_led_red}" 1
						gpio -g write "${gpio_status_led_blue}" 1
						gpio -g write "${gpio_status_led_green}" 1
						if [[ "${2}" -ne 999 ]]
							then	sleep "${2}"
						fi
						gpio -g write "${gpio_status_led_red}" 0
						gpio -g write "${gpio_status_led_blue}" 0
						gpio -g write "${gpio_status_led_green}" 0
						break
						;;
					off)
						pkill -f RGB_led
						gpio -g write "${gpio_status_led_red}" 0
						gpio -g write "${gpio_status_led_blue}" 0
						gpio -g write "${gpio_status_led_green}" 0
						break
						;;
				  esac
				done
		fi
}

check_gpio_point_monitoring(){
	while read -a row
		do 	monitoring_gpio_number="${row[1]}"
			monitoring_gpio_value_access_closed="${row[2]}"
			monitoring_gpio_name="${row[3]}"
			monitoring_gpio_current_state=$(gpio -g read "${monitoring_gpio_number}")
			tempo_trigger_alarm="${row[5]}"
			gpio_open_flag="${row[6]}"
			debug  "The GPIO ${monitoring_gpio_number} has a value of : ${monitoring_gpio_current_state} // when the acccess is closed, it must return a value of : ${monitoring_gpio_value_access_closed}, and it has a tempo trigger time of : ${tempo_trigger_alarm}" 
			
			if [[ "${monitoring_gpio_current_state}" -ne "${monitoring_gpio_value_access_closed}" && "${gpio_open_flag}" -eq 0 ]]
				then	event_log "door_open.png" "The access ${monitoring_gpio_name} is detected as open"
			fi
			
			if [[ "${monitoring_gpio_current_state}" -ne "${monitoring_gpio_value_access_closed}" && "${tempo_trigger_alarm}" -ne 0 && "${alarm_status}" -ne 0  && "${alarm_status}" -ne 1 ]]
				then	alarm_status=3
						debug "The access point linked to the GPIO : ${monitoring_gpio_number}, named : ${monitoring_gpio_name}, is detected as open. We proceed to the alarm status 3"
						event_log "alarm_state_3.png" "The access ${monitoring_gpio_name} triggered the temporisation of the alarm!!!"
						if [[ "${gpio_open_flag}" -eq 0 ]]
							then	sql_request_RW "UPDATE GPIO SET monitoring_gpio_current_state = '${monitoring_gpio_current_state}', gpio_open_flag = '1'"
						fi
						# capture_image_cctv
						capture_video_cctv alert_door_opened
			fi
			if [[ "${monitoring_gpio_current_state}" -ne "${monitoring_gpio_value_access_closed}" && "${tempo_trigger_alarm}" -eq 0 && "${alarm_status}" -ne 0  && "${alarm_status}" -ne 1 ]]
				then	alarm_status=4
						event_log "alarm_state_4.png" "The access ${monitoring_gpio_name} triggered the alarm!!!"
						debug "The access point linked to the GPIO : ${monitoring_gpio_number}, named : ${monitoring_gpio_name}, is detected as open. We proceed to the alarm status 4" 
						if [[ "${gpio_open_flag}" -eq 0 ]]
							then	sql_request_RW "UPDATE GPIO SET monitoring_gpio_current_state = '${monitoring_gpio_current_state}', gpio_open_flag = '1'"
						fi
						capture_video_cctv alert_intrusion
			fi
			if [[ "${monitoring_gpio_current_state}" -ne "${monitoring_gpio_value_access_closed}" && "${alarm_status}" -eq 0 ]]
				then	if [[ "${gpio_open_flag}" -eq 0 ]]
							then	sql_request_RW "UPDATE GPIO SET monitoring_gpio_current_state = '${monitoring_gpio_current_state}', gpio_open_flag = '1'"
									capture_video_cctv notification_door_opened
						fi
			fi
			if [[ "${monitoring_gpio_current_state}" -ne "${monitoring_gpio_value_access_closed}" && "${alarm_status}" -eq 1 ]]
				then	if [[ "${gpio_open_flag}" -eq 0 ]]
							then	sql_request_RW "UPDATE GPIO SET monitoring_gpio_current_state = '${monitoring_gpio_current_state}', gpio_open_flag = '1'"
									capture_video_cctv notification_door_opened
						fi
			fi
			if [[ "${monitoring_gpio_current_state}" -eq "${monitoring_gpio_value_access_closed}" && "${gpio_open_flag}" -eq 1 ]]
				then	event_log "door_closed.png" "The access ${monitoring_gpio_name} is detected as closed"
						sql_request_RW "UPDATE GPIO SET monitoring_gpio_current_state = '${monitoring_gpio_current_state}', gpio_open_flag = '0'"
			fi
	done <<< $(sql_request_RO "select * from GPIO")
}

send_sms(){
	while read -a row
		do	FIRST_NAME="${row[1]}"
			LAST_NAME="${row[2]}"
			SEND_SMS="${row[3]}"
			SEND_EMAIL="${row[4]}"
			SMS_NUMBER="${row[5]}"
			EMAIL_ADDRESS="${row[6]}"
			sms_message_body=$(cat language/"${language}"/sms_messages.txt | grep "${1}" | awk -F '=' '{ print $2 }' )
			if [[ "${sms_sent}" -ne 1 && "${SEND_SMS}" -eq 1 ]]
				then	php bin/OVH_API/php-ovh-dep/sms-sender.php "${SMS_NUMBER}" "${sms_message_body}" & disown >> /dev/null 2>&1						
			fi
			sql_request_RW "UPDATE ALERT_TRACKING SET LAST_SMS_TIMESTAMP = `date +%s`"
			debug "date +%Y_%m_%d__@__%H:%M_sent-to_${recipient_name}_AND_MESSAGE_${sms_message_body}"
	done <<< $(sql_request_RO "select * from ALERTS_RECIPIENTS")
}

sound_player(){
	if [[ "${silent_voice}" -eq 0 ]]
		then	if [[ "${alarm_status}" -ne 4 && "${alarm_status}" -ne 3 ]]
					then	omxplayer --no-keys -o local "language/${language}/${1}.wav" Audio codec pcm_s16le channels 1 samplerate 16000 bitspersample 16 > /dev/null 2>&1
					else	omxplayer --no-keys -o local "language/${language}/${1}.wav" Audio codec pcm_s16le channels 1 samplerate 16000 bitspersample 16 > /dev/null 2>&1 &
				fi
	fi
	debug -e "on joue ${1}.wav"
}



rfid_reader(){ 
	rfid_reader_result=0
	valid_rfid_detected=1
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
										sound_player message_alarm_rfid_added
										event_log "added_rfid_card.png" "New RFID added with success."
								
								else	debug "Unknown RFID!: ${rfid_reader_capture}" 
										event_log "wrong_rfid_card.png" "Unknown RFID detected !"
										piezo_alarm_sound alterna_2 notification
										sound_player message_alarm_unkown_rfid_card
										rfid_reader_result=2
										echo "" > rfid_reader_capture.txt
							fi
							
					else	rfid_reader_result=1
							piezo_alarm_sound alterna_1 notification
							debug "function rfid not void : last_alarm_known_status = ${last_alarm_known_status} AND We found a known RFID : @${valid_rfid_request}@ "
							password_attempt=0
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
										piezo_alarm_sound alterna_2 notification
										sound_player message_alarm_rfid_has_no_name	
										valid_rfid_detected=0
										event_log "wrong_rfid_card.png" "The RFID card number ${rfid_card_ID} was detected and is part of the database, but has no user attributed to it. We can't let an access to a card which has no attribution name for security reasons"
							fi
							if 	[[ "${rfid_card_flag}" == *"lost"* || "${rfid_card_flag}" == *"stolen"* ]]
								then	debug "That RFID card ${rfid_card_ID} is detected, is in the database but the ID is referenced as stolen or lost!."
										valid_rfid_detected=0
										if 	[[ "${trigger_alarm_on_lost_or_stolen_card}" -eq 1 ]]
											then	piezo_alarm_sound alterna_2 intrusion
													sound_player message_alarm_rfid_revoked	
													alarm_status=4
													event_log "wrong_rfid_card.png" "The RFID card number ${rfid_card_ID} was detected and is referenced as lost or stolen! Alarm is triggered!"
											else	piezo_alarm_sound alterna_2 notification
													sound_player message_alarm_rfid_revoked	
													event_log "wrong_rfid_card.png" "The RFID card number ${rfid_card_ID} was detected and is referenced as lost or stolen!"
										fi
										
							fi
							if [[ "${alarm_status}" -eq 5 ]]
								then	debug "We noticed that the RFID card @${valid_rfid_request}@ attributed to ${rfid_card_ID} already exists" 
										sound_player message_alarm_rfid_already_exists	
							fi
							if [[ "${alarm_status}" -eq 4 && "${valid_rfid_detected}" == 1 ]]
								then	debug "We kill the piezo alarm" 
										pkill -f piezo
										debug "Sending the reset of the piezo gpio"
										gpio -g write "${gpio_piezo_number}" 0
										sound_player message_alarm_password_success
										alarm_status=0
										event_log "good_rfid_card.png" "Alarm disabled with the RFID card attributed to ${rfid_attribution}"
							fi
							if [[ "${alarm_status}" -eq 3 && "${valid_rfid_detected}" == 1 ]]
								then	sound_player message_alarm_password_success
										alarm_status=0
										event_log "alarm_unlocked.png" "The RFID attributed to ${rfid_attribution} successfully unlocked the alarm"
							fi
							if [[ "${alarm_status}" -eq 2 && "${valid_rfid_detected}" == 1 ]]
								then	sound_player message_alarm_password_success
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
		else	debug "No RFID card seems to have been in contact" 
	fi
}



piezo_alarm_sound(){
	if [[ "${2}" == "notification" && "${silent_buzzer}" -eq 0 ]]
		then	./piezo_alarm_sound.sh "${1}" "${gpio_piezo_number}" & disown
	fi
	if [[ "${2}" == "alert" && "${silent_alarm}" -eq 0 ]]  
		then	./piezo_alarm_sound.sh "${1}" "${gpio_piezo_number}" & disown
	fi
}

initiate_user_input(){
	if [[ $(sql_request_RO "select user_input_method from SETTINGS") == "dry_contact" ]]
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

capture_image_cctv(){
    outfilename=`date +"img-%Y-%m-%d_%H-%M-%S.jpg"`
	ffmpeg -loglevel fatal -rtsp_transport tcp -i "${video_capture_url}" -r 1 -vframes 1 "${image_capture_folder}${outfilename}"
    #function sendmail avec piece jointe image
}


capture_video_cctv(){
	if [[ "${video_capture_enabled}" -eq 1 ]]
		then	cctv_actual_filename=$(date +%Y-%m-%d_%H-%M-%S.mp4)
				if [[ "${1}" -ne "alert" && "${video_capture_on_alert_only}" -eq 0 ]]
					then	nohup ffmpeg -t "${video_capture_timing}" -i rtsp://"${video_capture_username}":"${video_capture_password}"@"${video_capture_url}" -c copy -map 0 -f segment -segment_time 600 -segment_format mp4 -strftime 1 "cctv_captures/${cctv_actual_filename}" -s '1920x1080' &
							sql_request_RW "INSERT INTO CCTV_CAPTURES ( ID, FILENAME, TRIGGERING_EVENT ) VALUES ( NULL, '', '${1}' )"
				fi    
				if [[ "${1}" -eq "alert" ]]
					then	nohup ffmpeg -t "${video_capture_timing}" -i rtsp://"${video_capture_username}":"${video_capture_password}"@"${video_capture_url}" -c copy -map 0 -f segment -segment_time 600 -segment_format mp4 -strftime 1 "cctv_captures/${cctv_actual_filename}" -s '1920x1080' &
							sql_request_RW "INSERT INTO CCTV_CAPTURES ( ID, FILENAME, TRIGGERING_EVENT ) VALUES ( NULL, '${cctv_actual_filename}', '${1}' )"
				fi
	fi
}



kill_specific_job(){
	jobs | grep "${1}" | awk '{print substr($1,2,1)}' | while IFS= read -r job_number_to_kill; do
		kill "%${job_number_to_kill}"
	done
}

debug(){
	if [[ "${debug_activated}" -eq 1 ]]
		then	date +%Y_%m_%d__@__%H:%M:%S" / ${1}" >> "${debug_path}" 2>&1
	fi
}

event_log(){
	sql_request_RW "INSERT INTO EVENT_LOG ( ID, LOG_TIMESTAMP, EVENT_LOG_ILLUSTRATION, LOG_CONTENT ) VALUES ( NULL, NOW(), '${1}', '${2}' )"
}


sql_request_RO(){ 
	mysql -u alarm_read_only crids -sN -e "${1};" -p"${ropswd}";
}

sql_request_RW(){ 
	mysql -u alarm_read_write crids -sN -e "${1};" -p"${rwpswd}";
}

timestamp_last_sms(){
	sql_request_RO "SELECT LAST_SMS_TIMESTAMP FROM ALERT_TRACKING"
}

check_timestamp_last_sms(){
	expr $(date +%s) - $(timestamp_last_sms)
}


global_settings_load_up(){
	ropswd='password'
	rwpswd='password'
	debug_activated=$(sql_request_RO "select debug_activated from SETTINGS")
	log_folder=$(sql_request_RO "select log_folder from SETTINGS")
	debug_file=$(sql_request_RO "select debug_file from SETTINGS")
	debug_path="${log_folder}/${debug_file}"
	password_attempt=0
	language=$(sql_request_RO "select language from SETTINGS")
	default_alarm_status=$(sql_request_RO "select default_alarm_status from SETTINGS")
	video_capture_timing=$(sql_request_RO "select video_capture_timing from SETTINGS")
	video_capture_password=$(sql_request_RO "select video_capture_password from SETTINGS")
	video_capture_username=$(sql_request_RO "select video_capture_username from SETTINGS")
	video_capture_url=$(sql_request_RO "select video_capture_url from SETTINGS")
	silent_voice=$(sql_request_RO "select silent_voice from SETTINGS")
	alarm_status="${default_alarm_status}"
	silent_alarm=$(sql_request_RO "select silent_alarm from SETTINGS")
	silent_buzzer=$(sql_request_RO "select silent_buzzer from SETTINGS")
	gpio_piezo_number=$(sql_request_RO "select gpio_piezo_number from SETTINGS")
	gpio_status_led_enabled=$(sql_request_RO "select gpio_status_led_enabled from SETTINGS")
	RGB_led_status set_up_gpio
	alarm_set_on_delay=$(sql_request_RO "select alarm_set_on_delay from SETTINGS")
	alarm_temporisation_delay=$(sql_request_RO "select alarm_temporisation_delay from SETTINGS")
	alarm_siren_max_time=$(sql_request_RO "select alarm_siren_max_time from SETTINGS")
	send_sms_on_reboot=$(sql_request_RO "select send_sms_on_reboot from SETTINGS")
	disarm_alarm_password=$(sql_request_RO "select send_sms_on_reboot from SETTINGS")
	video_capture_on_alert_only=$(sql_request_RO "select video_capture_enabled from SETTINGS")
	video_capture_on_alert_only=$(sql_request_RO "select video_capture_on_alert_only from SETTINGS")
	image_capture_folder=$(sql_request_RO "select image_capture_folder from SETTINGS")
	trigger_alarm_on_lost_or_stolen_card=$(sql_request_RO "select trigger_alarm_on_lost_or_stolen_card from SETTINGS")
	gpio -g mode "${gpio_piezo_number}" out
	gpio -g write "${gpio_piezo_number}" 0
}

global_settings_load_up


if [[ $(awk '{print $1}' /proc/uptime | awk -F '.' '{ print $1 }') -lt 120 && sent_sms_after_reboot -ne 1 ]]
	then	sql_request_RW "UPDATE ALERT_TRACKING SET LAST_SMS_TIMESTAMP = `date +%s`"
			send_sms central_rebooted
			sound_player message_alarm_central_rebooted
			# capture_image_cctv
fi


event_log "alarm_restart_loading.png" "The alarm finished to load the parameters, the alarm is starting now in the status ${default_alarm_status}"


while true; do
	sleep 0.8
	debug "_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-GENERAL LOOP START_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-" 
	debug "Start of general loop, here are the content of the following variables :"
	debug "rfid_reader_result = ${rfid_reader_result} // alarm_status = ${alarm_status} // last_alarm_known_status = ${last_alarm_known_status} // password_attempt = ${password_attempt} // sms_sent = ${sms_sent}"
	arming_cancellation=0


	if [[ "${alarm_status}" -eq 0 ]]
		then	override_mode=$(sql_request_RO "select central_mode_override from SETTINGS")
				sql_request_RW "UPDATE ALARM_TRACKING SET CURRENT_STATUS = '${alarm_status}'"
				debug "The central_mode_override read is : ${override_mode}"
				if [[ "${override_mode}" -eq 6 ]]
					then	global_settings_load_up
							event_log "alarm_restart_loading.png" "The alarm has finished reloading the global settings"
							sql_request_RW "UPDATE SETTINGS SET central_mode_override = '0'"
							piezo_alarm_sound alterna_1 notification
				fi
				if [[ "${override_mode}" -eq 5 ]]
					then	piezo_alarm_sound alterna_1 notification
							sound_player message_alarm_management_mode_entered
							alarm_status=5
							event_log "alarm_management_mode_on.png" "The alarm has entered Management mode"
				fi
				if [[ "${override_mode}" -eq 2 ]]
					then	piezo_alarm_sound alterna_1 notification
							sound_player message_alarm_armed
							alarm_status=2
							sql_request_RW "UPDATE SETTINGS SET central_mode_override = '0'"
							event_log "alarm_monitoring.png" "Alarm was armed manually from the WebUI. The alarm is now activated and monitoring."
				fi
				rfid_reader 0
				sql_request_RW "UPDATE ALARM_TRACKING SET CURRENT_STATUS = '${alarm_status}'"
				debug "We are in the status 0" 
				RGB_led_status off
				sms_sent=0
				debug "At the moment, the alarm status is : ${alarm_status}, and at the moment, the rfid reader return value is : ${rfid_reader_result}" 
				if	[[ "${rfid_reader_result}" -eq 1 ]]
					then	alarm_status=1
							debug "We proceed to status 1" 
							event_log "alarm_armed.png" "Alarm was activated with the RFID attributed to ${rfid_attribution}"
					else	sleep 1
				fi
				check_gpio_point_monitoring
	fi


	if [[ "${alarm_status}" -eq 1 ]]
		then	debug "We are in the status 1"
				sql_request_RW "UPDATE ALARM_TRACKING SET CURRENT_STATUS = '${alarm_status}'"
				check_gpio_point_monitoring
				while read -a row
					do	monitoring_gpio_number="${row[1]}"
						monitoring_gpio_value_access_closed="${row[2]}"
						monitoring_gpio_name="${row[3]}"
						monitoring_gpio_current_state=$(gpio -g read "${monitoring_gpio_number}")
						debug "We check the state of the GPIO number ${monitoring_gpio_number}" 
						debug "The GPIO ${monitoring_gpio_number}, when access is closed, must have a value of : ${monitoring_gpio_value_access_closed}" 
						if [[ "${monitoring_gpio_current_state}" -ne "${monitoring_gpio_value_access_closed}" ]]
							then	debug "GPIO number ${monitoring_gpio_number} returns the access is still open, it should have a value of: ${monitoring_gpio_value_access_closed}, but instead we find a value of ${test_current_gpio} " 
									event_log "alarm_armed.png" "door_open.png" "Warning! The alarm is arming but the access ${monitoring_gpio_name} is still detected as opened"
									piezo_alarm_sound alterna_3 notification
									sound_player message_alarm_arming_still_open
						fi
				done <<< $(sql_request_RO "select * from ALERTS_RECIPIENTS")
				sound_player message_alarm_arming
				alarm_arming_end=$((SECONDS+"${alarm_set_on_delay}"))
				debug "It is ${SECONDS} in the system. With the variable ${alarm_set_on_delay}, we predict arming temporisation end time in ${alarm_arming_end}" 
				while [ $SECONDS -lt $alarm_arming_end ]
				  do	sleep 1
						rfid_reader 1
						check_gpio_point_monitoring
						RGB_led_status yellow "${alarm_set_on_delay}" & disown
						debug "The rfid reader return value is : ${rfid_reader_result}" 
						if	[[ "${rfid_reader_result}" -eq "1" ]]
							then	arming_cancellation=1
									sound_player message_alarm_arming_canceled
									rfid_reader_result=0
									debug "Alarm arming canceled command received" 
									event_log "alarm_unlocked.png" "Alarm arming canceled command received from RFID attributed to ${rfid_attribution}"
									alarm_status=0
									RGB_led_status green 2 & disown
									break
						fi
				done
				if [[ $SECONDS -ge $alarm_arming_end && "${arming_cancellation}" -ne 1 ]]
					then	sound_player message_alarm_armed
							alarm_status=2
							RGB_led_status yellow 999 & disown
							debug "We proceed to alarm status 2" 
							event_log "alarm_monitoring.png" "Alarm is now activated and monitoring."
				fi
				rfid_reader_result=0
	fi


	if [[ "${alarm_status}" -eq 2 ]]
		then	debug "We are in the status 2" 
				sql_request_RW "UPDATE ALARM_TRACKING SET CURRENT_STATUS = '${alarm_status}'"
				RGB_led_status red 999 & disown
				check_gpio_point_monitoring
				if [[ "${password_attempt}" -lt 3 ]]
					then	rfid_reader 2
							if [[ "${rfid_reader_result}" -eq 2 ]]
								then	password_attempt=$(expr "${password_attempt}" + 1)
										event_log "wrong_rfid_card.png" "Unsuccessful attempt to unlock the alarm with RFID attributed to ${rfid_attribution}"
										# capture_image_cctv
							fi
							debug "We saw ${password_attempt} unsuccessful attempts of trying to unlock the alarm"
				fi
				if [[ "${password_attempt}" -ge 3 ]]
					then	alarm_status=4
							password_attempt=0
				fi
				rfid_reader_result=0
	fi


	if [[ "${alarm_status}" -eq 3 ]]
		then	debug "We are in the status 3"
				last_call_sent=0
				sql_request_RW "UPDATE ALARM_TRACKING SET CURRENT_STATUS = '${alarm_status}'"
				debug "Door opening detected" 
				open_tempo_end=$((SECONDS+"${alarm_temporisation_delay}"))
				last_call_before_alarm=$((open_tempo_end-7))
				debug "It is ${SECONDS} in the system. With the variable ${alarm_temporisation_delay}, we predict a temporisation end time at ${open_tempo_end}" 
				piezo_alarm_sound alterna_4 notification
				sound_player message_alarm_intrusion_detected
				RGB_led_status purple 20 & disown
				while [[ $SECONDS -lt $open_tempo_end ]]
				  do	sleep 0.7
						rfid_reader 3
						if [[ $SECONDS -gt "${last_call_before_alarm}" && "${last_call_sent}" -eq 0 ]]
							then	piezo_alarm_sound alterna_4 notification
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
												RGB_led_status green 2 & disown
												alarm_status=0
												break
									fi
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
	fi

	if [[ "${alarm_status}" -eq 4 ]]
		then	debug "We are in the status 4" 
				event_log "alarm_siren_on.png" "Intrusion alarm was triggered!"
				send_sms intrusion
				sms_sent=1
				sound_player message_alarm_intrusion_confirmed
				RGB_led_status red 120 & disown
				triggered_alarm=1
				siren_end=$((SECONDS+"${alarm_siren_max_time}"))
				piezo_alarm_sound alterna_120 intrusion
				sql_request_RW "UPDATE ALARM_TRACKING SET CURRENT_STATUS = '${alarm_status}'"
				capture_video_cctv alert_intrusion
				while [[ $SECONDS -lt $siren_end ]]
					do	sleep 0.7
						rfid_reader 4
						if [[ "${rfid_reader_result}" -eq 1 ]] 
							then	debug "A valid RFID car have been checked, we disarm the alarm." 
									RGB_led_status green 2
									break
						fi
				done
				alarm_status=0
				rfid_reader_result=0
	fi
	
	if [[ "${alarm_status}" -eq 5 ]]
		then	debug "We are in the status 5" 
				rfid_reader 5
				override_mode=$(sql_request_RO "select central_mode_override from SETTINGS")
				debug "The central_mode_override read is : ${override_mode}"
				if [ "${override_mode}" -eq 0 ]
					then	debug "We leave the management mode"
							piezo_alarm_sound alterna_1 notification
							alarm_status=0
							sound_player message_alarm_management_mode_left
							sql_request_RW "UPDATE SETTINGS SET central_mode_override = '0'"
							event_log "alarm_management_mode_off.png" "The alarm has left Management mode"
				fi
	fi
	debug "_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-GENERAL LOOP END_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-" 
	debug "_________________________________________________________________________________" 
	

done

