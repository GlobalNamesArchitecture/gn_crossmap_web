module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)


type alias Token =
    String


type Route
    = FileUpload
    | FileTerms Token
    | Target Token
    | Resolver Token
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map FileUpload top
        , map FileTerms (s "terms" </> string)
        , map Target (s "target" </> string)
        , map Resolver (s "resolver" </> string)
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
