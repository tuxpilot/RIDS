<?php
$dbname = exec('grep dbname ../creds.dat | awk -F \' \' \'{ print $2 }\'');
$ropswd = exec('grep rwpswd ../creds.dat | awk -F \' \' \'{ print $2 }\'');


$conn = new mysqli('127.0.0.1', 'alarm_read_only', $ropswd, $dbname);
	if ($conn->connect_error) {
	  die("Connection failed: " . $conn->connect_error);
	}

?>
