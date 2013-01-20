$(document).ready(function(){
    function vote(vote_type){
      // alert(vote_type);

    }

    var upvote = "upvote";
    var downvote = "downvote";

    $("#" + upvote).on('click', function(){
        vote(upvote);
    });
    $("#" + downvote).on('click', function(){
        vote(downvote);
    });
});
