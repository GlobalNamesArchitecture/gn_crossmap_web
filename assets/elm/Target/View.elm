module Target.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (checked, type_, name, value)
import Html.Events exposing (onClick)
import Maybe exposing (withDefault)
import Target.Models exposing (Target, DataSources, DataSource)
import Target.Messages exposing (Msg(..))


view : Target -> String -> Html Msg
view ds token =
    div []
        [ div []
            [ button [ onClick <| ToResolver token ] [ text "Continue" ]
            ]
        , selectTarget ds token
        ]


selectTarget : Target -> String -> Html Msg
selectTarget ds token =
    div [] <|
        List.map
            (dataSourceRender token ds.current)
            ds.all


dataSourceRender : String -> Int -> DataSource -> Html Msg
dataSourceRender token current dsi =
    div []
        [ input
            [ type_ "radio"
            , name "data_source"
            , value <| toString dsi.id
            , checked (checkedTarget dsi current)
            , onClick (CurrentTarget token dsi.id)
            ]
            []
        , text <| withDefault "" dsi.title
        ]


checkedTarget : DataSource -> Int -> Bool
checkedTarget dsi current =
    dsi.id == current
