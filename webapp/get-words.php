<?php

require("config.php");
require("db.php");

$words=[];

if(isset($_GET["n"])) {
  $N_WORD=$_GET["n"];
  $req = $pdo->prepare("SELECT * FROM french_words ORDER BY RAND() LIMIT ?");
  $req->bindParam(1, $N_WORD, PDO::PARAM_INT);
  $req->execute();

  while ($row = $req->fetch(PDO::FETCH_ASSOC)) {
    $words[]=$row["word"];
  }

} else {
  $req = $pdo->query("SELECT * FROM french_words");
  foreach($req as $row) {
    $words[]=$row["word"];
  }
}

echo json_encode($words);
