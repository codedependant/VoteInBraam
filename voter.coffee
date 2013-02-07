console?.log "i run everwhere"
Comments = new Meteor.Collection("comments")
Votes = new Meteor.Collection("votes")


if Meteor.isServer
  console?.log "in the server"

  Meteor.publish "all-comments", ()->
    Comments.find()

  Meteor.publish "all-votes", ()->
    Votes.find()


  Comments.allow
    insert : (userId, comment)->
      true

  Votes.allow
    insert : (userId, vote)->
      if userId? and Votes.find({userId: userId}).count() < 1
        vote['userId'] = userId
        true
      else
        false


if Meteor.isClient
  console?.log "i run in the client"

  Meteor.subscribe("all-comments")
  Meteor.subscribe("all-votes")

  Template.votes_template.votes_count = (choice)->
    Votes.find({choice: choice}).count()

  Template.votes_template.user_eligble = ()->
    if Meteor.userId()? and Votes.find({userId: Meteor.userId()}).count() < 1
      true
    else
      false

  Template.comments_template.comments_list = ()->
    Comments.find()


  Template.votes_template.events
    "click button" : (event)->
      choice = $(event.target).data("choice")
      Votes.insert({choice: choice})

  Template.comments_template.events
    "click #comment_submit" : (event)->
      text = $("#comment_text").val()
      $("#comment_text").val("")
      Comments.insert({text: text})
