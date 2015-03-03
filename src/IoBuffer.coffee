
Queue = require "queue-async"

class IoBuffer
    constructor: (handler)->        
        @buffer = new Queue()
        @handler = handler || ()->

    setHandler: (fn)->
        @handler = fn if typeof fn is "function"

    write: (obj)->
        @buffer.defer @handler, obj        
        return @

    

module.exports = IoBuffer
