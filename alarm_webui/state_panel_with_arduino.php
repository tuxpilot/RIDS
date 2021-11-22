<?php

echo "<center><table>";
echo "<table border=0 align=center><tr>";
if($alarm_status == 5)
{
	echo "<td><img src=images/alarm_management.png height=120px></td><td><img src=images/alarm_state_0_greyed.png height=120px></td><td><img src=images/alarm_state_1_greyed.png height=120px></td><td><img src=images/alarm_state_2_greyed.png height=120px></td><td><img src=images/alarm_state_3_greyed.png height=120px></td><td><img src=images/alarm_state_4_greyed.png height=120px></td><td><img src=images/arduino_activated.png height=120px></td>";
}
if($alarm_status == 0)
{
	echo "<td><img src=images/alarm_management_greyed.png height=120px></td><td><img src=images/alarm_state_0.png height=120px></td><td><img src=images/alarm_state_1_greyed.png height=120px></td><td><img src=images/alarm_state_2_greyed.png height=120px></td><td><img src=images/alarm_state_3_greyed.png height=120px></td><td><img src=images/alarm_state_4_greyed.png height=120px></td><td><img src=images/arduino_activated.png height=120px></td>";
}
if($alarm_status == 1)
{
	echo "<td><img src=images/alarm_management_greyed.png height=120px></td><td><img src=images/alarm_state_0_greyed.png height=120px'></td><td><img src=images/alarm_state_1.png height=120px></td><td><img src=images/alarm_state_2_greyed.png height=120px></td><td><img src=images/alarm_state_3_greyed.png height=120px></td><td><img src=images/alarm_state_4_greyed.png height=120px></td><td><img src=images/arduino_activated.png height=120px></td>";
}
if($alarm_status == 2)
{
	echo "<td><img src=images/alarm_management_greyed.png height=120px></td><td><img src=images/alarm_state_0_greyed.png height=120px></td><td><img src=images/alarm_state_1_greyed.png height=120px></td><td><img src=images/alarm_state_2.png height=120px></td><td><img src=images/alarm_state_3_greyed.png height=120px></td><td><img src=images/alarm_state_4_greyed.png height=120px></td><td><img src=images/arduino_activated.png height=120px></td>";
}
if($alarm_status == 3)
{
	echo "<td><img src=images/alarm_management_greyed.png height=120px></td><td><img src=images/alarm_state_0_greyed.png height=120px></td><td><img src=images/alarm_state_1_greyed.png height=120px></td><td><img src=images/alarm_state_2_greyed.png height=120px></td><td><img src=images/alarm_state_3.png height=120px></td><td><img src=images/alarm_state_4_greyed.png height=120px></td><td><img src=images/arduino_activated.png height=120px></td>";
}
if($alarm_status == 4)
{
	echo "<td><img src=images/alarm_management_greyed.png height=120px></td><td><img src=images/alarm_state_0_greyed.png height=120px></td><td><img src=images/alarm_state_1_greyed.png height=120px></td><td><img src=images/alarm_state_2_greyed.png height=120px></td><td><img src=images/alarm_state_3.png height=120px></td><td><img src=images/alarm_state_4.png height=120px></td><td><img src=images/arduino_activated.png height=120px></td>";
}
if($alarm_status == 6)
{
	echo "<td><img src=images/alarm_management_greyed.png height=120px></td><td><img src=images/alarm_state_0_greyed.png height=120px></td><td><img src=images/alarm_state_1_greyed.png height=120px></td><td><img src=images/alarm_state_2_greyed.png height=120px></td><td><img src=images/alarm_state_3.png height=120px></td><td><img src=images/alarm_state_4.png height=120px></td><td><img src=images/arduino_sensor_alarm.png height=120px></td>";
}
echo "</tr></table>";
echo "<br><hr>";

?>
