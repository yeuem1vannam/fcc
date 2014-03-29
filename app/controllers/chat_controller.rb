class ChatController < WebsocketRails::BaseController
  def initialize_session
    # perform application setup here
    controller_store[:message_count] = 0
  end

  def new_user
    binding.pry
    msg = {msg: "Hello Client"}
    send_message :new_user_connected, msg, namespace: :chats
  end

  def new_message
    binding.pry
    callback_xxx
  end

  def callback_xxx
    binding.pry
    msg = {msg: "xxx", score: 10}
    send_message :callback_xxx, msg, namespace: :chats
  end

  def xxx
    WebsocketRails[:chats].trigger "new", 10
    WebsocketRails[:chatxxx].trigger "newxxx", 10000
  end
end
