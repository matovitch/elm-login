import Message as Msg
import Model   as Mdl
import Html.App
import View

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
init = (Mdl.LogIn, Cmd.none)

update : Msg.Message -> Mdl.Model -> (Mdl.Model, Cmd Msg.Message)
update msg model = 
    case msg of    
        Msg.GotoSignIn -> (Mdl.SignIn, Cmd.none)
        Msg.GotoLogIn  -> (Mdl.LogIn , Cmd.none)
        _              -> (model     , Cmd.none)

subscriptions : Mdl.Model -> Sub Msg.Message
subscriptions model = Sub.none

view = View.view