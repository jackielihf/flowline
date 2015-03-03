(function() {
  var IoBuffer, Queue;

  Queue = require("queue-async");

  IoBuffer = (function() {
    function IoBuffer(handler) {
      this.buffer = new Queue();
      this.handler = handler || function() {};
    }

    IoBuffer.prototype.setHandler = function(fn) {
      if (typeof fn === "function") {
        return this.handler = fn;
      }
    };

    IoBuffer.prototype.write = function(obj) {
      this.buffer.defer(this.handler, obj);
      return this;
    };

    return IoBuffer;

  })();

  module.exports = IoBuffer;

}).call(this);
