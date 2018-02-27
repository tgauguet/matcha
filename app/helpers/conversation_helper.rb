module ConversationHelper

  def init_conversation(user_id, conversation_id)
    @user = get_user(user_id)
    @conversation = get_conversation(conversation_id).to_dot
    @interlocutor = get_interlocutor(user_id, conversation_id)
    @messages = Message.all(conversation_id)
  end

  def get_conversation(id)
    Conversation.find(id)
  end

  def get_user(id)
    User.find_by("id", id)
  end

  def not_exists?(user_id)
    res = 1
    @conversations = UserConversation.all(current_user.id)
    @conversations.each do |c|
      c = c.to_dot
      i = get_interlocutor(c.user_id, c.conversation_id)
      res = 0 if i.id == user_id
    end
    res
  end

  def get_interlocutor(user, conversation)
    id = UserConversation.find_interlocutor(user, conversation)
    User.find_by("id", id)
  end

  def msg_class(id)
    id == current_user.id ? "my-mssg" : "other-mssg"
  end

  def my_msg(id)
    id != current_user.id
  end

  def last_message(messages)
    i = 0
    res = "Aucun message"
    messages.each do |m|
      i += 1
      if messages.count == i
        res = m.to_dot.content
      end
    end
    res
  end

end
