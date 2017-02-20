ruleset track_tips {
  meta {
    name "Track Tips"
    description << A track tips ruleset >>
    author "Austin Hewlett"
    logging on
    sharing on
  }
  global {
    long_trip = 1000;
  }
  rule process_trip {
    select when car new_trip
    pre {
      mileage = event:attr("mileage").klog("passed in mileage: ");
    }
    {
      send_directive("trip") with
        length = mileage ;
    }
    always {
      log ("LOG length " + mileage);
      raise explicit event 'trip_processed'
        attributes event:attrs()
    }
  }
  rule trip_processed {
    select when explicit trip_processed
    log "LOG trip_processed attributes: ";
  }
  rule find_long_trips {
    select when explicit trip_processed
    pre {
      mileage = event:attr("mileage").klog("find_long_trips passed in mileage: ");
    }
    if (mileage < long_trip) then {
      send_directive("trip") with
        status = "Mileage is not long trip";
    }
    fired {
      log "LOG did not trigger found_long_trip";
    } 
    else {
      raise explicit event 'found_long_trip'
        attributes event:attrs()
    }
  }
  rule found_long_trip {
    select when explicit found_long_trip
    log "LOG found_long_trip explicit event triggered";
  }
}
