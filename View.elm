module View exposing (view)

import Html.Attributes as HA
import Html.Events     as HE
import Html            as H
import Message         as Msg
import Model           as Mdl
import Maybe
import Dict


logInSignInTexts = ["Log In","Sign In"]
logInInputTexts  = ["Username", "Password"]
logInInputTypes  = ["text"    , "password"]
signInInputTexts = logInInputTexts ++ ["Re-enter Password", "Email"]
signInInputTypes = logInInputTypes ++ ["password"         , "text"]
allInputTexts    = logInInputTexts

toMsg : String -> List String -> a -> List a -> a
toMsg key keys msg msgs =
    List.map2 (,)
        keys
        msgs
    |> Dict.fromList
    |> Dict.get key
    |> Maybe.withDefault msg

logInSignInToMsg: String -> Msg.Message
logInSignInToMsg logInSignIn =
    toMsg 
        logInSignIn 
        logInSignInTexts
        Msg.Nothing
        [
            Msg.GotoLogIn, 
            Msg.GotoSignIn
        ]  

inputsToMsg : String -> String -> Msg.Message
inputsToMsg input =
    toMsg
        input
        allInputTexts
        (\s -> Msg.Nothing)
        [
            Msg.Username, 
            Msg.Password,
            Msg.ReEnterPassword,
            Msg.Email
        ]

type alias HMsg = H.Html Msg.Message
type alias HAtt = H.Attribute Msg.Message
type alias HTag = List HAtt -> List HMsg -> HMsg

hList : HTag -> List HAtt -> HTag -> List(List HAtt, List HMsg) -> HMsg
hList hGTag globals hLTag items =
    hGTag globals (List.map (uncurry hLTag) items)

hListTextInput : String -> List (String, String) -> HMsg
hListTextInput name items =
    List.map 
        (
            \x->( 
                    [
                        HA.title (snd x),
                        HA.type' (fst x), 
                        HA.placeholder (snd x), 
                        HE.onInput (inputsToMsg (snd x))
                    ], 
                    []
                )
        )
        items
    |> hList H.form [HA.class name] H.input

view : Mdl.Model -> HMsg
view model =
    let
        logInSignIn =
            List.map 
                (\x->([HA.title x, HE.onClick (logInSignInToMsg x)], [H.text x]))
                logInSignInTexts
            |> hList H.div [HA.class "LogInSignIn"] H.button

        logInInputs =
            List.map2 (,)
                logInInputTypes
                logInInputTexts
            |> hListTextInput "LogInForm"

        signInInputs =
            List.map2 (,)
                signInInputTypes
                signInInputTexts
            |> hListTextInput "SignInForm"

        runButton = (\msg -> \text -> [H.button [HE.onClick msg ] [H.text text]])
    in
    H.div 
        []
        (
            H.text model.websocketReply ::
            logInSignIn ::
            case model.logInOrSignIn of
                Mdl.LogIn  -> logInInputs  :: runButton Msg.RunLogIn  "Log In !"
                Mdl.SignIn -> signInInputs :: runButton Msg.RunSignIn "Sign In !"
        )
        