module DwcaTerms exposing (init, view)

import Html exposing (..)
import Html.Attributes exposing (href, type_, value)
import Html.Events exposing (onClick)
import Maybe exposing (withDefault)
import Common exposing (..)
import Helper.DataSource as HDS


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model
        DwcaTermsState
        flags.resolverUrl
        flags.token
        flags.server
        flags.output
        flags.headers
        flags.rows
        (dataSources flags.dataSourceIds)
        (withDefault 1 <| List.head flags.dataSourceIds)
        Nothing
    , HDS.getDataSources flags.resolverUrl
    )


dataSources : List Int -> List DataSource
dataSources dataSourceIds =
    List.map (\id -> DataSource id Nothing Nothing) dataSourceIds


view : Model -> Html Msg
view model =
    let
        token_url =
            "http://" ++ model.server ++ "/crossmaps/" ++ model.token
    in
        div []
            [ a [ href token_url ]
                [ text token_url ]
            , div []
                [ button [ onClick (nextMsg model) ] [ text "Continue" ]
                ]
            , table []
                ((viewHeaders model.headers)
                    :: (viewRows model.rows)
                )
            ]


nextMsg : Model -> Msg
nextMsg model =
    if List.length model.dataSources > 1 then
        ToDataSources
    else
        ToResolver


viewHeaders : Headers -> Html Msg
viewHeaders headers =
    tr [] (List.map viewHeaderEntry headers)


viewHeaderEntry : String -> Html Msg
viewHeaderEntry header =
    th [] [ text header ]


viewRows : Rows -> List (Html Msg)
viewRows rows =
    List.map viewRow rows


viewRow : Row -> Html Msg
viewRow row =
    tr [] (List.map viewRowEntry row)


viewRowEntry : RowEntry -> Html Msg
viewRowEntry re =
    let
        val =
            case re of
                Just entry ->
                    entry

                Nothing ->
                    ""
    in
        td [] [ text val ]
