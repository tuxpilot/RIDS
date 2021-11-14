<?php
if(isset($_GET['action']))
{
	$rfid_number = $_GET['rfid_number'];
	$action = $_GET['action'];
	if($action == "delete" && $alarm_status == 5)
	{
		$delete_action = shell_exec("sed -i '/^".$rfid_number."/d' ../access_db/rfid_cards_sorted.txt");	
	}
}

if($alarm_status != 5)
{
	echo "<span style=color:red>Warning the alarm is not in management mode, no modification can be made<span>.<br>";
}else{
	$fn = fopen("../access_db/rfid_cards_sorted.txt","r");
	echo "<center><table class=rfid_management>";
	echo "<tr><td>RFID number</td><td>User attribution</td><td>Action</td></tr>";
	while(! feof($fn))  {
	$full_rfid_line = fgets($fn);
	  $splitted_rfid_line = explode("@", $full_rfid_line);
	  if($splitted_rfid_line[0] != "")
	  {
		  
		  if (strpos($splitted_rfid_line[1], 'TO_CUSTOMIZE') !== false)
		  {
			  echo "<tr><td>".$splitted_rfid_line[0]."</td><td>";
			  echo "<form action=edit_rfid_attribution.php><input id=customize_rfid_name value=".$splitted_rfid_line[1]."></input></form></td><td><a href=index.php?page=rfid_management&action=delete&rfid_number=".$splitted_rfid_line[0]."><img src=images/delete.png height=40px></a>";
			  echo "&emsp;<a href=index.php?page=rfid_management&action=edit&rfid_number=".$splitted_rfid_line[0]."><input type='image' src='images/edit.png' height=40px name='clicImage'/></a>";
		  }else{
			  echo "<tr><td>".$splitted_rfid_line[0]."</td><td>";
			  echo $splitted_rfid_line[1]."</td><td><a href=index.php?page=rfid_management&action=delete&rfid_number=".$splitted_rfid_line[0]."><img src=images/delete.png height=40px></a>";
		  }
		  echo "</td></tr>";
	  }
	}
	echo "<table>";
	fclose($fn);
	echo "</center>";
}
?>
