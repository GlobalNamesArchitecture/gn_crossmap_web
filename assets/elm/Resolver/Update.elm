module Resolver.Update exposing (update)

import Resolver.Models exposing (..)
import Resolver.Helper as RH
import Resolver.Messages exposing (Msg(..))


update : Msg -> Resolver -> String -> ( Resolver, Cmd Msg )
update msg resolver token =
    case msg of
        LaunchResolution (Ok _) ->
            ( resolver, Cmd.none )

        LaunchResolution (Err _) ->
            ( resolver, Cmd.none )

        QueryResolutionProgress _ ->
            ( resolver, RH.queryResolutionProgress token )

        ResolutionProgress (Ok stats) ->
            ( { resolver | stats = Just stats }, Cmd.none )

        ResolutionProgress (Err _) ->
            ( resolver, Cmd.none )
