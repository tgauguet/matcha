require 'json'
module WsHelper

    def send_ws_message(user_id, msg)
        puts MyWS.users[user_id].to_json
        unless MyWS.users[user_id].nil?
            MyWS.users[user_id].send(msg)
        end
    end

end
