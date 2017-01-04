module Resolver.Models exposing (..)


type alias Resolver =
    { status : Status
    , stats : Maybe Stats
    }


type alias Stats =
    { status : String
    , totalRecords : Int
    , ingestion : Ingestion
    , resolution : Resolution
    , lastBatchesTime :
        List Float
    , matches : Matches
    , fails : Float
    }


type Status
    = Pending
    | InIngestion
    | InResolution
    | Done
    | Unknown


type alias Ingestion =
    { ingestedRecords : Int
    , ingestionStart : Maybe Float
    , ingestionSpan : Maybe Float
    }


type alias Resolution =
    { resolvedRecords : Int
    , resolutionStart : Maybe Float
    , resolutionStop : Maybe Float
    , resolutionSpan : Maybe Float
    }


type alias Matches =
    { noMatch : Float
    , exactString : Float
    , exactCanonical : Float
    , fuzzy : Float
    , partial : Float
    , partialFuzzy : Float
    , genusOnly : Float
    }


initResolver : Resolver
initResolver =
    Resolver Pending Nothing
