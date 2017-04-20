module Terms.Models exposing (..)

import Errors exposing (Errors)

type alias Terms =
    { output : String
    , headers : List Header
    , rows : List Row
    , headerState: Maybe HeaderState
    , errors : Errors
    }


type alias Header =
    { id : Int
    , value : String
    , term : Maybe String
    }


type alias Row =
    List (Maybe String)

type alias HeaderState =
  { uniqScientificName : Bool
  , uniqueCladeName: Bool
  , snAuthorship: Bool
  , uniqueSNAuthorship: Bool
  }

initTerms : Terms
initTerms =
    Terms "Unknown" [] [] Nothing Nothing


rankFields : List String
rankFields =
    [ "kingdom"
    , "subKingdom"
    , "phylum"
    , "subPhylum"
    , "superClass"
    , "class"
    , "subClass"
    , "cohort"
    , "superOrder"
    , "order"
    , "subOrder"
    , "infraOrder"
    , "superFamily"
    , "family"
    , "subFamily"
    , "tribe"
    , "subTribe"
    , "genus"
    , "subGenus"
    , "section"
    , "species"
    , "subSpecies"
    , "variety"
    , "form"
    ]


coreFields : List String
coreFields =
    [ "taxonId", "taxonrank", "scientificName", "scientificNameAuthorship" ]


allFields =
    coreFields ++ rankFields
