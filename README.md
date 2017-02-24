# hubot-seen

A hubot script that tracks when/where users were last seen

See [`src/seen.coffee`](src/seen.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-seen --save`

Then add **hubot-seen** to your `external-scripts.json`:

```json
["hubot-seen"]
```

## Configuration

Set `HUBOT_SEEN_TIMEAGO` to `false` in the environment to output an absolute time (like "Sat Feb 11 2017 03:12:39 GMT-0500 (EST)") instead of a relative one (like "less than a minute ago"). Defaults to true (i.e. relative times).

## Sample Interaction

```
user1>> hubot seen wiredfool
hubot>> wiredfool was last seen in #joiito less than a minute ago

```
