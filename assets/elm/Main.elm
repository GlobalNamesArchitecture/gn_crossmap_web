module Main exposing (..)

import Html


type alias Model =
    { token : Maybe String }


initialModel : Model
initialModel =
    { token = Nothing }


type Msg
    = NothingYet


view model =
    Html.text "setting up FILE INFO"


main =
    view initialModel
