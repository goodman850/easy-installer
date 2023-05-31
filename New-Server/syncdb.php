<?php
date_default_timezone_set("Asia/Tehran");
$ip = "serverip";
$token = "servertoken";

$output = shell_exec('cat /etc/passwd | grep "/home/" | grep -v "/home/syslog"');
$userlist = preg_split("/\r\n|\n|\r/", $output);
foreach($userlist as $user){
$userarray = explode(":",$user);
if (!empty($userarray[0])) {
 $out = shell_exec('bash /var/www/html/delete '.$userarray[0]);
 echo $userarray[0] . " Removed  <br>";
}}
include "config.php";
$pid = shell_exec("pgrep nethogs");
$pid = preg_replace("/\\s+/", "", $pid);
if (is_numeric($pid)) {
    $out = file_get_contents("/var/www/html/p/log/out.json");
    $trafficlog = preg_split("/\r\n|\n|\r/", $out);
    $trafficlog = array_filter($trafficlog);
    $lastdata = end($trafficlog);
    $json = json_decode($lastdata, true);
    $newarray = [];
    foreach ($json as $value) {
        $TX = round($value["TX"], 0);
        $RX = round($value["RX"], 0);
        $name = preg_replace("/\\s+/", "", $value["name"]);
        if (strpos($name, "sshd") === false) {
            $name = "";
        }
        if (strpos($name, "root") !== false) {
            $name = "";
        }
        if (strpos($name, "[net]") !== false) {
            $name = "";
        }
        if (strpos($name, "[accepted]") !== false) {
            $name = "";
        }
        if (strpos($name, "[rexeced]") !== false) {
            $name = "";
        }
        if (strpos($name, "@notty") !== false) {
            $name = "";
        }
        if (strpos($name, "root:sshd") !== false) {
            $name = "";
        }
        if (strpos($name, "/sbin/sshd") !== false) {
            $name = "";
        }
        if (strpos($name, "[priv]") !== false) {
            $name = "";
        }
        if (strpos($name, "@pts/1") !== false) {
            $name = "";
        }
        if ($value["RX"] < 1 && $value["TX"] < 1) {
            $name = "";
        }
        $name = str_replace("sshd:", "", $name);
        if (!empty($name)) {
            if (isset($newarray[$name])) {
                $newarray[$name]["TX"] + $TX;
                $newarray[$name]["RX"] + $RX;
            } else {
                $newarray[$name] = ["RX" => $RX, "TX" => $TX, "Total" => $RX + $TX];
            }
        }
    }
    $oout= json_encode($newarray);
} else {
    unlink("/var/www/html/p/log/out.json");
    $startnethogs = shell_exec("sudo nethogs -j  -v 3 > /var/www/html/p/log/out.json &");
    header("Refresh:1");
}

$postParameter = array(
    'method' => 'multiserver'
);
$curlHandle = curl_init('http://'.$ip.'/apiV1/api.php?token='.$token);
curl_setopt($curlHandle, CURLOPT_POSTFIELDS, $postParameter);
curl_setopt($curlHandle, CURLOPT_RETURNTRANSFER, true);
$curlResponse = curl_exec($curlHandle);
curl_close($curlHandle);
$data = json_decode($curlResponse, true);
$data = $data['data'];
foreach ($data as $user){
	$out = shell_exec('bash /var/www/html/adduser '.$user['username'].' '.$user['password']);
}
$postParameter = array(
    'method' => 'multisrvsync',
    'datasyy'=> $oout
);
$curlHandle = curl_init('http://'.$ip.'/apiV1/api.php?token='.$token);
curl_setopt($curlHandle, CURLOPT_POSTFIELDS, $postParameter);
curl_setopt($curlHandle, CURLOPT_RETURNTRANSFER, true);
$curlResponse = curl_exec($curlHandle);
curl_close($curlHandle);
$data = json_decode($curlResponse, true);
$data = $data['data'];
foreach ($data as $user){
	$out = shell_exec('bash /var/www/html/adduser '.$user['username'].' '.$user['password']);
}
?>
