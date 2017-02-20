ruleset echo {
  meta {
    name "Echo"
    description << an echo server ruleset >>
    author "Austin Hewlett"
    logging on
    sharing on
  }
  global {

  }
  rule hello {
    select when echo hello
      send_directive("say") with
        something = "Hello World";
  }
  rule message {
    select when echo message
      send_directive("say") with
        something = input
  }
}