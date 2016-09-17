module View exposing (view)

import Html.Attributes as HA
import Html.Events     as HE
import Html            as H
import Message         as Msg
import Model           as Mdl
import Maybe
import Dict


type alias HMsg = H.Html Msg.Message
type alias HAtt = H.Attribute Msg.Message
type alias HTag = List HAtt -> List HMsg -> HMsg


hList : HTag -> List HAtt -> List HMsg -> HMsg
hList htag globals items =
    htag globals (List.map (\x -> H.li [] [x]) items)


hListTextInput : String -> List (String, String) -> HMsg
hListTextInput name items =
    List.map 
        (
            \x->
                H.input 
                [
                    HA.title (snd x),
                    HA.type' (fst x), 
                    HA.placeholder (snd x), 
                    HE.onInput (inputToMsg (snd x))
                ] 
                []
        )
        items
    |> hList H.ul [HA.class name]


mainMenu         = ["Log In","Sign In"]
logInInputTexts  = ["Username", "Password"]
signInInputTexts = logInInputTexts ++ ["Re-enter Password", "Email"]
logInInputTypes  = ["text", "password"]
signInInputTypes = logInInputTypes ++ ["password", "text"]


clickToMsg: String -> Msg.Message
clickToMsg logInOrSignIn =
    List.map2 (,)
        mainMenu
        [
            Msg.GotoLogIn, 
            Msg.GotoSignIn
        ]
    |> Dict.fromList
    |> Dict.get logInOrSignIn
    |> Maybe.withDefault Msg.Nothing

inputToMsg : String -> String -> Msg.Message
inputToMsg input =
    List.map2 (,)
        signInInputTexts
        [
            Msg.Username, 
            Msg.Password,
            Msg.ReEnterPassword,
            Msg.Email
        ]
    |> Dict.fromList
    |> Dict.get input
    |> Maybe.withDefault (\s -> Msg.Nothing)

view : Mdl.Model -> HMsg
view model =
    let
        logInOrSignIn =
            List.map 
                (\x->(H.button [HA.title x, HE.onClick (clickToMsg x)] [H.text x]))
                mainMenu
            |> hList H.ul [HA.class "MainMenu"]

        logInInputs =
            List.map2
                (,)
                logInInputTypes
                logInInputTexts
            |> hListTextInput "LogInInputs"

        signInInputs =
            List.map2
                (,)
                signInInputTypes
                signInInputTexts
            |> hListTextInput "SignInInputs"
    in
    H.div 
        []
        (
            logInOrSignIn ::
            case model of
                Mdl.LogIn  -> logInInputs  :: [H.button [HE.onClick Msg.RunLogIn ] [H.text "Log In !" ]]
                Mdl.SignIn -> signInInputs :: [H.button [HE.onClick Msg.RunSignIn] [H.text "Sign In !"]]
        )
        