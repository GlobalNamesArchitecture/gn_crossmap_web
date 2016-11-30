module Resolver exposing (view, startResolution, queryResolutionProgress)

import Html exposing (..)
import Http
import Json.Decode as Decode
import Common exposing (..)


view : Model -> Html Msg
view model =
    case model.stats of
        Nothing ->
            Html.text "resolution"

        Just stats ->
            Html.text stats


startResolution : String -> Cmd Msg
startResolution token =
    let
        url =
            "/resolver/" ++ token
    in
        Http.send LaunchResolution
            (Http.get url
                (Decode.field "status" Decode.string)
            )


queryResolutionProgress : String -> Cmd Msg
queryResolutionProgress token =
    let
        url =
            "/stats/" ++ token
    in
        Http.send ResolutionProgress (Http.get url resolutionStatsDecoder)


resolutionStatsDecoder : Decode.Decoder Stats
resolutionStatsDecoder =
    Decode.field "status" Decode.string
