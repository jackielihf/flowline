
assert = require "assert"
require('chai').should()

###
IoBuffer = require "./IoBuffer"
buffer = new IoBuffer()
handler = (msg)->
    console.log msg
buffer.setHandler handler
buffer.write 'hello'
buffer.write 'world'

stream = require "stream"
ss = new stream.Transform({objectMode: true })
ss.on "data", (data)->
    console.log data.length
ss.push('head')
###


Filter = require "./Filter"
FilterChain = require "./FilterChain"
Flowline = require "./Flowline"
chain = new FilterChain()

class User
    constructor: (@name)->


fn = (data, out, next)->
    if data is "hello"
        out.write data+" world"
        next()
    else if data is "hi"
        out.write data+" jack"+@name
        next null, "hello"
    else
        next "invalid data", data

###
filter = new Filter "filter1", fn
filter2 = new Filter "filter2", fn
chain.addFilter filter
chain.addFilter filter2
chain.througth "hi", (err, data)->
    console.log err, data
###

user = new User("ie")

flowline = new Flowline()
flowline.setHandler (err, data)->
    console.log err, data
flowline.use "filter1", fn, user
flowline.use "filter2", fn, user
flowline.on "error", (err, data)->
    console.log "err:"+err, data
flowline.on "data", (data)->
    console.log data
flowline.push "hia"
flowline.push "hi"
flowline.push "hiaaa"










