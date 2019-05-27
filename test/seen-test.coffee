# TODO test more, like the non-timeago functionality

Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/seen.coffee')

describe 'seen', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'responds to \'seen alice\'', ->
    @room.user.say('alice', '@hubot seen alice').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot seen alice']
        ['hubot', 'alice was last seen less than a minute ago, saying \'@hubot seen alice\' in room1']
      ]

  it 'responds to a question about someone who hasn\'t spoken', ->
    @room.user.say('alice', '@hubot seen bob').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot seen bob']
        ['hubot', 'I haven\'t seen bob around lately']
      ]
