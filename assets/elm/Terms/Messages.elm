module Terms.Messages exposing (Msg(..))

import Http
import Terms.Models exposing (Terms)

type Msg
    = ToDataSources String
    | ToResolver String
    | MapTerm Int String
    | GetTerms (Result Http.Error Terms)
