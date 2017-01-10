module Terms.Models exposing (..)


type alias Terms =
    { inputSample : Maybe InputSample }


type alias InputSample =
    { headers : List Header
    , rows : List String
    }


type alias Header =
    { header : String
    , term : Maybe String
    }


initTerms : Terms
initTerms =
    Terms Nothing
