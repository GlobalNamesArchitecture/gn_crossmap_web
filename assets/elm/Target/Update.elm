module Target.Update exposing (update)

import Navigation exposing (newUrl)
import Json.Encode as Encode
import Http
import Target.Models exposing (Target)
import Target.Messages exposing (Msg(..))
import Target.Helper as HDS


update : Msg -> Target -> ( Target, Cmd Msg )
update msg ds =
    case msg of
        AllDataSources (Ok dss) ->
            ( { ds | all = HDS.prepareDataSources ds dss }
            , Cmd.none
            )

        AllDataSources (Err _) ->
            ( ds, Cmd.none )

        ToResolver token ->
            ( ds, newUrl <| "/#resolver/" ++ token )

        CurrentTarget token current ->
            ( { ds | current = current }, saveTarget token current )

        SaveTarget (Ok _) ->
            ( ds, Cmd.none )

        SaveTarget (Err _) ->
            ( ds, Cmd.none )


saveTarget : String -> Int -> Cmd Msg
saveTarget token targetId =
    let
        url =
            "/target"
    in
        Http.send SaveTarget
            (put url <| body token targetId)


put : String -> Http.Body -> Http.Request ()
put url body =
    Http.request
        { method = "PUT"
        , headers = []
        , url = url
        , body = body
        , expect = Http.expectStringResponse (\_ -> Ok ())
        , timeout = Nothing
        , withCredentials = False
        }


body : String -> Int -> Http.Body
body token targetId =
    Http.jsonBody <|
        Encode.object
            [ ( "token", Encode.string token )
            , ( "data_source_id", Encode.int targetId )
            ]
