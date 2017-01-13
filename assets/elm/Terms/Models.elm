module Terms.Models exposing (..)


type alias Terms =
    { output : String
    , headers : List Header
    , rows : List Row
    }


type alias Header =
    { id : Int
    , value : String
    , term : Maybe String
    }

type alias Row =
    List (Maybe String)



initTerms : Terms
initTerms =
    Terms "Unknown" [] []
