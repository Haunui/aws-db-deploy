<?php

require("config.php");
require("db.php");

if(isset($_POST["username"]) && isset($_POST["score"])) {
  $username = $_POST["username"];
  $score = $_POST["score"];

  $req = $pdo->prepare("INSERT INTO history(username,score,game_date) VALUES(?,?,NOW())");
  $req->bindParam(1, $username, PDO::PARAM_STR);
  $req->bindParam(2, $score, PDO::PARAM_INT);
  $req->execute();
}


header("Location: /");

?>
