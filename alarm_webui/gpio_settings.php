<?php




if($alarm_status != 5)
{
	echo "<span style=color:red>Warning the alarm is not in management mode, no modification can be made<span>.<br>";
}else{
	



	if(isset($_GET['action']))
	{
		$action = $_GET['action'];
		if($action == "delete" && $alarm_status == 5)
		{
			include ('db-rw-connect.php');
			$actionrequest = sprintf("SELECT * FROM GPIO");
			$actionresult = $conn->query($actionrequest);
		}
	}
	
	
	include ('db-ro-connect.php');
	
	$settingsquery = sprintf("SELECT * FROM GPIO");
	$settingsresult = $conn->query($settingsquery);
	


	echo "<center><table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse; width: 80%; margin: 1.5em; font-family: Arial, Helvetica, sans-serif; font-size: 0.85em;'><tbody>";
	echo "<tr>
				<td>Access point name</td>
				<td>Access point GPIO Number</td>
				<td>GPIO value when access point is closed</td>
				<td>Temporised access point?</td>
		</tr>";
	while($row = $settingsresult->fetch_assoc()) {
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
				<td>".$row['monitoring_gpio_name']."</td>
				<td>".$row['monitoring_gpio_number']."</td>
				<td>".$row['monitoring_gpio_value_access_closed']."</td>
				<td>".$row['tempo_trigger_alarm']."</td>
			</tr>";
	}
	echo "</table></center>";
}
?>