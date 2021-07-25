<?php
include ('db-ro-connect.php');

$cctvlistquery = sprintf("SELECT * FROM CCTV_CAPTURES  ORDER BY FILENAME DESC");
$cctvlistresult = $conn->query($cctvlistquery);



echo "<center><table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse; width: 60%; margin: 1.5em; font-family: Arial, Helvetica, sans-serif; font-size: 0.85em;'><tbody>
	<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
		<td>File Name</td>
		<td>Trigerring event</td>
		<td>Action</td>
	</tr>";
while($row = $cctvlistresult->fetch_assoc()) {
	echo "<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
			<td><b><h2><a href=cctv_captures/".$row['FILENAME'].">".$row['FILENAME']."</a></h2></b></td>
			<td><b>".$row['TRIGGERING_EVENT']."</b></td>
			<td><a href='index.php?page=media_sequence&action=delete&media_filename=".$row['FILENAME']."'><img src='images/delete.png' height='40px'></a></td>
		</tr>";
}
echo "</table></center>";


?>
