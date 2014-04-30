# Description:
#   A hubot script that tracks when/where users were last seen
#
# Commands:
#   hubot seen <user> - show when and where user was last seen
#
# Configuration:
#   None
#
# Author:
#   wiredfool, patcon@gittip


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
    @cache[clean user] = {c:channel, d:new Date() - 0}

  last: (user) ->
    @cache[clean user] ? {}


module.exports = (robot) ->
  seen = new Seen robot

  # Keep track of last msg heard
  robot.hear /.*/, (msg) ->
    unless is_pm msg
      seen.add (ircname msg), (ircchan msg)

  robot.respond /seen @?([-\w._]+):?/, (msg) ->
    dbg "seen check #{clean msg.match[1]}"
    nick = msg.match[1]
    last = seen.last nick
    if last.d
      msg.send "#{nick} was last seen in #{last.c} at #{new Date(last.d)}"
    else
      msg.send "I haven't seen #{nick} around lately"
