module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)


type alias Token =
    String


type Route
    = FileUpload
    | FileTerms Token
    | DataSources Token
    | Resolution Token
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map FileUpload top
        , map FileTerms (s "terms" </> string)
        , map DataSources (s "data_sources" </> string)
        , map Resolution (s "resolver" </> string)
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
