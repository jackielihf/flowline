#flowline
Use **flowline** to filter large set of data, by adding user-specified filters to it.
***
##Sample

Flowline = require('flowline');
//create a flowline
flowline = new Flowline();

//create a filter
fn = function(data, out, next) {
    if (data === "hello") {
      out.write(data + " world");
      return next();
    } else if (data === "hi") {
      out.write(data + " jack");
      return next(null, "hello");
    } else {
      return next("invalid data");
    }
  };
//add filters to the flowline
  flowline.use("filter1", fn);
  flowline.use("filter2", fn);
  
//listen on events
  flowline.on("error", function(err, data) {
    return console.log("err:" + err, data);
  });
  flowline.on("data", function(data) {
    return console.log(data);
  });
  
//process data
flowline.push("hi");


