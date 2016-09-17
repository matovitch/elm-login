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
    |> hList H.div [HA.class name] H.input

menuTexts        = ["Log In","Sign In"]
logInInputTexts  = ["Username", "Password"]
signInInputTexts = logInInputTexts ++ ["Re-enter Password", "Email"]
logInInputTypes  = ["text", "password"]
signInInputTypes = logInInputTypes ++ ["password", "text"]

menuClickToMsg: String -> Msg.Message
menuClickToMsg logInOrSignIn =
    List.map2 (,)
        menuTexts
        [
            Msg.GotoLogIn, 
            Msg.GotoSignIn
        ]
    |> Dict.fromList
    |> Dict.get logInOrSignIn
    |> Maybe.withDefault Msg.Nothing

inputsToMsg : String -> String -> Msg.Message
inputsToMsg input =
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
                (\x->([HA.title x, HE.onClick (menuClickToMsg x)], [H.text x]))
                menuTexts
            |> hList H.ul [HA.class "MainMenu"] H.button

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
        