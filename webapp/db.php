<?php

try {
	$pdo = new \PDO("mysql:hostname=localhost;dbname=webapp;", MYSQL_USER, MYSQL_PASSWORD);
} catch(Exception $e) {
	die($e->getMessage());
}
