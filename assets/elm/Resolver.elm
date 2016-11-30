module Resolver exposing (view, startResolution, queryResolutionProgress)

import Html exposing (..)
import Http
import Json.Decode as JD
import Common exposing (..)


view : Model -> Html Msg
view model =
    case model.stats of
        Nothing ->
            Html.text "No Status Data"

        Just stats ->
            Html.text stats.status


startResolution : String -> Cmd Msg
startResolution token =
    let
        url =
            "/resolver/" ++ token
    in
        Http.send LaunchResolution
            (Http.get url
                (JD.field "status" JD.string)
            )


queryResolutionProgress : String -> Cmd Msg
queryResolutionProgress token =
    let
        url =
            "/stats/" ++ token
    in
        Http.send ResolutionProgress
            (Http.get url resolutionStatsDecoder)


resolutionStatsDecoder : JD.Decoder Stats
resolutionStatsDecoder =
    JD.map7 Stats
        (JD.at [ "status" ] JD.string)
        (JD.at [ "total_records" ] JD.int)
        ingestion
        resolution
        lastBatchesTime
        matches
        fails


lastBatchesTime : JD.Decoder (List Float)
lastBatchesTime =
    (JD.at [ "last_batches_time" ] (JD.list JD.float))


ingestion : JD.Decoder IngestionStats
ingestion =
    JD.map3 IngestionStats
        (JD.at [ "ingested_records" ] JD.int)
        (JD.at [ "ingestion_start" ] (JD.nullable JD.float))
        (JD.at [ "ingestion_span" ] (JD.nullable JD.float))


resolution : JD.Decoder ResolutionStats
resolution =
    JD.map4 ResolutionStats
        (JD.at [ "resolved_records" ] JD.int)
        (JD.at [ "resolution_start" ] (JD.nullable JD.float))
        (JD.at [ "resolution_stop" ] (JD.nullable JD.float))
        (JD.at [ "resolution_span" ] (JD.nullable JD.float))


matches : JD.Decoder Matches
matches =
    JD.map7 Matches
        (JD.at [ "matches", "0" ] JD.int)
        (JD.at [ "matches", "1" ] JD.int)
        (JD.at [ "matches", "2" ] JD.int)
        (JD.at [ "matches", "3" ] JD.int)
        (JD.at [ "matches", "4" ] JD.int)
        (JD.at [ "matches", "5" ] JD.int)
        (JD.at [ "matches", "6" ] JD.int)


fails : JD.Decoder Int
fails =
    (JD.at [ "matches", "7" ] JD.int)
