<?php
date_default_timezone_set("Asia/Tehran");
$ip = "serverip";
$token = "servertoken";


//include "config.php";
$output = shell_exec('cat /etc/passwd | grep "/home/" | grep -v "/home/syslog"');
$userlist = preg_split("/\r\n|\n|\r/", $output);

$output1 = shell_exec('cat /etc/passwd | cut -d: -f1');
$userlist1 = preg_split("/\r\n|\n|\r/", $output1);

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
    //$oout= json_encode($newarray);

} else {
    unlink("/var/www/html/p/log/out.json");
    $startnethogs = shell_exec("sudo nethogs -j  -v 3 > /var/www/html/p/log/out.json &");
    header("Refresh:1");
}
//die();
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
$datuss=array();
$tee=0;
//var_dump($data);
foreach ($data as $user){
   // $out = shell_exec('sh /var/www/html/adduser '.$user['username'].' '.$user['password']);
  //  echo $user['username'] ." added  <br>";

    $datuss[$tee]=$user['username'];
    $tee++;
    if(!array_search($user['username'], $userlist1)){

        if (!empty($user['username'])) {
         $out = shell_exec('sh /var/www/html/adduser '.$user['username'].' '.$user['password']);
         echo $user['username'] ." added  <br>";
        }
        }
	
}
//var_dump($datuss);


foreach($userlist as $user){
    $userarray = explode(":",$user);
    if(!in_array($userarray[0], $datuss)){

if (!empty($userarray[0])) {
 $out = shell_exec('sh /var/www/html/delete '.$userarray[0]);
 echo $userarray[0] . " Removed  <br>";
}
}
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
echo 'donme';
$out = shell_exec("sudo killall -9 nethogs");
sleep(2);
$startnethogs = shell_exec("sudo nethogs -j  -v 3 > /var/www/html/p/log/out.json &");
//header("Refresh:1");
?>
