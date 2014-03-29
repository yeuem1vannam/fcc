// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require websocket_rails/main
//= require_tree .

var task = {
  name: 'Start taking advantage of WebSockets',
  completed: false
}

var dispatcher = new WebSocketRails('localhost:3000/websocket');

// // trigger
// dispatcher.trigger('chats.new_message', task);
// // receiver
// dispatcher.bind('tasks.create_success', function(task) {
//   console.log('successfully created ' + task.name);
// });
// dispatcher.bind('chats.callback_xxx', function(data) {
//   console.log(data);
// });
