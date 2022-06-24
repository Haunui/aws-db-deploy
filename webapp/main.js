var words = ""
var current_word = 0
var good_word = 0
var score = 0

let N_WORD = 10

let TIME_PER_GAME = 10
var timer = TIME_PER_GAME

var intervalID = null
var end = 0

function renew_words() {
  var oReq = new XMLHttpRequest();

  oReq.onload = function() {
    words = JSON.parse(this.responseText)

    var str = ""
    for(let i=0;i<N_WORD;i++) {
      str += "<span id=\"word-" + i + "\">" + words[i] + "</span> "
    }
    $("#display").html(str);
  };

  oReq.open("get","get-words.php?n=" + N_WORD, false);
  oReq.send();
}

$(document).ready(function() {
  var oReq = new XMLHttpRequest();

  oReq.onload = function() {
    words = JSON.parse(this.responseText)

    var str = ""
    for(let i=0;i<N_WORD;i++) {
      str += "<span id=\"word-" + i + "\">" + words[i] + "</span> "
    }
    $("#display").html(str);
    $("#score").text(score);
    $("#timer").text(timer);
  };

  oReq.open("get","get-words.php?n=" + N_WORD, false);
  oReq.send();
});


$('#input').on('input', function(e) {
  var str = $(this).val()
  var target_str = $("#word-" + current_word).text();

  if(end == 1) {
    return 0
  }

  if(intervalID == null) {
    intervalID = setInterval(function() {
      if(timer <= 0) {
        clearInterval(intervalID)
        end = 1
        $("#input").prop("disabled", true);
        $("#result").css("display", "block");
        $("#result_score").text(score);
        $("#input_score").val(score);
      }

      $("#timer").text(timer)
      timer--
    }, 1000);
  }

  if(target_str == str && str) {
    $("#word-" + current_word).css("color", "green");
    good_word = 1
  } else if(str.substr(str.length - 1) == " ") {
    if(good_word == 1) {
      good_word = 0
      score++
      $("#score").text(score);
    }

    //$("#word-" + current_word).css("background-color", "none");
    $(this).val("");
    current_word++

    if (current_word == N_WORD) {
      renew_words()
      current_word=0
    }
  } else {
    $("#word-" + current_word).css("color", "red");
  }
});

$("#fft-form").on("submit", function(e) {
  event.preventDefault();
});

$("#restart").on("click", function() {
  window.location.href = "/";
});
