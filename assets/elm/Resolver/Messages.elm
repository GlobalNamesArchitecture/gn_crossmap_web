module Resolver.Messages exposing (Msg(..))

import Time
import Http
import Resolver.Models exposing (Stats)


type Msg
    = LaunchResolution (Result Http.Error String)
    | QueryResolutionProgress Time.Time
    | ResolutionProgress (Result Http.Error Stats)
