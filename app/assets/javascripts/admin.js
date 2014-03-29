//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require twitter/bootstrap
//= require ckeditor/init
//= require websocket_rails/main

var task = {
  msg: 'Start WS Connection',
  completed: false
}

var dispatcher = new WebSocketRails('localhost:3000/websocket');

// trigger
// dispatcher.trigger('chat.new_message', task);
// receiver
dispatcher.bind('chats.new_user_connected', function(task) {
  alert(task.msg);
});

dispatcher.bind('chats.callback_xxx', function(data) {
  alert(data.msg + " have " + data.score + " score");
});
// dispatcher.trigger("chats.xxx", "")
channel = dispatcher.subscribe("chats");
channel.bind("new", function(score){
  console.log("New Score", score)
})
channelxxx = dispatcher.subscribe("chatxxx");
channelxxx.bind("newxxx", function(data){
  console.log("New Data", data)
})
