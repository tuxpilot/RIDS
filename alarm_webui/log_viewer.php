<?php



include ('db-ro-connect.php');

$logquery = sprintf("SELECT * FROM EVENT_LOG ORDER BY LOG_TIMESTAMP DESC");
$logresult = $conn->query($logquery);
echo "<center><table border='0' cellpadding='10' cellspacing='0' style='border-collapse: collapse; width: 80%; margin: 1.5em; font-family: Arial, Helvetica, sans-serif; font-size: 0.85em;'><tbody>";
if (!$logresult) {
    $message  = 'Requête invalide : ' . mysql_error() . "\n";
    $message .= 'Requête complète : ' . $logquery;
    die($message);
}


while($row = $logresult->fetch_assoc()) {
    echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
			<td>".$row['LOG_TIMESTAMP']."</td><td><img src=images/".$row['EVENT_LOG_ILLUSTRATION']." class='log_image'></td><td>".$row['LOG_CONTENT']."</td>
		  </tr>";
}


echo "</table></center>";
?>
