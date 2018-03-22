module WsHelper

    def self.send_ws_message(user_id, msg)
        unless MyWS.users[user_id].nil?
            MyWS.users[user_id].send(msg)
        end
    end

end
