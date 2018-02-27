module NotificationHelper

  def mark_all_as_read
    @notif = Notification.unread(current_user.id)
    @notif.each do |notif|
      Notification.mark_as_read(notif.to_dot.id)
    end
  end

  def event(type)
    if ['message', 'match', 'like'].include? type
      "Nouveau " + type
    elsif type == 'unmatch'
      "Nouvel " + type
    else
      "Nouvelle visite"
    end
  end

  def notif_path(type)
    if type == "like"
      "/likes/index"
    elsif type == "message"
      "/conversation/index"
    elsif type == "visit"
      "/visits/index"
    end
  end

end
