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

## Sample Interaction

```
user1>> hubot seen wiredfool
hubot>> wiredfool was last seen in #joiito on <date>

```
