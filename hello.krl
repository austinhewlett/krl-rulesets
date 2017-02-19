ruleset hello_world {
  meta {
    name "Hello World"
    description << A first ruleset for the Quickstart >>
    author "Austin Hewlett"
    logging on
    sharing on
    provides hello
  }
  global {
    hello = function(obj) {
      msg = "Hello " + obj
      msg
    };
  }
  rule hello_world {
    select when echo hello
    pre {
      name = event:attr("name").defaultsTo(ent:name,"use stored name");
    }
    {
      send_directive("say") with
        something = "Hello #{name}";
    }
    always {
      log ("LOG says Hello " + name);
    }
  }
  rule store_name {
    select when hello name
    pre {
      id = event:attr("id").klog("our pass in id: ");
      first = event:attr("first").klog("our passed in first: ");
      last = event:attr("last").klog("our passed in last: ");
      init = {"_0": {
          "name": {
            "first": "GLaDOS",
            "last": ""
          }
        }}
    }
    {
      send_directive("store_name") with
        passed_id = id and
        passed_first = first and
        passed_last = last;
    }
    always {
      set ent:name init if not ent:name{["_0"]};
      set ent:name{[id,"name","first"]} first;
      set ent:name{[id,"name","last"]} last;
    }
  }
}