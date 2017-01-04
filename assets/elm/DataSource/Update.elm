module DataSource.Update exposing (update)

import Navigation exposing (newUrl)
import Json.Encode as Encode
import Http
import DataSource.Models exposing (DataSource)
import DataSource.Messages exposing (Msg(..))
import DataSource.Helper as HDS


update : Msg -> DataSource -> ( DataSource, Cmd Msg )
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

        CurrentDataSource token current ->
            ( { ds | current = current }, saveDataSource token current )

        SaveDataSource (Ok _) ->
            ( ds, Cmd.none )

        SaveDataSource (Err _) ->
            ( ds, Cmd.none )


saveDataSource : String -> Int -> Cmd Msg
saveDataSource token dataSourceId =
    let
        url =
            "/crossmaps"
    in
        Http.send SaveDataSource
            (put url <| body token dataSourceId)


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
body token dataSourceId =
    Http.jsonBody <|
        Encode.object
            [ ( "token", Encode.string token )
            , ( "data_source_id", Encode.int dataSourceId )
            ]
