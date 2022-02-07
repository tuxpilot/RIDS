<?php
$test_path = shell_exec('echo $PWD');
if (strpos($test_path, 'alarm_webui') !== false) {
	$dbname = exec('grep dbname ../creds.dat | awk -F \' \' \'{ print $2 }\'');
	$ropswd = exec('grep ropswd ../creds.dat | awk -F \' \' \'{ print $2 }\'');
}else{
	$dbname = exec('grep dbname creds.dat | awk -F \' \' \'{ print $2 }\'');
	$ropswd = exec('grep ropswd creds.dat | awk -F \' \' \'{ print $2 }\'');
}



$conn = new mysqli('127.0.0.1', 'alarm_read_only', $ropswd, $dbname);
	if ($conn->connect_error) {
	  die("Connection failed: " . $conn->connect_error);
	}
?>
