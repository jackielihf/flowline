(function() {
  var EventEmitter, Filter, FilterChain, Flowline, _,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  EventEmitter = require('events').EventEmitter;

  _ = require("underscore");

  FilterChain = require("./FilterChain");

  Filter = require("./Filter");

  Flowline = (function(superClass) {
    extend(Flowline, superClass);

    function Flowline() {
      this.chain = new FilterChain();
    }

    Flowline.prototype.use = function(name, fn, context) {
      if (_.isFunction(name)) {
        fn = name;
        name = null;
      }
      if (_.isFunction(fn)) {
        this.chain.addFilter(new Filter(name, fn, context));
      }
      return this;
    };


    /*
    setHandler: (handler)->
        if _.isFunction handler
            @handler = handler 
        else
            throw new Exception "handler should be a function"
     */

    Flowline.prototype.push = function(data) {
      process.nextTick((function(_this) {
        return function() {
          return _this.chain.througth(data, function(err, result) {
            if (err) {
              return _this.emit("error", err, data);
            } else {
              return _this.emit("data", result);
            }
          });
        };
      })(this));
      return this;
    };

    return Flowline;

  })(EventEmitter);

  module.exports = Flowline;

}).call(this);
