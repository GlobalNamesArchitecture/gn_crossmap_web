module Page.DataSources
    exposing
        ( view
        , saveDataSource
        )

import Html exposing (..)
import Html.Attributes exposing (href, type_, name, value, checked)
import Html.Events exposing (onClick)
import Http
import Maybe exposing (withDefault)
import Json.Encode as Encode
import Common exposing (..)
import Decoder.DataSource exposing (dataSourceDecoder)


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
        , text <| withDefault "" ds.title
        ]


checkedDataSource : DataSource -> Int -> Bool
checkedDataSource ds selectedDataSource =
    ds.id == selectedDataSource


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
