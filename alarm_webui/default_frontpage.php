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
		}
	}
}



echo "<center><table>";
echo "<table border=0 align=center><tr>";
if($alarm_status == 5)
{
	echo "<td><img src=images/alarm_management.png height=120px></td><td><img src=images/alarm_state_0_greyed.png height=120px></td><td><img src=images/alarm_state_1_greyed.png height=120px></td><td><img src=images/alarm_state_2_greyed.png height=120px></td><td><img src=images/alarm_state_3_greyed.png height=120px></td><td><img src=images/alarm_state_4_greyed.png height=120px></td>";
}
if($alarm_status == 0)
{
	echo "<td><img src=images/alarm_management_greyed.png height=120px></td><td><img src=images/alarm_state_0.png height=120px></td><td><img src=images/alarm_state_1_greyed.png height=120px></td><td><img src=images/alarm_state_2_greyed.png height=120px></td><td><img src=images/alarm_state_3_greyed.png height=120px></td><td><img src=images/alarm_state_4_greyed.png height=120px></td>";
}
if($alarm_status == 1)
{
	echo "<td><img src=images/alarm_management_greyed.png height=120px></td><td><img src=images/alarm_state_0_greyed.png height=120px'></td><td><img src=images/alarm_state_1.png height=120px></td><td><img src=images/alarm_state_2_greyed.png height=120px></td><td><img src=images/alarm_state_3_greyed.png height=120px></td><td><img src=images/alarm_state_4_greyed.png height=120px></td>";
}
if($alarm_status == 2)
{
	echo "<td><img src=images/alarm_management_greyed.png height=120px></td><td><img src=images/alarm_state_0_greyed.png height=120px></td><td><img src=images/alarm_state_1_greyed.png height=120px></td><td><img src=images/alarm_state_2.png height=120px></td><td><img src=images/alarm_state_3_greyed.png height=120px></td><td><img src=images/alarm_state_4_greyed.png height=120px></td>";
}
if($alarm_status == 3)
{
	echo "<td><img src=images/alarm_management_greyed.png height=120px></td><td><img src=images/alarm_state_0_greyed.png height=120px></td><td><img src=images/alarm_state_1_greyed.png height=120px></td><td><img src=images/alarm_state_2_greyed.png height=120px></td><td><img src=images/alarm_state_3.png height=120px></td><td><img src=images/alarm_state_4_greyed.png height=120px></td>";
}
if($alarm_status == 4)
{
	echo "<td><img src=images/alarm_management_greyed.png height=120px></td><td><img src=images/alarm_state_0_greyed.png height=120px></td><td><img src=images/alarm_state_1_greyed.png height=120px></td><td><img src=images/alarm_state_2_greyed.png height=120px></td><td><img src=images/alarm_state_3.png height=120px></td><td><img src=images/alarm_state_4.png height=120px></td>";
}
echo "</tr></table>";
echo "<br><hr>";

echo "<div id=menu_lower>";
echo "<a href=index.php?page=log_viewer><img src=images/alarm_event_log.png height=120px class='menu'>Check the event logs</a><br>";
echo "<a href=index.php?page=access_point_monitoring><img src=images/access_point_monitoring.png height=120px class='menu'>Monitor the Access points state</a><br>";
echo "<a href=index.php?action=webui_alarm_arming><img src=images/alarm_web_arming.png height=120px class='menu'>Manually arm the alarm from the WebUI</a><br>";
if($alarm_status == 5)
{
	echo "<a href=index.php?page=rfid_management><img src=images/rfid_management.png height=120px class='menu'>Add/Remove/Manage RFID cards</a><br>";
	echo "<a href=index.php?page=settings_management><img src=images/global_settings.png height=120px class='menu'>Edit the Global Settings</a><br>";
	echo "<a href=index.php?page=gpio_settings><img src=images/gpio_settings.png height=120px class='menu'>GPIO management</a><br>";
	echo "<a href=index.php?action=leave_management_mode><img src=images/alarm_management_leave.png height=120px class='menu'>Leave management mode</a><br>";
}else{
	echo "<a href=index.php?action=enter_management_mode><img src=images/rfid_management.png height=120px class='menu'>Enter management mode</a><br>";
}
echo "<a href=index.php?page=media_sequence><img src=images/media_sequence.png height=120px class='menu'>Enter the Media sequence page</a><br>";
echo "</div>";

?>