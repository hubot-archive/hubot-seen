# Description:
#   A hubot script that tracks when/where users were last seen.
#
# Commands:
#   hubot seen <user> - show when and where user was last seen
#   hubot seen in last 24h - list users seen in last 24 hours
#
# Configuration:
#   HUBOT_SEEN_TIMEAGO - If set (to anything), last seen times will be relative
#
# Author:
#   wiredfool, patcon@gittip

config =
  use_timeago: process.env.HUBOT_SEEN_TIMEAGO

clean = (thing) ->
  (thing || '').toLowerCase().trim()
dbg = (thing) ->
  console.log thing

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
    dbg msg.message.user.room
    msg.message.user.room
  catch error
    false

class Seen
  constructor: (@robot) ->
    @cache = {}

    @robot.brain.on 'loaded', @load
    if @robot.brain.data.users.length
      @load()

  load: =>
    if @robot.brain.data.seen
      @cache = @robot.brain.data.seen
    else
      @robot.brain.data.seen = @cache

  add: (user, channel) ->
    dbg "seen.add #{clean user} on #{channel}"
    @cache[clean user] =
      chan:channel
      date: new Date() - 0

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
      seen.add (ircname msg), (ircchan msg)

  robot.respond /seen @?([-\w.\\^|{}`\[\]]+):? ?(.*)/, (msg) ->
    if msg.match[1] == "in" and msg.match[2] == "last 24h"
      users = seen.usersSince(24)
      msg.send "Active in #{msg.match[2]}: #{users.join(', ')}"
    else
      dbg "seen check #{clean msg.match[1]}"
      nick = msg.match[1]
      last = seen.last nick
      if last.date
        date_string = if config.use_timeago?
          timeago = require 'timeago'
          timeago(new Date(last.date))
        else
          "at #{new Date(last.date)}"

        msg.send "#{nick} was last seen in #{last.chan} #{date_string}"

      else
        msg.send "I haven't seen #{nick} around lately"
