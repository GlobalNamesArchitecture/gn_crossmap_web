module Terms.Helper exposing (getTerms)

import Http
import Terms.Models exposing (SampleData)
import Terms.Messages exposing (Msg(..))
import Terms.Decoder exposing (sampleDataDecoder)


getTerms : String -> Cmd Msg
getTerms token =
    let
        url =
            "/crossmaps/" ++ token
    in
        Http.send GetSampleData
            (Http.get url sampleDataDecoder)
