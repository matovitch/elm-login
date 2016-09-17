module Model exposing (..)

type Model =
    LogIn |
    SignIn

type Msg = 
    GotoLogIn              |
    GotoSignIn             |
    Username        String |
    Password        String |
    ReEnterPassword String |
    Email           String |
    Nothing