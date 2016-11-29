module Resolver exposing (view, startResolution)

import Html exposing (..)
import Http
import Json.Decode as Decode
import Common exposing (..)


view : Model -> Html Msg
view model =
    Html.text "hi"


startResolution : String -> Cmd Msg
startResolution token =
    let
        url =
            "/resolver/" ++ token
    in
        Http.send ResolutionStarted (Http.get url (Decode.field "status" Decode.string))
