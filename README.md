#flowline
Use **flowline** to filter large set of data, by adding user-specified filters to it.
***
##Sample
·
    //create a flowline  
    Flowline = require('flowline');  
    flowline = new Flowline();  
    //create a filter  
    fn = function(data, out, next) {  
        if (data === "hello") {  
          //output
          out.write(data + " world");  
          //be filtered  
          return next();  
        } else if (data === "hi") {  
          out.write(data + " jack");  
          //transmit to the next filter  
          return next(null, "hello");  
        } else {  
          //return an error msg  
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
·

