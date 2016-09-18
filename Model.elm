module Model exposing (..)

type LogInOrSignIn = LogIn | SignIn

type alias Model =
    {
        logInOrSignIn   : LogInOrSignIn,
        username        : String,
        password        : String,
        reEnterPassword : String,
        email           : String,
        websocketReply  : String
    }
