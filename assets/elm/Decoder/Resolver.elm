module Decoder.Resolver exposing (statsDecoder, statusDecoder)

import Json.Decode exposing (..)
import Common exposing (..)


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


ingestion : Decoder IngestionStats
ingestion =
    map3 IngestionStats
        (at [ "ingested_records" ] int)
        (at [ "ingestion_start" ] (nullable float))
        (at [ "ingestion_span" ] (nullable float))


resolution : Decoder ResolutionStats
resolution =
    map4 ResolutionStats
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
