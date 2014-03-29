WebsocketRails::EventMap.describe do
  namespace :chats do
    subscribe :new_user, to: ChatController, with_method: :new_user
    subscribe :new_message, to: ChatController, with_method: :new_message
  end
  namespace :chatxxx do
    subscribe :xxx, to: ChatController, with_method: :xxx
  end

  # You can use this file to map incoming events to controller actions.
  # One event can be mapped to any number of controller actions. The
  # actions will be executed in the order they were subscribed.
  #
  # Uncomment and edit the next line to handle the client connected event:
  #   subscribe :client_connected, :to => Controller, :with_method => :method_name
  #
  # Here is an example of mapping namespaced events:
  #   namespace :product do
  #     subscribe :new, :to => ProductController, :with_method => :new_product
  #   end
  # The above will handle an event triggered on the client like `product.new`.
end
