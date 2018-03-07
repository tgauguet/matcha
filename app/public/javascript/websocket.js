var ws, show;

function connect(){
  try{
    show = function(el){
      return function(msg){ el.innerHTML = msg + '<br />' + el.innerHTML; }
    }(document.getElementById('msgs'));

    ws = new WebSocket("ws://localhost:3001");

    show("Socket Status: " + ws.readyState);

    ws.onopen = function() {
      show("Socket Status: " + ws.readyState + " (open)");
    }

    ws.onclose = function() {
      show("Socket Status: " + ws.readyState + " (closed)");
    }

    ws.onmessage = function(msg) {
      show("Received: " + msg.data);
    }
  } catch(exception) {
    show("Error: " + exception);
  }
}

$(function() {
  connect();
});

function send() {
  var text = $("#message").val();
  if (text == '') {
    show("Merci d'entrer un message");
    return;
  }

  try {
    ws.send(text);
    show("Sent: " + text)
  } catch(exception) {
    show("Failed To Send")
  }

  $("#message").val('');
}

$('#message').keypress(function(event) {
  if (event.keyCode == '13') { send(); }
});
