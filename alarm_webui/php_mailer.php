<?php
include ('db-ro-connect.php');
$language_query = sprintf("SELECT language FROM SETTINGS");
$language_res = $conn->query($language_query);

while($row = $language_res->fetch_assoc()) {
	 $language=$row['language'];
}

require 'PHPMailer/src/PHPMailer.php';
require 'PHPMailer/src/SMTP.php';
require 'PHPMailer/src/Exception.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

$message_include_attachment='no';
if (isset($argc)) {
	for ($i = 0; $i < $argc; $i++) {
    if (strpos($argv[$i], 'message_include_attachment') !== false) {
      $message_include_attachment='yes';
    }
    if (strpos($argv[$i], 'event') !== false) {
			$template_text = $argv[$i];
    }
	}
}
if (!isset($template_text))
{
  $template_text='event_default_text';
}

$mail_auth_query = sprintf("SELECT * FROM SETTINGS");
$mail_auth_result = $conn->query($mail_auth_query);


while($row = $mail_auth_result->fetch_assoc()) {
  $SMTP_SERVER = $row['SMTP_SERVER'];
  $SMTP_SERVER_PORT = $row['SMTP_SERVER_PORT'];
  $SMTP_USERNAME = $row['SMTP_USERNAME'];
  $SMTP_PASSWORD = $row['SMTP_PASSWORD'];
}

$mail_recipient_query = sprintf("SELECT * FROM SMTP_RECIPIENTS");
$mail_recipient_result = $conn->query($mail_recipient_query);


while($row = $mail_recipient_result->fetch_assoc()) {
  if($row['active_recipient'] == "1")
  {
    $mail = new PHPMailer(True);
    $mail->isSMTP();
    $mail->Host = $SMTP_SERVER;
    $mail->SMTPAuth = true;
    $mail->Username = $SMTP_USERNAME;
    $mail->Password = $SMTP_PASSWORD;
    $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;
    $mail->Port = $SMTP_SERVER_PORT;
    $mail->setFrom($SMTP_USERNAME, 'RIDS Alarm');
    $mail->addAddress($row['recipient_address_mail'], 'RIDS Alarm');
    if($row['include_image_captures'] == "1" && $message_include_attachment == 'yes'){
      $mail->addAttachment('images/logo.png', 'attachment.jpg');
    }
    $mail->isHTML(true);
    $mail->CharSet="UTF-8";
    $mail->Subject = 'RIDS ALARM notification';
    $mail->AddEmbeddedImage("images/logo.png", "rids_logo.png");
    $fp = fopen("mail_templates/fr_".$template_text.".html", "r");
    $str = fread($fp, filesize("mail_templates/".$language."_".$template_text.".html"));
    $mail->Body = $str;
    fclose($fp);

    #$mail->AltBody = 'This is the body in plain text for non-HTML mail clients';


    if(!$mail->send()) {
       echo 'Erreur, message non envoyé.';
       echo 'Mailer Error: ' . $mail->ErrorInfo;
    } else {
       echo 'Le message a bien été envoyé !';
   }
  }

}
$conn->close();
 ?>
