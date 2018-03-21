var ws, show;

function connect(query){
  try{
    show = function(el){
      return function(msg){ el.innerHTML = msg + '<br />' + el.innerHTML; }
    }(document.getElementById('msgs'));

    ws = new WebSocket("ws://localhost:3001?key=" + query);

    ws.onopen = function() {
    }

    ws.onclose = function() {
    }

    ws.onmessage = function(msg) {
      show(msg.data);
    }
  } catch(exception) {
    show("Error: " + exception);
  }
}

function send() {
  var text = $("#message").val();
  if (text == '') {
    return;
  }

  var conversation = $("#conversation").val();
  text = JSON.stringify({"message": text, "conversation": conversation})

  try {
    ws.send(text);
  } catch(exception) {
    show("Failed To Send")
  }

  $("#message").val('');
}
