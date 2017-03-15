# Description:
#   A hubot script that tracks when/where users were last seen.
#
# Commands:
#   hubot seen <user> - show when and where user was last seen
#   hubot seen in last 24h - list users seen in last 24 hours
#
# Configuration:
#   HUBOT_SEEN_TIMEAGO - If set to `false` (defaults to `true`), last seen times will be absolute dates instead of relative
#
# Author:
#   wiredfool, patcon@gittip

config =
  use_timeago: process.env.HUBOT_SEEN_TIMEAGO isnt 'false'

clean = (thing) ->
  (thing || '').toLowerCase().trim()

is_pm = (msg) ->
  try
    msg.message.user.pm
  catch error
    false

ircname = (msg) ->
  try
    msg.message.user.name
  catch error
    false

ircchan = (msg) ->
  try
    msg.message.user.room
  catch error
    false

class Seen
  constructor: (@robot) ->
    @cache= {}

    @robot.brain.on 'loaded', => @cache = @robot.brain.data.seen || {}

  save: =>
    # TODO: should we try to only write changes to the db, instead of the entire map?
    @robot.brain.data.seen = @cache

  add: (user, channel, msg) ->
    @robot.logger.debug "seen.add #{clean user} on #{channel}"
    @cache[clean user] =
      chan: channel
      date: new Date() - 0
      msg: msg
    @save()

  last: (user) ->
    @cache[clean user] ? {}

  usersSince: (hoursAgo) ->
    HOUR_MILLISECONDS = 60*60*1000
    seenSinceTime = new Date(Date.now() - hoursAgo*HOUR_MILLISECONDS)
    users = (nick for nick, data of @cache when data.date > seenSinceTime)
    return users

module.exports = (robot) ->
  seen = new Seen robot

  # Keep track of last msg heard
  robot.hear /.*/, (msg) ->
    unless is_pm msg
      seen.add (ircname msg), (ircchan msg), msg.message.text

  robot.respond /seen @?([-\w.\\^|{}`\[\]]+):? ?(.*)/, (msg) ->
    if msg.match[1] == "in" and msg.match[2] == "last 24h"
      users = seen.usersSince(24)
      msg.send "Active in #{msg.match[2]}: #{users.join(', ')}"
    else
      robot.logger.debug "seen check #{clean msg.match[1]}"
      nick = msg.match[1]
      last = seen.last nick
      if last.date
        date_string = if config.use_timeago
          timeago = require 'timeago'
          timeago(new Date(last.date))
        else
          "at #{new Date(last.date)}"

        msg.send "#{nick} was last seen #{date_string}" + (if last.msg then (", saying '#{last.msg}'") else "") + " in #{last.chan}"

      else
        msg.send "I haven't seen #{nick} around lately"
