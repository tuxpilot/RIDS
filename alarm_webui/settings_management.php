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






	$resource = $conn->query('SELECT * FROM SETTINGS');
	echo "<center><table border='0' cellpadding='10' cellspacing='0' style='border-collapse: collapse; width: 30%; margin: 1.5em; font-family: Arial, Helvetica, sans-serif; font-size: 0.85em;'><tbody>";
	while ( $rows = $resource->fetch_assoc() ) {
	  foreach($rows as $x=>$x_value)
	    {
	      echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'><td>".$x."</td><td>".$x_value."</td><td><a href='index.php?page=setting_changer&settingtochange=".$x."'><image src='images/setting_changing.png' height='30px'></a></td></tr>";
	    }
	  }
	echo "</table></center>";
	echo "<a href='index.php?page=settings_management&action=reload_settings'><button>Reload the settings</button></a>";
}

?>
