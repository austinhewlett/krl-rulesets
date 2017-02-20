ruleset trip_store {
  meta {
    name "Trip Store"
    description << stores information about trips >>
    author "Austin Hewlett"
    logging on
    sharing on
    provides trips, long_trips, short_trips
  }
  global {
    trips = function() {
      trips = ent:trip;
      trips;
    };
    long_trips = function() {
      long_trips = ent:long_trip;
      long_trips;
    };
    short_trips = function() {
      long_trips = ent:long_trip.keys();
      short_trips = ent:trips.filter(function(k,v){
        long_trips.none(function(x) {x neq k});
      });
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
  rule collect_long_trips {
    select when explicit found_long_trip
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
      send_directive("collect_long_trips") with 
        passed_id = id and
          passed_mileage = mileage and
          passed_timestamp = timestamp
    }
    always {
      set ent:long_trip init if not ent:long_trip{["_0"]};
      set ent:long_trip{[id,"trip","mileage"]} mileage;
      set ent:long_trip{[id,"trip","timestamp"]} timestamp;
    }
  }
  rule clear_trips {
    select when car trip_reset
      always {
        clear ent:trip;
        clear ent:long_trip;
      }
  }
}