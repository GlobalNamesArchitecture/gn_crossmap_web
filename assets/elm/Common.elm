module Common exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, type_, value)
import Html.Events exposing (onClick)
import Http
import Time exposing (Time)


type alias Model =
    { state : State
    , resolverUrl : ResolverUrl
    , token : String
    , server : String
    , output : String
    , headers : Headers
    , rows : Rows
    , dataSources : List DataSource
    , selectedDataSource : Int
    , stats : Maybe Stats
    }


type alias ResolverUrl =
    String


type State
    = DwcaTermsState
    | DataSourcesState
    | ResolutionState


type alias Headers =
    List String


type alias Rows =
    List Row


type alias Row =
    List RowEntry


type alias RowEntry =
    Maybe String


type alias Flags =
    { resolverUrl : ResolverUrl
    , token : String
    , output : String
    , server : String
    , headers : Headers
    , rows : Rows
    }


type alias DataSource =
    { id : Int, title : String, desc : Maybe String }


type alias Stats =
    { status : String
    , totalRecords : Int
    , ingestion : IngestionStats
    , resolution : ResolutionStats
    , lastBatchesTime :
        List Float
    , matches : Matches
    , fails : Float
    }


type Status
    = StatusPending
    | StatusIngestion
    | StatusResolution
    | StatusDone
    | StatusUnknown


type alias IngestionStats =
    { ingestedRecords : Int
    , ingestionStart : Maybe Float
    , ingestionSpan : Maybe Float
    }


type alias ResolutionStats =
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


type Msg
    = ToDataSources
    | ToResolver
    | AllDataSources (Result Http.Error (List DataSource))
    | SelectDataSource Int
    | SaveDataSource (Result Http.Error ())
    | LaunchResolution (Result Http.Error String)
    | QueryResolutionProgress Time
    | ResolutionProgress (Result Http.Error Stats)


type alias PieData =
    List PieDatum


type alias PieDatum =
    { color : String
    , value : Float
    , legend : String
    }
