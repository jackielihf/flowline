
{EventEmitter} = require 'events'
_ = require "underscore"
stream = require "stream"
es = require "event-stream"

IoBuffer = require "./IoBuffer"
Filter = require "./Filter"

class FilterChain extends EventEmitter
    constructor: ()->
        @filters = []
        @outBuffer = new IoBuffer()
        @streamChain = null        
        
    addFilter: (filter)->
        @filters.push(filter) if filter instanceof Filter
        return @

    clearFilters: ()->
        @filters = []
        return @

    buildStreamChain: (out)->        
        objectStream = new stream.Transform({objectMode: true })        
        streamChain = upstream = objectStream
        for filter in @filters            
            #console.log "build filter: "+filter.id
            curStream = es.map (data, callback)=>
                filter.execute data, out, (err, result)->
                    callback err, result
            curStream.on "error", (err)->
                streamChain.emit "error", err
            #pipe to the next filter
            upstream = upstream.pipe curStream                    
        return streamChain

    througth: (data, callback)->
        callback = callback || ()->
        out = new IoBuffer (obj)->
            callback null, obj
        streamChain = @buildStreamChain(out)
        streamChain.on "error", (err)->            
            callback err
        streamChain.push data






module.exports = FilterChain




        