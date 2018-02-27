module BlockHelper

  def block_to_delete?(id)
    Block.blocked?(id, current_user.id)
  end

  def is_blocked?
    Block.blocked?(@user.id, current_user.id)
  end

  def block_img
    is_blocked? ? "unstop.png" : "stop.png"
  end

  def block_btn_val
    is_blocked? ? "Débloquer" : "Bloquer"
  end

  def not_allowed(user)
    Block.blocked?(user.id, current_user.id)
  end

end
