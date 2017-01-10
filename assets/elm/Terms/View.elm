module Terms.View exposing (view)

import Html exposing (..)
import Html.Events exposing (onClick)
import FileUpload.Models as FUM
import Terms.Models exposing (Terms)
import Terms.Messages exposing (Msg(..))
import Target.Models exposing (DataSources)


view : DataSources -> FUM.UploadedFileData -> Html Msg
view ds data =
    div []
        [ button [ onClick (nextMsg ds data.token) ] [ text "Continue" ]
        , table [] <| (viewHeaders data.headers) :: (viewRows data.rows)
        ]


nextMsg : DataSources -> String -> Msg
nextMsg ds token =
    if List.length ds > 1 then
        ToDataSources token
    else
        ToResolver token


viewHeaders : FUM.Headers -> Html Msg
viewHeaders headers =
    tr [] (List.map viewHeaderEntry headers)


viewHeaderEntry : String -> Html Msg
viewHeaderEntry header =
    th [] [ text header ]


viewRows : FUM.Rows -> List (Html Msg)
viewRows rows =
    List.map viewRow rows


viewRow : FUM.Row -> Html Msg
viewRow row =
    tr [] (List.map viewRowEntry row)


viewRowEntry : FUM.RowEntry -> Html Msg
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
