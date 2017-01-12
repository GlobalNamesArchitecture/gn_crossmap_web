module Terms.Decoder exposing (..)

import Terms.Models
    exposing
        ( SampleData
        , Header
        , Row
        )
import Json.Decode as J


sampleDataDecoder : J.Decoder SampleData
sampleDataDecoder =
    J.map4 SampleData
      (J.at ["filename"] J.string)
      (J.at ["output"] J.string)
      headers 
      rows


headers : J.Decoder (List Header)
headers =
    J.at ["input_sample", "headers"] <|
      J.list <| J.map (\header -> Header header Nothing) J.string


rows : J.Decoder (List Row)
rows =
    J.at ["input_sample", "rows"] <| J.list row


row : J.Decoder Row
row =
    J.list (J.nullable J.string)
