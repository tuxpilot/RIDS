<?php





if($alarm_status == 5)
{
	echo "<span style=color:red>Warning the alarm is not in management mode, tracking is disabled! Exit management mode first, or you won't see any effective tracking of your access points.<span>.<br>";
}else{
	if(isset($_GET['auto_refresh']))
	{
		$auto_refresh = $_GET['auto_refresh'];
		{
			echo "<meta http-equiv='refresh' content=".$auto_refresh."; url=index.php?auto_refresh=".$auto_refresh.">";
		}
	}


	include ('db-ro-connect.php');

	$gpioquery = sprintf("SELECT * FROM GPIO");
	$gpioresult = $conn->query($gpioquery);



	echo "<center><table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse; width: 80%; margin: 1.5em; font-family: Arial, Helvetica, sans-serif; font-size: 0.85em;'><tbody>";
	echo "<tr>
				<td>Access point name</td>
				<td>Access point GPIO Number</td>
				<td>Access point actual state</td>
				<td>Access point GPIO actual value</td>
		</tr>";
	while($row = $gpioresult->fetch_assoc()) {
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
				<td>".$row['monitoring_gpio_name']."</td>
				<td>".$row['monitoring_gpio_number']."</td>";
				if($row['monitoring_gpio_current_state'] == $row['monitoring_gpio_value_access_closed'])
				{
					echo "<td><img src=images/door_closed.png class='log_image'></td>";
				}else{
					echo "<td><img src=images/door_open.png class='log_image'></td>";
				}
				echo "<td>".$row['monitoring_gpio_current_state']."</td>";
			echo "</tr>";
	}
	echo "</table></center>";
}
?>