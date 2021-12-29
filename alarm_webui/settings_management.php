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
			$actionrequest = sprintf("UPDATE SETTINGS SET central_mode_override = '9'");
			$actionresult = $conn->query($actionrequest);
			$conn->close();
		}

		if($action == "setting_to_change" && $alarm_status == 5)
		{
			include ('db-rw-connect.php');
			$setting_to_change = $_GET['setting_to_change'];
			$resource = $conn->query("SELECT  ".$setting_to_change." FROM SETTINGS");
			while ( $rows = $resource->fetch_assoc() ) {
			  foreach($rows as $x=>$x_value)
			    {
			      $ParName=$x;
			      $ParValue=$x_value;
			    }
			}
?>

			<form action="index.php">
			  <label for="ParName"><b><?php echo $ParName; ?></b></label>
			  <input type="text" placeholder=<?php echo $ParValue; ?> name="ParValue" required>
				<input id="ParName" name="ParName" type="hidden" value=<?php echo $ParName; ?>>
				<input id="page" name="page" type="hidden" value="settings_management">
				<input id="action" name="action" type="hidden" value="write_new_setting">
			  <button type="submit" class="btn">Change now!</button>
			</form>

<?php
		}
		if($action == "write_new_setting" && $alarm_status == 5)
		{
			$ParName = $_GET['ParName'];
			$ParValue = $_GET['ParValue'];
			include ('db-rw-connect.php');
			$actionrequest = sprintf("UPDATE SETTINGS SET ".$ParName." = '".$ParValue."'");
			$actionresult = $conn->query($actionrequest);
			$conn->close();
		}

	}








	include ('db-ro-connect.php');
	$resource = $conn->query('SELECT * FROM SETTINGS');
	echo "<center><table border='0' cellpadding='10' cellspacing='0' style='border-collapse: collapse; width: 30%; margin: 1.5em; font-family: Arial, Helvetica, sans-serif; font-size: 0.85em;'><tbody>";
	while ( $rows = $resource->fetch_assoc() ) {
	  foreach($rows as $x=>$x_value)
	    {
	      echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>".$x."</td><td>".$x_value."</td><td><a href='index.php?page=settings_management&action=setting_to_change&setting_to_change=".$x."'><image src='images/setting_changing.png' height='30px'></a></td></tr>";
	    }
	  }
	echo "</table></center>";
	echo "<a href='index.php?page=settings_management&action=reload_settings'><button>Reload the settings</button></a>";
	$conn->close();
}

?>
