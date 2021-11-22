<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
$test_arduino_connected = shell_exec("if [ ! -z $(ls /dev/ttyARDUINO) ]; then echo 'arduino_connected'; fi");


// echo $test_arduino_connected;
if (strpos($test_arduino_connected, 'arduino_connected') !== false) {
	echo "The arduino is connected and linked to the central correctly.<br><br>
				<img src=images/arduino_is_connected.png height=300px align=center>
				<center><table border='0' cellpadding='10' cellspacing='0' style='border-collapse: collapse; width: 30%; margin: 1.5em; font-family: Arial, Helvetica, sans-serif; font-size: 0.85em;'><tbody>
					<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
						<td colspan=2>Arduino extension type</td>
						<td>Current value</td>
						</tr>";
				$req_arduino_enabled_modules = sprintf("SELECT arduino_smoke_detector,arduino_temperature_sensor,arduino_humidity_sensor,arduino_carbon_monoxide_sensor FROM SETTINGS");
				$arduino_enabled_modules = $conn->query($req_arduino_enabled_modules);
				while($row = $arduino_enabled_modules->fetch_assoc()) {
					$arduino_smoke_detector=$row['arduino_smoke_detector'];
					$arduino_temperature_sensor=$row['arduino_temperature_sensor'];
					$arduino_humidity_sensor=$row['arduino_humidity_sensor'];
					$arduino_carbon_monoxide_sensor=$row['arduino_carbon_monoxide_sensor'];
				}
					if ($arduino_smoke_detector == 1 )
					{
						$get_smoke_detector_value = shell_exec("cat ../arduino_capture.txt | grep 'MQ2_Value:' | awk -F ':' '{ print $2 }' | awk -F '.' '{ print $1 }' | tail -n 1");
						echo "	<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
											<td><img src=images/smoke.png height=40px></td>
											<td>Arduino Smoke Detector</td>
											<td>".$get_smoke_detector_value." PPM</td>
										</tr>";
					}
					if ($arduino_temperature_sensor == 1 )
					{
						$get_temperature_detector_value = shell_exec("cat ../arduino_capture.txt | grep 'DHT11_Temperature:' | awk -F ':' '{ print $2 }' | awk -F '.' '{ print $1 }' | tail -n 1");
						echo "	<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
											<td><img src=images/temperature.png height=40px></td>
											<td>Arduino Temperature Detector</td>
											<td>".$get_temperature_detector_value."°C</td>
										</tr>";
					}
					if ($arduino_humidity_sensor == 1 )
					{
						$get_humidity_detector_value = shell_exec("cat ../arduino_capture.txt | grep 'DHT11_Humidity:' | awk -F ':' '{ print $2 }' | awk -F '.' '{ print $1 }' | tail -n 1");
						echo "	<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
											<td><img src=images/humidity.png height=40px></td>
											<td>Arduino Humidity Detector</td>
											<td>".$get_humidity_detector_value."%</td>
										</tr>";
					}
					if ($arduino_carbon_monoxide_sensor == 1 )
					{
						$get_carbon_monoxide_value = shell_exec("cat ../arduino_capture.txt | grep 'MQ7_Value:' | awk -F ':' '{ print $2 }' | awk -F '.' '{ print $1 }' | tail -n 1");
						echo "	<tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
											<td><img src=images/carbon_monoxide.png height=40px></td>
											<td>Arduino Carbon Monoxide</td>
											<td>".$get_carbon_monoxide_value." PPM</td>
										</tr>";
					}
		echo "</table>";
	}else{
			echo "The arduino is not detected by the central.<br><br>
				  	<img src=images/arduino_is_not_connected.png height=300px align=center>";
	}
?>
