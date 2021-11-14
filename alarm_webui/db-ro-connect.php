<?php
$conn = new mysqli('127.0.0.1', 'alarm_read_only', 'password', 'crids');
	if ($conn->connect_error) {
	  die("Connection failed: " . $conn->connect_error);
	} 
?>