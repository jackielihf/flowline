(function() {
  var Filter, IoBuffer;

  IoBuffer = require("./IoBuffer");

  Filter = (function() {
    function Filter(id, fn, context) {
      this.id = id || "anonymous";
      this.fn = fn || function(data, out, next) {};
      this.context = context;
      this.defaultOutBuffer = new IoBuffer();
    }

    Filter.prototype.execute = function(data, out, next) {
      out = out || this.defaultOutBuffer;
      next = next || function() {};
      return this.fn.call(this.context, data, out, function(err, result) {
        return next(err, result);
      });
    };

    return Filter;

  })();

  module.exports = Filter;

}).call(this);
