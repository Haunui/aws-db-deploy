<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
    <title>Fast FINGER TEST</title>
    <link href="main.css" type="text/css" rel="stylesheet" />
	</head>
  <body>
    <div class="container">
      <div id="display" class="display"></div>
      <div class="form">
        <form id="fft-form">
          <input id="input" type="text" />
          <div id="timer" class="score"></div>
          <div id="score" class="timer"></div>
          <button id="restart">Restart</button>
          <div style="clear: both;"></div>
        </form>
        <div id="result" class="result">
          <p>
            Félicitations ! <br/>Vous tapez <span id="result_score"></span> mots par minutes
          </p>
          <div class="register_result">Voulez-vous enregistrer votre score ? Si oui, entrer votre nom d'utilisateur dans la case ci-dessous et cliquez sur enregistrer</div>
        <form action="rr.php" method="POST">
          <input type="text" name="username" placeholder="Nom d'utilisateur" />
          <input type="hidden" id="input_score" name="score" value="" />
          <button>Valider</button>
        </form>
        </div>
        <div style="clear: both"></div>
      </div>
      <div class="result">
        <table>
          <tr>
            <th>Username</th>
            <th>Score</th>
            <th>Date</th>
          </tr>
          <?php
        
          require("config.php");
          require("db.php");

          $req = $pdo->query("SELECT * FROM history ORDER BY score,game_date DESC");
          foreach($req as $row): ?>
          <tr>
            <td><?= $row["username"] ?></td>
            <td><?= $row["score"] ?></td>
            <td><?= $row["game_date"] ?></td>
          </tr>
          <?php endforeach; ?>
        </table>
      </div>
    </div>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="main.js"></script>
	</body>
</html>
