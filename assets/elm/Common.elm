module Common exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, type_, value)
import Html.Events exposing (onClick)
import Http


type alias Model =
    { state : State
    , resolverUrl : ResolverUrl
    , token : String
    , server : String
    , headers : Headers
    , rows : Rows
    , dataSources : List DataSource
    , selectedDataSource : Int
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
    , server : String
    , headers : Headers
    , rows : Rows
    }


type alias DataSource =
    { id : Int, title : String, desc : Maybe String }


type Msg
    = ToDataSources
    | ToResolver
    | AllDataSources (Result Http.Error (List DataSource))
    | SelectDataSource Int
    | ResolutionStarted (Result Http.Error String)
