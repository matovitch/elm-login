module Message exposing (..)

type Message = 
    GotoLogIn              |
    GotoSignIn             |
    Username        String |
    Password        String |
    ReEnterPassword String |
    Email           String |
    RunLogIn               |
    RunSignIn              |
    WebsocketReply  String |
    Nothing
    