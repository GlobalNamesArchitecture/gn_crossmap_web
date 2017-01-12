module Terms.Models exposing (..)


type alias Terms =
    { sampleData : Maybe SampleData }


type alias SampleData =
    { fileName : String
    , output : String
    , headers : List Header
    , rows : List Row
    }


type alias Header =
    { value : String
    , term : Maybe String
    }

type alias Row =
    List (Maybe String)



initTerms : Terms
initTerms =
    Terms Nothing
