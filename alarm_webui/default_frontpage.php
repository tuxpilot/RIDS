<?php





if(isset($_GET['action']))
{
	$action = $_GET['action'];
	include ('db-rw-connect.php');


	if($action == "enter_management_mode" && $alarm_status == 0)
	{
		$mode_changer_query = sprintf("UPDATE SETTINGS SET central_mode_override = '5'");
		$mode_changer = $conn->query($mode_changer_query);
		if (!$mode_changer) {
			$message  = 'Requête invalide : ' . mysql_error() . "\n";
			$message .= 'Requête complète : ' . $mode_changer_query;
			die($message);
			$conn->close();
		}
	}
	if($action == "webui_alarm_arming" && $alarm_status == 0)
	{
		$mode_changer_query = sprintf("UPDATE SETTINGS SET central_mode_override = '2'");
		$mode_changer = $conn->query($mode_changer_query);
		if (!$mode_changer) {
			$message  = 'Requête invalide : ' . mysql_error() . "\n";
			$message .= 'Requête complète : ' . $mode_changer_query;
			die($message);
			$conn->close();
		}
	}
	if($action == "enter_management_mode" && $alarm_status != 0)
	{
		echo "<span style=color:red>Warning the alarm is not disabled, please disable the alarm before trying to enter management mode<span>.<br>";
	}
	if($action == "webui_alarm_arming" && $alarm_status != 0)
	{
		echo "<span style=color:red>Warning the alarm is not disabled, please disable the alarm before trying to manually arm the alarm from the WebUI<span>.<br>";
	}
	if($action == "leave_management_mode" && $alarm_status == 5)
	{
		$mode_changer_query = sprintf("UPDATE SETTINGS SET central_mode_override = '0'");
		$mode_changer = $conn->query($mode_changer_query);
		if (!$mode_changer) {
			$message  = 'Requête invalide : ' . mysql_error() . "\n";
			$message .= 'Requête complète : ' . $mode_changer_query;
			die($message);
			$conn->close();
		}
	}
}








include ('db-ro-connect.php');
$status_query = sprintf("SELECT * FROM SETTINGS");
$alarm_status_res = $conn->query($status_query);
$conn->close();
while($row = $alarm_status_res->fetch_assoc()) {
   if ($row['arduino_connected'] == 1 )
   {
	   include ('state_panel_with_arduino.php');
	   $arduino_connected=1;
   }else{
	   include ('state_panel_without_arduino.php');
	   $arduino_connected=0;
   }
}


echo "<div id=menu_lower>";
echo "<a href=index.php?page=log_viewer><img src=images/alarm_event_log.png height=120px class='menu'>Check the event logs</a><br>";
if($arduino_connected == 1)
{
	echo "<a href=index.php?page=arduino_tracking><img src=images/arduino_tracking.png height=120px class='menu'>Monitor the Arduino</a><br>";
}
echo "<a href=index.php?page=access_point_monitoring><img src=images/access_point_monitoring.png height=120px class='menu'>Monitor the Access points state</a><br>";
echo "<a href=index.php?action=webui_alarm_arming><img src=images/alarm_web_arming.png height=120px class='menu'>Manually arm the alarm from the WebUI</a><br>";
if($alarm_status == 5)
{
	echo "<a href=index.php?page=rfid_management><img src=images/rfid_management.png height=120px class='menu'>Add/Remove/Manage RFID cards</a><br>";
	echo "<a href=index.php?page=settings_management><img src=images/global_settings.png height=120px class='menu'>Edit the Global Settings</a><br>";
	echo "<a href=index.php?page=gpio_settings><img src=images/gpio_settings.png height=120px class='menu'>GPIO management</a><br>";
	echo "<a href=index.php?page=cameras_management><img src=images/cameras_management.png height=120px class='menu'>Cameras management</a><br>";
	echo "<a href=index.php?action=leave_management_mode><img src=images/alarm_management_leave.png height=120px class='menu'>Leave management mode</a><br>";
}else{
	echo "<a href=index.php?action=enter_management_mode><img src=images/rfid_management.png height=120px class='menu'>Enter management mode</a><br>";
}
echo "<a href=index.php?page=media_sequence><img src=images/media_sequence.png height=120px class='menu'>Enter the Media sequence page</a><br>";
echo "</div>";
?>
