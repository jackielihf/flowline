(function() {
  var EventEmitter, Filter, FilterChain, IoBuffer, _, es, stream,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  EventEmitter = require('events').EventEmitter;

  _ = require("underscore");

  stream = require("stream");

  es = require("event-stream");

  IoBuffer = require("./IoBuffer");

  Filter = require("./Filter");

  FilterChain = (function(superClass) {
    extend(FilterChain, superClass);

    function FilterChain() {
      this.filters = [];
      this.outBuffer = new IoBuffer();
      this.streamChain = null;
    }

    FilterChain.prototype.addFilter = function(filter) {
      if (filter instanceof Filter) {
        this.filters.push(filter);
      }
      return this;
    };

    FilterChain.prototype.clearFilters = function() {
      this.filters = [];
      return this;
    };

    FilterChain.prototype.buildStreamChain = function(out) {
      var curStream, filter, i, len, objectStream, ref, streamChain, upstream;
      objectStream = new stream.Transform({
        objectMode: true
      });
      streamChain = upstream = objectStream;
      ref = this.filters;
      for (i = 0, len = ref.length; i < len; i++) {
        filter = ref[i];
        curStream = es.map((function(_this) {
          return function(data, callback) {
            return filter.execute(data, out, function(err, result) {
              return callback(err, result);
            });
          };
        })(this));
        curStream.on("error", function(err) {
          return streamChain.emit("error", err);
        });
        upstream = upstream.pipe(curStream);
      }
      return streamChain;
    };

    FilterChain.prototype.througth = function(data, callback) {
      var out, streamChain;
      callback = callback || function() {};
      out = new IoBuffer(function(obj) {
        return callback(null, obj);
      });
      streamChain = this.buildStreamChain(out);
      streamChain.on("error", function(err) {
        return callback(err);
      });
      return streamChain.push(data);
    };

    return FilterChain;

  })(EventEmitter);

  module.exports = FilterChain;

}).call(this);
