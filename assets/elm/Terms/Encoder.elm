module Terms.Encoder exposing (termsBodyEncoder)

import Json.Encode exposing (..)


termsBodyEncoder : String -> List String -> Value
termsBodyEncoder token terms =
    object
        [ ( "token", string token )
        , ( "terms", termsEncoder terms )
        ]


termsEncoder : List String -> Value
termsEncoder terms =
    list <| List.map (\t -> string t) terms
