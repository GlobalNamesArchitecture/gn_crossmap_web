module Common exposing (..)


type alias Model =
    { state : State
    , token : String
    , server : String
    , headers : Headers
    , rows : Rows
    }


type State
    = DwcaTermsState
    | DataSourcesState
    | ReconciliationState


type alias Headers =
    List String


type alias Rows =
    List Row


type alias Row =
    List RowEntry


type alias RowEntry =
    Maybe String


type alias Flags =
    { token : String
    , server : String
    , headers : Headers
    , rows : Rows
    }


type Msg
    = Continue
