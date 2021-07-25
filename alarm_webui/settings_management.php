<?php




if($alarm_status != 5)
{
	echo "<span style=color:red>Warning the alarm is not in management mode, no modification can be made<span>.<br>";
}else{
	



	if(isset($_GET['action']))
	{
		$action = $_GET['action'];
		if($action == "reload_settings" && $alarm_status == 5)
		{
			include ('db-rw-connect.php');
			$actionrequest = sprintf("SELECT * FROM SETTINGS");
			$actionresult = $conn->query($actionrequest);
		}
	}
	
	
	include ('db-ro-connect.php');
	
	$settingsquery = sprintf("SELECT * FROM SETTINGS");
	$settingsresult = $conn->query($settingsquery);
	


	echo "<center><table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse; width: 80%; margin: 1.5em; font-family: Arial, Helvetica, sans-serif; font-size: 0.85em;'><tbody>";
	while($row = $settingsresult->fetch_assoc()) {
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>language</td><td><form action=edit_settings.php><input id=language value=".$row['language']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>log_folder</td><td><form action=edit_settings.php><input id=log_folder value=".$row['log_folder']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>alarm_set_on_delay</td><td><form action=edit_settings.php><input id=alarm_set_on_delay value=".$row['alarm_set_on_delay']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>debug_file</td><td><form action=edit_settings.php><input id=debug_file value=".$row['debug_file']."></input></form></td></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>default_alarm_status</td><td><form action=edit_settings.php><input id=default_alarm_status value=".$row['default_alarm_status']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>gpio_piezo_number</td><td><form action=edit_settings.php><input id=gpio_piezo_number value=".$row['gpio_piezo_number']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>user_input_method</td><td><form action=edit_settings.php><input id=user_input_method value=".$row['user_input_method']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>gpio_user_input_method</td><td><form action=edit_settings.php><input id=gpio_user_input_method value=".$row['gpio_user_input_method']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>gpio_user_input_method_circuit_mode</td><td><form action=edit_settings.php><input id=gpio_user_input_method_circuit_mode value=".$row['gpio_user_input_method_circuit_mode']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>silent_alarm</td><td><form action=edit_settings.php><input id=silent_alarm value=".$row['silent_alarm']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>silent_buzzer</td><td><form action=edit_settings.php><input id=silent_buzzer value=".$row['silent_buzzer']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>image_capture_folder</td><td><form action=edit_settings.php><input id=image_capture_folder value=".$row['image_capture_folder']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>alarm_temporisation_delay</td><td><form action=edit_settings.php><input id=alarm_temporisation_delay value=".$row['alarm_temporisation_delay']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>alarm_siren_max_time</td><td><form action=edit_settings.php><input id=alarm_siren_max_time value=".$row['alarm_siren_max_time']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>debug_activated</td><td><form action=edit_settings.php><input id=debug_activated value=".$row['debug_activated']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>gpio_status_led_pwr</td><td><form action=edit_settings.php><input id=gpio_status_led_pwr value=".$row['gpio_status_led_pwr']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>gpio_status_led_red</td><td><form action=edit_settings.php><input id=gpio_status_led_red value=".$row['gpio_status_led_red']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>gpio_status_led_blue</td><td><form action=edit_settings.php><input id=gpio_status_led_blue value=".$row['gpio_status_led_blue']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>gpio_status_led_green</td><td><form action=edit_settings.php><input id=gpio_status_led_green value=".$row['gpio_status_led_green']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>gpio_status_led_enabled</td><td><form action=edit_settings.php><input id=gpio_status_led_enabled value=".$row['gpio_status_led_enabled']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>send_sms_on_reboot</td><td><form action=edit_settings.php><input id=send_sms_on_reboot value=".$row['send_sms_on_reboot']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>video_capture_timing</td><td><form action=edit_settings.php><input id=video_capture_timing value=".$row['video_capture_timing']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>video_capture_password</td><td><form action=edit_settings.php><input id=video_capture_password value=".$row['video_capture_password']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>video_capture_username</td><td><form action=edit_settings.php><input id=video_capture_username value=".$row['video_capture_username']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>video_capture_url</td><td><form action=edit_settings.php><input id=video_capture_url value=".$row['video_capture_url']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>video_capture_on_alert_only</td><td><form action=edit_settings.php><input id=video_capture_on_alert_only value=".$row['video_capture_on_alert_only']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>trigger_alarm_on_lost_or_stolen_card</td><td><form action=edit_settings.php><input id=trigger_alarm_on_lost_or_stolen_card value=".$row['trigger_alarm_on_lost_or_stolen_card']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>central_mode_override</td><td><form action=edit_settings.php><input id=central_mode_override value=".$row['central_mode_override']."></input></form></td></tr>";
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>silent_voice</td><td><form action=edit_settings.php><input id=silent_voice value=".$row['silent_voice']."></input></form></td</tr>";
	}
	echo "</table></center>";
	echo "<a href='index.php?page=settings_management&action=reload_settings'><button>Reload the settings</button></a>";
}
?>
