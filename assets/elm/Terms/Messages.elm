module Terms.Messages exposing (Msg(..))

import Http
import Terms.Models exposing (SampleData)

type Msg
    = ToDataSources String
    | ToResolver String
    | HeaderMap String
    | GetSampleData (Result Http.Error SampleData)
