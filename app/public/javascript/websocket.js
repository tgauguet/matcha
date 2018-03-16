var ws, show;

function connect(query){
  try{
    show = function(el){
      //return function(msg){ el.innerHTML = msg + '<br />' + el.innerHTML; }
    //}(document.getElementById('msgs'));
    console.log(el);
    }

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
      alert(msg.data);
      var r = $("#header_notification")[0];
      if (r.childNodes.length != 2)
      {
          var span = document.createElement("span")
          span.classList.add("counter")
          span.innerHTML = "1"
          $("#header_notification")[0].appendChild(span)
      }
      else {
          r.childNodes[1].innerHTML = parseInt(r.childNodes[1].innerHTML) + 1;
      }
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

  try {
    ws.send(text);
    show("Sent: " + text)
  } catch(exception) {
    show("Failed To Send")
  }

  $("#message").val('');
}
