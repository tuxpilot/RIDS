<?php
session_start();

if(isset($_GET['API']))
{
	$API_NUMBER = $_GET['API'];
	include ('db-ro-connect.php');

	$actionrequest = sprintf("SELECT * FROM API");
	$actionresult = $conn->query($actionrequest);
	while($row = $actionresult->fetch_assoc()) {
		if ( $API_NUMBER == $row['API_NUMBER'] && $row['ENABLE'] == 1 )
		{
			$trackingrequest = sprintf("SELECT * FROM ALARM_TRACKING");
			$trackingresult = $conn->query($trackingrequest);
			while($rowt = $trackingresult->fetch_assoc()) {
				echo $rowt['CURRENT_STATUS'];
			}
			$conn->close();
		}else{
			echo "Invalid API Number or Disabled API!";
		}
	}
}

?>
