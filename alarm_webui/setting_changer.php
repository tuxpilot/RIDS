<?php




if($alarm_status != 5)
{
	echo "<span style=color:red>Warning the alarm is not in management mode, no modification can be made<span>.<br>";
}else{

  if(isset($_GET['settingtochange']))
  {
    $settingtochange = $_GET['settingtochange'];
  }

	if(isset($_GET['action']))
	{
		$action = $_GET['action'];
		if($action == "modify_setting" && $alarm_status == 5)
		{
			include ('db-rw-connect.php');
			$actionrequest = sprintf("SELECT * FROM SETTINGS");
			$actionresult = $conn->query($actionrequest);
		}
	}


$resource = $conn->query("SELECT  ".$settingtochange." FROM SETTINGS");
while ( $rows = $resource->fetch_assoc() ) {
  foreach($rows as $x=>$x_value)
    {
      $PN=$x;
      $PV=$x_value;
    }
}
?>

<form action="/setting_changer.php?action=modify_setting">
  <label for="PN"><b><?php echo $PN; ?></b></label>
  <input type="text" placeholder=<?php echo $PV; ?> name="PV" required>
  <button type="submit" class="btn">Change now!</button>
</form>
<?php
}
 ?>
