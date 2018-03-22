var ws, show;

function update_counter(loc)
{
    var r = $(loc)[0];
    if (r.childNodes.length != 2)
    {
        var span = document.createElement("span")
        span.classList.add("counter")
        span.innerHTML = "1"
        $(loc)[0].appendChild(span)
    }
    else {
        r.childNodes[1].innerHTML = parseInt(r.childNodes[1].innerHTML) + 1;
    }
}

function connect(id, token){
  try{
    show = function(el){
    console.log(el);
    }

    ws = new WebSocket("ws://localhost:3001?key=" + id + "&token=" + token);

    show("Socket Status > " + ws.readyState);

    ws.onopen = function() {
      show("Socket Status > " + ws.readyState + " (open)");
    }

    ws.onclose = function() {
      show("Socket Status > " + ws.readyState + " (closed)");
    }

    ws.onmessage = function(msg) {
      show("Received: " + msg.data);
      var msg = JSON.parse(msg.data);
      if (msg["type"] == "conversation")
      {
          var test = (new RegExp('conversation\/' + msg["conversation_id"] + '\/show'))
          if (test.test(window.location.pathname))
          {
              var di = document.createElement("div")
              di.classList.add("other-mssg")

              var img = document.createElement("img")
              img.src = USER_IMAGE ? "/files/" + USER_IMAGE : "/files/empty.png";

              var text = document.createElement("div")
              text.innerText = msg["message"]
              di.appendChild(img);
              di.appendChild(text);
              $("#conversation_message")[0].appendChild(di);
          }
      }
      else
      {
          if (msg["type"] == "message")
            update_counter("#conversation_notification");
          update_counter("#header_notification")
      }
    }
  } catch(exception) {
    show("Error: " + exception);
  }
}
var test = (new RegExp('conversation/[0-9]+/show'))
if (test.test(window.location.pathname))
{
    window.scrollTo(0, 9999999999);
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
