module LikesHelper

  def is_liked?
    Liked.liked?(@user.id, current_user.id) != 0
  end

  def to_delete?(id)
    Liked.liked?(id, current_user.id) != 0
  end

  def heart_img
    is_liked? ? "heart3.png" : "heart2.png"
  end

  def liked_me?(id)
    Liked.liked?(current_user.id, id) != 0
  end

  def like_btn_val
    is_liked? ? "Dé-liker" : "Liker"
  end

  def its_a_match?(id)
    liked_me?(id) && to_delete?(id)
  end

  def match_notifications(id)
    Notification.new("match", id, "Vous avez un match avec #{current_user.login}")
    Notification.new("match", current_user.id, "Vous avez un match avec #{User.find_by("id", id).login}")
  end

  def heart_animation(id)
    "bg_heart" if liked_me?(id) unless its_a_match?(id)
  end

end
