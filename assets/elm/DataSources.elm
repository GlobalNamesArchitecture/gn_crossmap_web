module DataSources
    exposing
        ( view
        , getDataSources
        , saveDataSource
        , prepareDataSources
        )

import Html exposing (..)
import Html.Attributes exposing (href, type_, name, value, checked)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Common exposing (..)


-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ button [ onClick ToResolver ] [ text "Continue" ]
            ]
        , selectDataSource model
        ]


selectDataSource : Model -> Html Msg
selectDataSource model =
    div [] <|
        List.map
            (dataSourceRender model.selectedDataSource)
            model.dataSources


dataSourceRender : Int -> DataSource -> Html Msg
dataSourceRender selectedDataSource ds =
    div []
        [ input
            [ type_ "radio"
            , name "data_source"
            , value <| toString ds.id
            , checked (checkedDataSource ds selectedDataSource)
            , onClick (SelectDataSource ds.id)
            ]
            []
        , text ds.title
        ]


checkedDataSource : DataSource -> Int -> Bool
checkedDataSource ds selectedDataSource =
    ds.id == selectedDataSource



-- HTTP


getDataSources : ResolverUrl -> Cmd Msg
getDataSources url =
    let
        datasourceUrl =
            url ++ "/data_sources.json"
    in
        Http.send AllDataSources (Http.get datasourceUrl dataSourceDecoder)


prepareDataSources : List DataSource -> List DataSource
prepareDataSources dss =
    List.filter includeDataSource dss


includeDataSource : DataSource -> Bool
includeDataSource ds =
    let
        visibleDataSources =
            [ 1, 2, 3, 4, 5, 8, 9, 11, 12, 167, 169, 172, 173, 174, 175 ]
                ++ [ 177, 179, 180 ]
    in
        List.member ds.id visibleDataSources


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



-- JSON DECODERS


dataSourceDecoder : Decode.Decoder (List DataSource)
dataSourceDecoder =
    Decode.list (Decode.map3 DataSource id title desc)


id : Decode.Decoder Int
id =
    Decode.field "id" Decode.int


title : Decode.Decoder String
title =
    Decode.field "title" Decode.string


desc : Decode.Decoder (Maybe String)
desc =
    Decode.field "description" (Decode.nullable Decode.string)
