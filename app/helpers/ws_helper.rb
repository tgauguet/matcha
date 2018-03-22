require 'json'
module WsHelper

    def self.send_ws_message(user_id, msg)
        unless MyWS.users[user_id].nil?
            MyWS.users[user_id].send(msg)
        end
    end

    def self.update_notification_count(user_id, type)
    end

end
