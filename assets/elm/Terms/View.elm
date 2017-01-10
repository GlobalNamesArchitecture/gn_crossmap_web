module Terms.View exposing (view)

import Html exposing (..)
import Html.Events exposing (onClick, on)
import Html.Attributes exposing (class, value, id, name, list)
import Maybe exposing (withDefault)
import Json.Decode as J
import FileUpload.Models as FUM
import Terms.Models exposing (Terms)
import Terms.Messages exposing (Msg(..))
import Target.Models exposing (DataSources)


rankFields : List String
rankFields =
    [ "kingdom"
    , "subKingdom"
    , "phylum"
    , "subPhylum"
    , "superClass"
    , "class"
    , "subClass"
    , "cohort"
    , "superOrder"
    , "order"
    , "subOrder"
    , "infraOrder"
    , "superFamily"
    , "family"
    , "subFamily"
    , "tribe"
    , "subTribe"
    , "genus"
    , "subGenus"
    , "section"
    , "species"
    , "subSpecies"
    , "variety"
    , "form"
    ]


coreFields : List String
coreFields =
    [ "taxonId", "scientificName", "scientificNameAuthorship" ]


allFields =
    coreFields ++ rankFields


view : DataSources -> FUM.UploadedFileData -> Html Msg
view ds data =
    div []
        [ button [ onClick (nextMsg ds data.token) ] [ text "Continue" ]
        , div [ (class "terms_table_container") ]
            [ table [ class "terms_table" ] <|
                (viewHeaders data.headers)
                    :: ((viewSelectors data.headers) :: (viewRows data.rows))
            ]
        ]


nextMsg : DataSources -> String -> Msg
nextMsg ds token =
    if List.length ds > 1 then
        ToDataSources token
    else
        ToResolver token


viewSelectors : FUM.Headers -> Html Msg
viewSelectors headers =
    tr [] (List.map viewSelector headers)


viewSelector : String -> Html Msg
viewSelector _ =
    td []
        [ text "match with"
        , br [] []
        , input [ list "terms", name "term" ] []
        , datalist
            [ id "terms"
            , on "change"
                (J.map HeaderMap  <| J.at ["name"] J.string )
            ]
          <|
            List.map dropDownEntry allFields
        ]


dropDownEntry : String -> Html Msg
dropDownEntry field =
    option [ value field ] []


viewHeaders : FUM.Headers -> Html Msg
viewHeaders headers =
    tr [] (List.map viewHeaderEntry headers)


viewHeaderEntry : String -> Html Msg
viewHeaderEntry header =
    th [ headerClass header ] [ text header ]


headerClass : String -> Attribute msg
headerClass header =
    if (headerKnown header) then
        class "dwca"
    else
        class "no_dwca"


headerKnown : String -> Bool
headerKnown header =
    let
        rank =
            List.filter
                (\r -> (normalize r) == (normalize header) && r /= "")
                allFields
    in
        rank /= []


normalize : String -> String
normalize word =
    word
        |> String.split ":"
        |> List.reverse
        |> List.head
        |> withDefault ""
        |> String.split "/"
        |> List.reverse
        |> List.head
        |> withDefault ""
        |> String.toLower


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
