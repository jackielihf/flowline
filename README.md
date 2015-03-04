#flowline
Use **flowline** to filter large set of data, by adding user-specified filters to it.
***
## API
### flowline.use([name,] filterFunc [,context])
    Add a filter to flowline.
- **name**  (string) filter name
- **filterFunc**  (function) filter handler to process data , invoked by flowline automatically.
- **context**     (object) context of filterFunc

### flowline.push(data)
    Push data into a flowline to process.
- **data** (object) data

### events of flowline
#### flowline.on("data", callback)
- callback  function(data)   the object which is writed to the output buffer of flowline.

#### flowline.on("error", callback)
- callback  function(err, data)  err: error message. data: the original data pushed by user.

### filterFunc(data, out, next)
    A handler function to be wrapped in a filter.
- **data** (object) data passed to the filter
- **out**  (object) output buffer. anything writed to it will be output to user program.
- **next** (function) a callback must be called when user finished processing data.
    - next()  no data will be passed to the next filter.
    - next(null, result)  result will be passed to the next filter.
    - next(err)   return a error message, and flowline is interrupted.


##Sample
###create a flowline  
    Flowline = require('flowline');  
    flowline = new Flowline();  
###create a filter  
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
###add filters to the flowline  
      flowline.use("filter1", fn);  
      flowline.use("filter2", fn);  
###listen on events  
      flowline.on("error", function(err, data) {  
        return console.log("err:" + err, data);  
      });  
      flowline.on("data", function(data) {  
        return console.log(data);  
      });  
###process data  
    flowline.push("hi");  
    
###output of console:
hi jack  
hello world
    

