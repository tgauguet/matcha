var ws, show;

function connect(query){
  try{
    show = function(el){
      return function(msg){ el.innerHTML = msg + '<br />' + el.innerHTML; }
    }(document.getElementById('msgs'));

    ws = new WebSocket("ws://localhost:3001?key=" + query);

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

function send() {
  var text = $("#message").val();
  if (text == '') {
    show("Merci d'entrer un message");
    return;
  }

  var conversation = $("#conversation").val();
  text = JSON.stringify({"message": text, "conversation": conversation})

  try {
    ws.send(text);
    show("Sent: " + text)
  } catch(exception) {
    show("Failed To Send")
  }

  $("#message").val('');
}
