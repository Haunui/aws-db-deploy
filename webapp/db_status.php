<?php

require("config.php");

try {
	$pdo = new \PDO("mysql:hostname=localhost;dbname=webapp;", MYSQL_USER, MYSQL_PASSWORD);
	echo 0;
} catch(Exception $e) {
	echo 1;
}
