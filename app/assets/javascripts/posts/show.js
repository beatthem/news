$(document).ready(function(){
    function afterVote(response){
        if (response['success']){
            var votes_field = $('.votes');
            var vote_message = 'Вы проголосовали за эту новость'
            if (response['vote_sign']){
              vote_message = vote_message + ' (' + response['vote_sign'] + ')';
            }
            votes_field.html(vote_message);
            var raiting_field = $('#post-rating');
            if (response['rating'] != undefined){
              raiting_field.html(' ' + response['rating'])
            }
        }
    }
    function vote(vote_type){
      // alert(vote_type);
      post_id = gon.post.id;
      $.post("/post_vote",
        { vote_type: vote_type, post_id: post_id } , afterVote);
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
