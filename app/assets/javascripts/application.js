// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery-fileupload
//= require jquery.atwho
//= require_tree .

$(function(){
  var user_id = $("#current_user_id").val();
  if(user_id > 0){
    var faye = new Faye.Client('http://pfaye.herokuapp.com/faye');
    faye.subscribe("/users/" + user_id, function(data){
      eval(data);
    });

    faye.subscribe("/poker", function(data){
      eval(data);
    });
  }

  function scan_user(){
    var discuss_users = {} ;
    var names = [] ;
    $(".cast_discuss_user").each(function(){
      var u_name = $(this).text();
      discuss_users[u_name] = u_name;
    });
    var index = 0;
    for(key in discuss_users){
      names[index] = key;
      index += 1;
    }
    return names;
  }

  $("#comment_content").atwho("@", {
    data: scan_user()
  })

});
