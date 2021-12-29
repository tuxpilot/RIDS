<?php
session_start();
// $language = shell_exec("cat ../settings.txt | grep language | awk -F '=' '{ print $2 }' | tr -d ' '");
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
if(isset($_GET['page']))
{
	$page = $_GET['page'];
}
?>
<html>
	<head>
		<title>RIDS</title>
		<link rel="stylesheet" type="text/css" href="index.css">
		<link rel="icon" type="image/png" href="images/favicon.png" />
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	</head>
	<body bgcolor="#181a1b">
		<div id="container">
			<div id="header"><br>
				<div id=logo>
					&emsp;
					<a href='index.php'>
						<img src='images/logo_banner.png' height='70px'>
					</a>
				</div>
			</div>
			<div id="leftstructure">
				<br><br>
				<?php
					if(isset($_GET['page']))
					{
						$page = $_GET['page'];
						echo "<a href=index.php?page=".$page."><img src='images/refresh.png' height='40px'>Refresh the page</a>";
					}else{
						echo "<a href=index.php><img src='images/refresh.png' height='40px'>Refresh the page</a>";
					}
				?>
				<br><br>
				<a href=index.php><img src='images/logo.png' height='40px'>Return to the menu</a>
			</div>
			<div id="rightstructure">
				&nbsp;
			</div>
			<div id="middlestructure">
				<?php
				include ('db-ro-connect.php');
				$status_query = sprintf("SELECT CURRENT_STATUS FROM ALARM_TRACKING ");
				$alarm_status_res = $conn->query($status_query);
				$conn->close();
				while($row = $alarm_status_res->fetch_assoc()) {
				   $alarm_status=$row['CURRENT_STATUS'];
				}

				$cctv_captures_path = "/home/pi/alarm/cctv_captures";
				if(isset($_GET['page']))
				{
					include ($page.".php");
				}else{
					include ("default_frontpage.php");
				}

				?>
				<center>
				</center>
			</div>
		</div>
	</body>
</html>
