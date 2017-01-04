module Resolver.Decoder exposing (statusDecoder, statsDecoder)

import Json.Decode exposing (..)
import Resolver.Models exposing (..)


statusDecoder : Decoder String
statusDecoder =
    field "status" string


statsDecoder : Decoder Stats
statsDecoder =
    map7 Stats
        (at [ "status" ] string)
        (at [ "total_records" ] int)
        ingestion
        resolution
        lastBatchesTime
        matches
        fails



--PRIVATE


lastBatchesTime : Decoder (List Float)
lastBatchesTime =
    (at [ "last_batches_time" ] (list float))


ingestion : Decoder Ingestion
ingestion =
    map3 Ingestion
        (at [ "ingested_records" ] int)
        (at [ "ingestion_start" ] (nullable float))
        (at [ "ingestion_span" ] (nullable float))


resolution : Decoder Resolution
resolution =
    map4 Resolution
        (at [ "resolved_records" ] int)
        (at [ "resolution_start" ] (nullable float))
        (at [ "resolution_stop" ] (nullable float))
        (at [ "resolution_span" ] (nullable float))


matches : Decoder Matches
matches =
    map7 Matches
        (at [ "matches", "0" ] float)
        (at [ "matches", "1" ] float)
        (at [ "matches", "2" ] float)
        (at [ "matches", "3" ] float)
        (at [ "matches", "4" ] float)
        (at [ "matches", "5" ] float)
        (at [ "matches", "6" ] float)


fails : Decoder Float
fails =
    (at [ "matches", "7" ] float)
