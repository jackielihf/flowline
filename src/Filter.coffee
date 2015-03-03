
IoBuffer = require "./IoBuffer"

class Filter
    constructor: (id, fn, context)->
        @id = id || "anonymous"
        @fn = fn || (data, out, next)->
        @context = context
        @defaultOutBuffer = new IoBuffer()

    execute: (data, out, next)->
        out = out || @defaultOutBuffer
        next = next || ()->
        @fn.call @context, data, out, (err, result)->
            #result should be routed to the next Filter
            next err, result



module.exports = Filter
        
        


    