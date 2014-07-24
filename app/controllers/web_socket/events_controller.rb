class WebSocket::EventsController < WebsocketRails::BaseController
  def delete_user
    object = {name: current_user.try(:name) || "Guest"}
    WebsocketRails[:submissions].trigger(:user_disconnected, object)
  end

  def test
    WebsocketRails[:submissions].trigger "show", UserScore.local_user_scores(4)
  end
end
