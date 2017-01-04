module Terms.Models exposing (..)


type alias Terms =
    { inputSample : Maybe InputSample }


type alias InputSample =
    { headers : List String
    , rows : List String
    }


initTerms : Terms
initTerms =
    Terms Nothing
