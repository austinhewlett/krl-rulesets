ruleset trip_store {
  meta {
    name "Trip Store"
    description << stores information about trips >>
    author "Austin Hewlett"
    logging on
  }
  global {
    trips = function() {
      trips = "";
      trips;
    };
    long_trips = function() {
      long_trips = "";
      long_trips;
    };
    short_trips = function() {
      short_trips = "";
      short_trips;
    };
  }
  rule collect_trips {
    select when explicit trip_processed
    pre {
      id = event:attr("id").klog("our pass in id: ");
      mileage = event:attr("mileage").defaultsTo(0, "no mileage passed");
      timestamp = time:now();
      init = {"_0": {
          "trip": {
            "mileage": "0",
            "timestamp": time:now()}}
          }
    }
    {
      send_directive("collect_trips") with
        passed_id = id and
        passed_mileage = mileage and
        passed_timestamp = timestamp
    }
    always {
      set ent:trip init if not ent:trip{["_0"]};
      set ent:trip{[id,"trip","mileage"]} mileage;
      set ent:trip{[id,"trip","timestamp"]} timestamp;
    }
  }
}