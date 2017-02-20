ruleset track_tips {
  meta {
    name "Track Tips"
    description << A track tips ruleset >>
    author "Austin Hewlett"
    logging on
    sharing on
  }
  global {

  }
  rule process_trip {
    select when echo message
    pre {
      mileage = event:attr("mileage").klog("passed in mileage: ");
    }
    {
      send_directive("trip") with
        length = mileage
    }
    always {
      log ("LOG length " + mileage);
    }
  }
}
