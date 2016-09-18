
import Json.Encode as JsonE
import WebSocket   as WSk
import Message     as Msg
import Model       as Mdl
import Html.App
import View

websocketServer = "ws://echo.websocket.org"

main : Program Never
main = 
    Html.App.program
    {
        init = init,
        view = view,
        update = update,
        subscriptions = subscriptions
    }

init : (Mdl.Model, Cmd Msg.Message)
init = (Mdl.Model Mdl.LogIn "" "" "" "" "", Cmd.none)

logInJson : Mdl.Model -> String
logInJson model =
    JsonE.object 
        [
            ("username", JsonE.string model.username),
            ("password", JsonE.string model.password)
        ]
    |> JsonE.encode 0


update : Msg.Message -> Mdl.Model -> (Mdl.Model, Cmd Msg.Message)
update msg model = 
    case msg of
        Msg.GotoLogIn            -> ({ model | logInOrSignIn   = Mdl.LogIn }, Cmd.none)
        Msg.GotoSignIn           -> ({ model | logInOrSignIn   = Mdl.SignIn}, Cmd.none)
        Msg.Username        text -> ({ model | username        = text }     , Cmd.none)
        Msg.Password        text -> ({ model | password        = text }     , Cmd.none)
        Msg.ReEnterPassword text -> ({ model | reEnterPassword = text }     , Cmd.none)
        Msg.Email           text -> ({ model | email           = text }     , Cmd.none)
        Msg.RunLogIn             -> (
                                        model,
                                        WSk.send websocketServer (logInJson model)
                                    )
        Msg.WebsocketReply  text -> ({ model | websocketReply = text }      , Cmd.none)
        _                        -> (model                                  , Cmd.none)

subscriptions : Mdl.Model -> Sub Msg.Message
subscriptions model =
    WSk.listen websocketServer Msg.WebsocketReply

view = View.view