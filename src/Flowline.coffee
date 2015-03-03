
{EventEmitter} = require 'events'
_ = require "underscore"
FilterChain = require "./FilterChain"
Filter = require "./Filter"

class Flowline extends EventEmitter
    constructor: ()->
        @chain = new FilterChain()
        #@handler = (err, data)->

    use: (name, fn, context)->
        if _.isFunction name
            fn = name
            name = null
        if _.isFunction fn
            @chain.addFilter new Filter(name, fn, context)
        return @
    ###
    setHandler: (handler)->
        if _.isFunction handler
            @handler = handler 
        else
            throw new Exception "handler should be a function"
    ###
    #async push
    push: (data)->
        process.nextTick ()=>            
            @chain.througth data, (err, result)=>
                if err
                    @emit "error", err, data
                else
                    @emit "data", result
        return @


module.exports = Flowline

