<?php




if($alarm_status != 5)
{
	echo "<span style=color:red>Warning the alarm is not in management mode, no modification can be made<span>.<br>";
}else{




	if(isset($_GET['action']))
	{
		$action = $_GET['action'];
		if($action == "update_gpio_new_infos" && $alarm_status == 5)
		{
			$monitoring_gpio_number = $_GET['monitoring_gpio_number'];
			$monitoring_gpio_value_access_closed = $_GET['monitoring_gpio_value_access_closed'];
			$monitoring_gpio_name = $_GET['monitoring_gpio_name'];
			$tempo_trigger_alarm = $_GET['tempo_trigger_alarm'];
			$mandatory_closed_access_on_arming = $_GET['mandatory_closed_access_on_arming'];


			$ID = $_GET['ID'];
			include ('db-rw-connect.php');
			echo "monitoring_gpio_value_access_closed :".$monitoring_gpio_value_access_closed."<br>";
			echo "monitoring_gpio_name :".$monitoring_gpio_name."<br>";
			echo "tempo_trigger_alarm :".$tempo_trigger_alarm."<br>";
			echo "mandatory_closed_access_on_arming :".$mandatory_closed_access_on_arming."<br>";
			echo "ID :".$ID."<br>";
			if($monitoring_gpio_number != "")
			{
				$actionrequest = sprintf("UPDATE GPIO SET monitoring_gpio_number  = '".$monitoring_gpio_number ."' WHERE ID = '".$ID."'");
				$actionresult = $conn->query($actionrequest);
			}
			if($monitoring_gpio_value_access_closed != "")
			{
				$actionrequest = sprintf("UPDATE GPIO SET monitoring_gpio_value_access_closed  = '".$monitoring_gpio_value_access_closed ."' WHERE ID = '".$ID."'");
				$actionresult = $conn->query($actionrequest);
			}
			if($monitoring_gpio_name != "")
			{
				$actionrequest = sprintf("UPDATE GPIO SET monitoring_gpio_name  = '".$monitoring_gpio_name ."' WHERE ID = '".$ID."'");
				$actionresult = $conn->query($actionrequest);
			}
			if($tempo_trigger_alarm != "")
			{
				$actionrequest = sprintf("UPDATE GPIO SET tempo_trigger_alarm  = '".$tempo_trigger_alarm ."' WHERE ID = '".$ID."'");
				$actionresult = $conn->query($actionrequest);
			}
			if($mandatory_closed_access_on_arming != "")
			{
				$actionrequest = sprintf("UPDATE GPIO SET mandatory_closed_access_on_arming  = '".$mandatory_closed_access_on_arming ."' WHERE ID = '".$ID."'");
				$actionresult = $conn->query($actionrequest);
			}
			$conn->close();
		}


		if($action == "add_new_gpio_infos" && $alarm_status == 5)
		{
			$monitoring_gpio_number = $_GET['monitoring_gpio_number'];
			$monitoring_gpio_value_access_closed = $_GET['monitoring_gpio_value_access_closed'];
			$monitoring_gpio_name = $_GET['monitoring_gpio_name'];
			$tempo_trigger_alarm = $_GET['tempo_trigger_alarm'];
			$mandatory_closed_access_on_arming = $_GET['mandatory_closed_access_on_arming'];


			include ('db-rw-connect.php');
			echo "monitoring_gpio_value_access_closed :".$monitoring_gpio_value_access_closed."<br>";
			echo "monitoring_gpio_name :".$monitoring_gpio_name."<br>";
			echo "tempo_trigger_alarm :".$tempo_trigger_alarm."<br>";
			echo "mandatory_closed_access_on_arming :".$mandatory_closed_access_on_arming."<br>";
			if($monitoring_gpio_number != "" && $monitoring_gpio_value_access_closed != '' && $monitoring_gpio_name != '' && $monitoring_gpio_name != '' && $tempo_trigger_alarm != '' && $mandatory_closed_access_on_arming != '')
			{
				$actionrequest  = sprintf("INSERT INTO `GPIO` (`ID`, `monitoring_gpio_number`, `monitoring_gpio_value_access_closed`, `monitoring_gpio_name`, `monitoring_gpio_current_state`, `tempo_trigger_alarm`, `gpio_open_flag`, `mandatory_closed_access_on_arming`)
				VALUES (NULL, '$monitoring_gpio_number', '$monitoring_gpio_value_access_closed', '$monitoring_gpio_name', '0', '$tempo_trigger_alarm', '0', '$mandatory_closed_access_on_arming')");
				$actionresult = $conn->query($actionrequest);
			}else{
				echo "<span style=color:red>Warning one or more fields are empty. We can't create a new GPIO without these datas.<span>.<br>";
			}
			$conn->close();
		}

		if($action == "delete" && $alarm_status == 5)
		{
			$ID = $_GET['ID'];
			include ('db-rw-connect.php');
			$actionrequest = sprintf("DELETE FROM GPIO WHERE ID = '".$ID."'");
			$actionresult = $conn->query($actionrequest);
			$conn->close();
		}

		if($action == "setting_to_change" && $alarm_status == 5)
		{
			$ID = $_GET['ID'];
			$rfidlistquery = sprintf("SELECT * FROM GPIO WHERE ID ='".$ID."'");
			$rfidlistresult = $conn->query($rfidlistquery);
			while($row = $rfidlistresult->fetch_assoc()) {
				$monitoring_gpio_number = $row['monitoring_gpio_number'];
				$monitoring_gpio_value_access_closed = $row['monitoring_gpio_value_access_closed'];
				$monitoring_gpio_name = $row['monitoring_gpio_name'];
				$tempo_trigger_alarm = $row['tempo_trigger_alarm'];
				$mandatory_closed_access_on_arming = $row['mandatory_closed_access_on_arming'];

			}
	?>

			<form action="index.php">
				<table border=0 align=center>
					<tr>
						<td><label for="monitoring_gpio_number"><b>GPIO NUMBER</b></label></td>
						<td><input type="text" placeholder=<?php echo $monitoring_gpio_number; ?> name="monitoring_gpio_number" required="required"></td>
					</tr>
					<tr>
						<td><label for="monitoring_gpio_value_access_closed"><b>GPIO Value when closed</b></label></td>
						<td><select name="monitoring_gpio_value_access_closed" id="monitoring_gpio_value_access_closed" required="required">
									<option value="1">1</option>
									<option value="0">0</option>
									<option value="" selected></option>
								</select>
						</td>
				</tr>
				<tr>
					<td><label for="monitoring_gpio_name"><b>ACCESS NAME</b></label></td>
					<td><input type="text" placeholder=<?php echo $monitoring_gpio_name; ?> name="monitoring_gpio_name"></td>
				</tr>
				<tr>
					<td><label for="tempo_trigger_alarm"><b>Temporised triggered alarm?</b></label></td>
					<td><select name="tempo_trigger_alarm" id="tempo_trigger_alarm" required="required">
								<option value="1">1</option>
								<option value="0">0</option>
								<option value="" selected></option>
							</select>
					</td>
				</tr>
				<tr>
					<td><label for="mandatory_closed_access_on_arming"><b>Mandatory closed acces on arming?</b></label></td>
					<td><select name="mandatory_closed_access_on_arming" id="mandatory_closed_access_on_arming" required="required">
								<option value="1">1</option>
								<option value="0">0</option>
								<option value="" selected></option>
							</select>
					</td>
				</tr>
				<input id="page" name="page" type="hidden" value="gpio_settings">
				<input id="ID" name="ID" type="hidden" value=<?php echo $ID; ?>>
				<input id="action" name="action" type="hidden" value="update_gpio_new_infos"><br>
				<tr><td colspan=2 align=center><button type="submit" class="btn">Change now!</button></td></tr>
			</table>
			</form>
			<br><br>
	<?php
		}

		if($action == "add_gpio" && $alarm_status == 5)
		{
	?>
			<form action="index.php">
				<table border=0 align=center>
					<tr>
						<td><label for="monitoring_gpio_number"><b>GPIO NUMBER</b></label></td>
						<td><input type="text" placeholder='' name="monitoring_gpio_number" required="required"></td>
					</tr>
					<tr>
						<td><label for="monitoring_gpio_value_access_closed"><b>GPIO Value when closed</b></label></td>
						<td><select name="monitoring_gpio_value_access_closed" id="monitoring_gpio_value_access_closed" required="required">
									<option value="1">1</option>
									<option value="0">0</option>
									<option value="" selected></option>
								</select>
						</td>
				</tr>
				<tr>
					<td><label for="monitoring_gpio_name"><b>ACCESS NAME</b></label></td>
					<td><input type="text" placeholder='' name="monitoring_gpio_name"></td>
				</tr>
				<tr>
					<td><label for="tempo_trigger_alarm"><b>Temporised triggered alarm?</b></label></td>
					<td><select name="tempo_trigger_alarm" id="tempo_trigger_alarm" required="required">
								<option value="1">1</option>
								<option value="0">0</option>
								<option value="" selected></option>
							</select>
					</td>
				</tr>
				<tr>
					<td><label for="mandatory_closed_access_on_arming"><b>Mandatory closed acces on arming?</b></label></td>
					<td><select name="mandatory_closed_access_on_arming" id="mandatory_closed_access_on_arming" required="required">
								<option value="1">1</option>
								<option value="0">0</option>
								<option value="" selected></option>
							</select>
					</td>
				</tr>
			 	<input id="page" name="page" type="hidden" value="gpio_settings">
				<input id="action" name="action" type="hidden" value="add_new_gpio_infos"><br>
				<tr><td colspan=2 align=center><button type="submit" class="btn">Add now!</button></td></tr>
			</table>
			</form>
			<br><br>
	<?php
		}
	}




	include ('db-ro-connect.php');

	$settingsquery = sprintf("SELECT * FROM GPIO");
	$settingsresult = $conn->query($settingsquery);
	$conn->close();



	echo "<center><table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse; width: 60%; margin: 1.5em; font-family: Arial, Helvetica, sans-serif; font-size: 0.85em;'><tbody>";
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
						<td><a href='index.php?page=gpio_settings&action=setting_to_change&ID=".$row['ID']."'><img src='images/setting_changing.png' height='40px'></a></td>
						<td><a href='index.php?page=gpio_settings&action=delete&ID=".$row['ID']."'><img src='images/delete.png' height='40px'></a></td>
					</tr>";
	}
	echo "</table>
	<a href='index.php?page=gpio_settings&action=add_gpio'>ADD New GPIO <img src='images/add.png' height='40px'></a>
	</center>";
}
?>
