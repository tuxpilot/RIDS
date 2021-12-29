<?php




if($alarm_status != 5)
{
	echo "<span style=color:red>Warning the alarm is not in management mode, no modification can be made<span>.<br>";
}else{




	if(isset($_GET['action']))
	{
		$action = $_GET['action'];
		if($action == "update_rfid_new_infos" && $alarm_status == 5)
		{
			$attribution_first_name = $_GET['attribution_first_name'];
			$attribution_last_name = $_GET['attribution_last_name'];
			$rfid_card_flag = $_GET['rfid_card_flag'];
			$ID = $_GET['ID'];
			include ('db-rw-connect.php');
			echo "attribution_first_name :".$attribution_first_name."<br>";
			echo "attribution_last_name :".$attribution_last_name."<br>";
			echo "rfid_card_flag :".$rfid_card_flag."<br>";
			echo "ID :".$ID."<br>";
			if($attribution_first_name != "")
			{
				$actionrequest = sprintf("UPDATE RFID SET attribution_first_name = '".$attribution_first_name."' WHERE ID = '".$ID."'");
				$actionresult = $conn->query($actionrequest);
			}
			if($attribution_last_name != "")
			{
				$actionrequest = sprintf("UPDATE RFID SET attribution_last_name = '".$attribution_last_name."' WHERE ID = '".$ID."'");
				$actionresult = $conn->query($actionrequest);
			}
			if($rfid_card_flag != "")
			{
				$actionrequest = sprintf("UPDATE RFID SET rfid_card_flag = '".$rfid_card_flag."' WHERE ID = '".$ID."'");
				$actionresult = $conn->query($actionrequest);
			}
			$conn->close();
		}

		if($action == "delete" && $alarm_status == 5)
		{
			$rfid_card_ID = $_GET['rfid_card_ID'];
			include ('db-rw-connect.php');
			$actionrequest = sprintf("DELETE FROM RFID WHERE rfid_card_ID = '".$rfid_card_ID."'");
			$actionresult = $conn->query($actionrequest);
			$conn->close();
		}

		if($action == "setting_to_change" && $alarm_status == 5)
		{
			$ID = $_GET['ID'];
			$rfidlistquery = sprintf("SELECT * FROM RFID  WHERE ID ='".$ID."'");
			$rfidlistresult = $conn->query($rfidlistquery);
			while($row = $rfidlistresult->fetch_assoc()) {
				$attribution_first_name = $row['attribution_first_name'];
				$attribution_last_name = $row['attribution_last_name'];
				$rfid_card_flag = $row['rfid_card_flag'];
			}
?>

			<form action="index.php">
			  <label for="attribution_first_name"><b>Attribution First Name</b></label>
				<input type="text" placeholder=<?php echo $attribution_first_name; ?> name="attribution_first_name"><br>
			  <label for="attribution_last_name"><b>Attribution Last Name</b></label>
				<input type="text" placeholder=<?php echo $attribution_last_name; ?> name="attribution_last_name"><br>
			  <label for="rfid_card_flag"><b>RFID Card Flag</b></label>
				<select name="rfid_card_flag" id="rfid_card_flag">
					<option value="inactive">inactive</option>
					<option value="active">active</option>
					<option value="" selected></option>
				</select>
				<input id="page" name="page" type="hidden" value="rfid_management">
				<input id="ID" name="ID" type="hidden" value=<?php echo $ID; ?>>
				<input id="action" name="action" type="hidden" value="update_rfid_new_infos"><br>
			  <button type="submit" class="btn">Change now!</button>
			</form>
			<br><br>
<?php
		}
		if($action == "write_new_setting" && $alarm_status == 5)
		{
			$attribution_first_name = $_GET['attribution_first_name'];
			$attribution_last_name = $_GET['attribution_last_name'];
			$rfid_card_flag = $_GET['rfid_card_flag'];
			$ID = $_GET['ID'];
			include ('db-rw-connect.php');
			$actionrequest = sprintf("UPDATE SETTINGS SET ".$ParName." = '".$ParValue."'");
			$actionresult = $conn->query($actionrequest);
			$conn->close();
		}

	}







	include ('db-ro-connect.php');
	$rfidlistquery = sprintf("SELECT * FROM RFID  ORDER BY rfid_card_ID DESC");
	$rfidlistresult = $conn->query($rfidlistquery);
	echo "<center><table border='0' cellpadding='10' cellspacing='0' style='border-collapse: collapse; width: 30%; margin: 1.5em; font-family: Arial, Helvetica, sans-serif; font-size: 0.85em;'><tbody>
	<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
		<td>Hashed RFID Card ID</td>
		<td>FIRST NAME</td>
		<td>LAST NAME</td>
		<td>RFID STATUS</td>
	</tr>";
	while($row = $rfidlistresult->fetch_assoc()) {
		echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
				<td>".$row['rfid_card_ID']."</td>
				<td>".$row['attribution_first_name']."</td>
				<td>".$row['attribution_last_name']."</td>
				<td>".$row['rfid_card_flag']."</td>
				<td><a href='index.php?page=rfid_management&action=setting_to_change&ID=".$row['ID']."'><img src='images/setting_changing.png' height='40px'></a></td>
				<td><a href='index.php?page=rfid_management&action=delete&rfid_card_ID=".$row['rfid_card_ID']."'><img src='images/delete.png' height='40px'></a></td>
			</tr>";
	}

	echo "</table></center>";
}

?>
