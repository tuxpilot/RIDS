<?php




if($alarm_status != 5)
{
	echo "<span style=color:red>Warning the alarm is not in management mode, no modification can be made<span>.<br>";
}else{



  if(isset($_GET['action']))
  {
  	$action = $_GET['action'];
  	if($action == "delete" && $alarm_status == 5)
  	{
      $ID = $_GET['ID'];
  		include ('db-rw-connect.php');
  		$actionrequest = sprintf("DELETE FROM CAMERAS_MANAGEMENT WHERE ID = '".$ID."'");
  		$actionresult = $conn->query($actionrequest);
  		$conn->close();
  	}
  }


  if($action == "setting_to_change" && $alarm_status == 5)
  {
    include ('db-ro-connect.php');
    $ID = $_GET['ID'];
    $camerasquery = sprintf("SELECT * FROM CAMERAS_MANAGEMENT WHERE ID ='".$ID."'");
    $camerasresult = $conn->query($camerasquery);
    while($row = $camerasresult->fetch_assoc()) {
      $CAMERA_NAME = $row['CAMERA_NAME'];
      $CAMERA_GPIO_LINK = $row['CAMERA_GPIO_LINK'];
      $CAMERA_URL = $row['CAMERA_URL'];
      $CAMERA_USERNAME = $row['CAMERA_USERNAME'];
      $CAMERA_PASSWORD = $row['CAMERA_PASSWORD'];
      $CAMERA_CAPTURE_ON_ALERT_ONLY = $row['CAMERA_CAPTURE_ON_ALERT_ONLY'];

    }
?>

    <form action="index.php">
      <table border=0 align=center>
        <tr>
          <td><label for="CAMERA_NAME"><b>CAMERA_NAME</b></label></td>
          <td><input type="text" placeholder=<?php echo $CAMERA_NAME; ?> name="CAMERA_NAME"></td>
        </tr>
        <tr>
          <td><label for="CAMERA_GPIO_LINK"><b>CAMERA_GPIO_LINK</b></label></td>
          <td><input type="text" placeholder=<?php echo $CAMERA_GPIO_LINK; ?> name="CAMERA_GPIO_LINK"></td>
        </tr>
        <tr>
          <td><label for="CAMERA_URL"><b>CAMERA_URL</b></label></td>
          <td><input type="text" placeholder=<?php echo $CAMERA_URL; ?> name="CAMERA_URL"></td>
        </tr>
        <tr>
          <td><label for="CAMERA_USERNAME"><b>CAMERA_USERNAME</b></label></td>
          <td><input type="text" placeholder=<?php echo $CAMERA_USERNAME; ?> name="CAMERA_USERNAME"></td>
        </tr>
        <tr>
          <td><label for="CAMERA_PASSWORD"><b>CAMERA_PASSWORD</b></label></td>
          <td><input type="text" placeholder=<?php echo $CAMERA_PASSWORD; ?> name="CAMERA_PASSWORD"></td>
        </tr>
        <tr>
          <td><label for="CAMERA_CAPTURE_ON_ALERT_ONLY"><b>CAMERA_CAPTURE_ON_ALERT_ONLY?</b></label></td>
          <td><select name="CAMERA_CAPTURE_ON_ALERT_ONLY" id="CAMERA_CAPTURE_ON_ALERT_ONLY">
                <option value="1">1</option>
                <option value="0">0</option>
                <option value="" selected></option>
              </select>
          </td>
        </tr>
        <input id="page" name="page" type="hidden" value="cameras_management">
        <input id="ID" name="ID" type="hidden" value=<?php echo $ID; ?>>
        <input id="action" name="action" type="hidden" value="update_cameras_new_infos"><br>
        <tr><td colspan=2 align=center><button type="submit" class="btn">Change now!</button></td></tr>
      </table>
      </form>
      <br><br>
<?php
  }



  if($action == "update_cameras_new_infos" && $alarm_status == 5)
  {
    $CAMERA_NAME = $_GET['CAMERA_NAME'];
    $CAMERA_GPIO_LINK = $_GET['CAMERA_GPIO_LINK'];
    $CAMERA_URL = $_GET['CAMERA_URL'];
    $CAMERA_USERNAME = $_GET['CAMERA_USERNAME'];
    $CAMERA_PASSWORD = $_GET['CAMERA_PASSWORD'];
    $CAMERA_CAPTURE_ON_ALERT_ONLY = $_GET['CAMERA_CAPTURE_ON_ALERT_ONLY'];

    $ID = $_GET['ID'];
    include ('db-rw-connect.php');
    if($CAMERA_NAME != "")
    {
      $actionrequest = sprintf("UPDATE CAMERAS_MANAGEMENT SET CAMERA_NAME = '".$CAMERA_NAME ."' WHERE ID = '".$ID."'");
      $actionresult = $conn->query($actionrequest);
    }
    if($CAMERA_GPIO_LINK != "")
    {
      $actionrequest = sprintf("UPDATE CAMERAS_MANAGEMENT SET CAMERA_GPIO_LINK = '".$CAMERA_GPIO_LINK ."' WHERE ID = '".$ID."'");
      $actionresult = $conn->query($actionrequest);
    }
    if($CAMERA_URL != "")
    {
      $actionrequest = sprintf("UPDATE CAMERAS_MANAGEMENT SET CAMERA_URL = '".$CAMERA_URL ."' WHERE ID = '".$ID."'");
      $actionresult = $conn->query($actionrequest);
    }
    if($CAMERA_USERNAME != "")
    {
      $actionrequest = sprintf("UPDATE CAMERAS_MANAGEMENT SET CAMERA_USERNAME = '".$CAMERA_USERNAME ."' WHERE ID = '".$ID."'");
      $actionresult = $conn->query($actionrequest);
    }
    if($CAMERA_PASSWORD != "")
    {
      $actionrequest = sprintf("UPDATE CAMERAS_MANAGEMENT SET CAMERA_PASSWORD = '".$CAMERA_PASSWORD ."' WHERE ID = '".$ID."'");
      $actionresult = $conn->query($actionrequest);
    }
    if($CAMERA_CAPTURE_ON_ALERT_ONLY != "")
    {
      $actionrequest = sprintf("UPDATE CAMERAS_MANAGEMENT SET CAMERA_CAPTURE_ON_ALERT_ONLY = '".$CAMERA_CAPTURE_ON_ALERT_ONLY ."' WHERE ID = '".$ID."'");
      $actionresult = $conn->query($actionrequest);
    }
    $conn->close();
  }


  if($action == "add_new_cameras_infos" && $alarm_status == 5)
  {
    include ('db-rw-connect.php');
    $CAMERA_NAME = $_GET['CAMERA_NAME'];
    $CAMERA_GPIO_LINK = $_GET['CAMERA_GPIO_LINK'];
    $CAMERA_URL = $_GET['CAMERA_URL'];
    $CAMERA_USERNAME = $_GET['CAMERA_USERNAME'];
    $CAMERA_PASSWORD = $_GET['CAMERA_PASSWORD'];
    $CAMERA_CAPTURE_ON_ALERT_ONLY = $_GET['CAMERA_CAPTURE_ON_ALERT_ONLY'];

    if($CAMERA_NAME != "" && $CAMERA_GPIO_LINK != '' && $CAMERA_URL != '' && $CAMERA_USERNAME != '' && $CAMERA_PASSWORD != '' && $CAMERA_CAPTURE_ON_ALERT_ONLY != '')
    {
      $actionrequest  = sprintf("INSERT INTO `CAMERAS_MANAGEMENT` (`ID`, `CAMERA_NAME`, `CAMERA_GPIO_LINK`, `CAMERA_URL`, `CAMERA_USERNAME`, `CAMERA_PASSWORD`, `CAMERA_CAPTURE_ON_ALERT_ONLY`)
      VALUES (NULL, '$CAMERA_NAME', '$CAMERA_GPIO_LINK', '$CAMERA_URL', '$CAMERA_USERNAME', '$CAMERA_PASSWORD', '$CAMERA_CAPTURE_ON_ALERT_ONLY')");
      $actionresult = $conn->query($actionrequest);
    }else{
      echo "<span style=color:red>Warning one or more fields are empty. We can't create a new GPIO without these datas.<span>.<br>";
    }
  }



  if($action == "add_camera" && $alarm_status == 5)
  {
  ?>
    <form action="index.php">
      <table border=0 align=center>
        <tr>
          <td><label for="CAMERA_NAME"><b>CAMERA_NAME</b></label></td>
          <td><input type="text" placeholder='' name="CAMERA_NAME" required="required"></td>
        </tr>
        <tr>
          <td><label for="CAMERA_GPIO_LINK"><b>CAMERA_GPIO_LINK</b></label></td>
          <td><input type="text" placeholder='' name="CAMERA_GPIO_LINK" required="required"></td>
        </tr>
        <tr>
          <td><label for="CAMERA_URL"><b>CAMERA_URL</b></label></td>
          <td><input type="text" placeholder='' name="CAMERA_URL" required="required"></td>
        </tr>
        <tr>
          <td><label for="CAMERA_USERNAME"><b>CAMERA_USERNAME</b></label></td>
          <td><input type="text" placeholder='' name="CAMERA_USERNAME" required="required"></td>
        </tr>
        <tr>
          <td><label for="CAMERA_PASSWORD"><b>CAMERA_PASSWORD</b></label></td>
          <td><input type="text" placeholder='' name="CAMERA_PASSWORD" required="required"></td>
        </tr>
        <tr>
          <td><label for="CAMERA_CAPTURE_ON_ALERT_ONLY"><b>CAMERA_CAPTURE_ON_ALERT_ONLY?</b></label></td>
          <td><select name="CAMERA_CAPTURE_ON_ALERT_ONLY" id="CAMERA_CAPTURE_ON_ALERT_ONLY" required="required">
                <option value="1">1</option>
                <option value="0">0</option>
                <option value="" selected></option>
              </select>
          </td>
        </tr>
        <input id="page" name="page" type="hidden" value="cameras_management">
        <input id="action" name="action" type="hidden" value="add_new_cameras_infos"><br>
        <tr><td colspan=2 align=center><button type="submit" class="btn">Add now!</button></td></tr>
      </table>
      </form>
      <br><br>
  <?php
  }



  include ('db-ro-connect.php');
  $camerasquery = sprintf("SELECT * FROM CAMERAS_MANAGEMENT ORDER BY ID DESC");
  $cameraslistresult = $conn->query($camerasquery);
  $conn->close();

  while($row = $cameraslistresult->fetch_assoc()) {
    echo "<center><table border='0' cellpadding='0' cellspacing='0' style='border-collapse: collapse; width: 40%; margin: 1.5em; font-family: Arial, Helvetica, sans-serif; font-size: 0.85em;'><tbody>
          <tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
  			   <td>CAMERA_NAME</td><td>".$row['CAMERA_NAME']."</td>
          </tr>
          <tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
            <td>CAMERA_GPIO_LINK</td><td>".$row['CAMERA_GPIO_LINK']."</td>
          </tr>
          <tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
            <td>CAMERA_URL</td><td>".$row['CAMERA_URL']."</td>
          </tr>
          <tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
            <td>CAMERA_USERNAME</td><td>".$row['CAMERA_USERNAME']."</td>
          </tr>
          <tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
            <td>CAMERA_PASSWORD</td><td>".$row['CAMERA_PASSWORD']."</td>
          </tr>
          <tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
            <td>CAMERA_CAPTURE_ON_ALERT_ONLY</td><td>".$row['CAMERA_CAPTURE_ON_ALERT_ONLY']."</td>
          </tr>
          <tr style='border-bottom: 1px solid #ccc; line-height: 1.8em;'>
            <td><a href='index.php?page=cameras_management&action=setting_to_change&ID=".$row['ID']."'><img src='images/setting_changing.png' height='40px'><br> Modify Settings</a></td>
            <td><a href='index.php?page=cameras_management&action=delete&ID=".$row['ID']."'><img src='images/delete.png' height='40px'><br> Delete this camera</a></td>
          </tr>
      </table></center>";
  }
echo "<a href='index.php?page=cameras_management&action=add_camera'>ADD New Camera <img src='images/add.png' height='40px'></a>";
}
?>
