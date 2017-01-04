module DataSource.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (checked, type_, name, value)
import Html.Events exposing (onClick)
import Maybe exposing (withDefault)
import DataSource.Models exposing (DataSource, DataSources, DataSourceInfo)
import DataSource.Messages exposing (Msg(..))


view : DataSource -> String -> Html Msg
view ds token =
    div []
        [ div []
            [ button [ onClick <| ToResolver token ] [ text "Continue" ]
            ]
        , selectDataSource ds token
        ]


selectDataSource : DataSource -> String -> Html Msg
selectDataSource ds token =
    div [] <|
        List.map
            (dataSourceRender token ds.current)
            ds.all


dataSourceRender : String -> Int -> DataSourceInfo -> Html Msg
dataSourceRender token current dsi =
    div []
        [ input
            [ type_ "radio"
            , name "data_source"
            , value <| toString dsi.id
            , checked (checkedDataSource dsi current)
            , onClick (CurrentDataSource token dsi.id)
            ]
            []
        , text <| withDefault "" dsi.title
        ]


checkedDataSource : DataSourceInfo -> Int -> Bool
checkedDataSource dsi current =
    dsi.id == current
