module Terms.Decoder exposing (..)

import Result
import Terms.Models
    exposing
        ( Terms
        , Header
        , Row
        )
import Json.Decode as J


termsDecoder : J.Decoder Terms
termsDecoder =
    J.map3 Terms
        (J.at [ "output" ] J.string)
        headers
        rows


headers : J.Decoder (List Header)
headers =
    let
        hDecoder =
            J.at [ "input_sample", "headers" ] <| J.list J.string
    in
        hDecoder |> J.andThen indexHeaders


indexHeaders : List String -> J.Decoder (List Header)
indexHeaders headers =
    J.succeed <| List.indexedMap (\i h -> Header (i + 1) h Nothing) headers


rows : J.Decoder (List Row)
rows =
    J.at [ "input_sample", "rows" ] <| J.list row


row : J.Decoder Row
row =
    J.list (J.nullable J.string)
