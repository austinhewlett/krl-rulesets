ruleset trip_store {
  meta {

  }
  global {
    trips = function() {

    }
    long_trips = function() {

    }
    short trips = function() {

    }
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
            "timestamp": timestamp.now()}}
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
  rule collect_long_trips {

  }
  rule clear_trips {

  }
}