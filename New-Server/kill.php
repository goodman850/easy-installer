<?php
$port="2096";


$list = shell_exec("sudo lsof -i :".$port." -n | grep -v root | grep ESTABLISHED");
$onlineuserlist = preg_split("/\r\n|\n|\r/", $list);
foreach($onlineuserlist as $user){
$user = preg_replace('/\s+/', ' ', $user);
$userarray = explode(" ",$user);
$onlinelist[] = $userarray[2];
}
$onlinecount = array_count_values($onlinelist);
$out = file_get_contents("/var/www/html/ooo.json");
$json = json_decode($out, true);
foreach ($json as $row){
$limitation = $row[1];
$username = $row[0];
if (empty($limitation)){$limitation= "0";}
if ($limitation !== "0" && $onlinecount[$username] > $limitation){
$out = shell_exec('sudo killall -u '. $username );
var_dump($row);
}
}

?>