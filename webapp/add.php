<?php

require("config.php");
require("db.php");

$handle = fopen("liste_francais_utf8.txt", "r");
if ($handle) {
  while (($line = fgets($handle)) !== false) {
    $word = strtolower(trim($line));
    $stmt = $pdo->prepare("INSERT INTO french_words(word) VALUES(?)");
    $stmt->bindParam(1, $word, PDO::PARAM_STR);
    $stmt->execute();
  }

  fclose($handle);
}
