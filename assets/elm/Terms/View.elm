module Terms.View exposing (view)

import Html exposing (..)
import Html.Events exposing (onClick, on)
import Html.Attributes exposing (class, value, id, name, list)
import Maybe exposing (withDefault)
import Json.Decode as J
import Terms.Models exposing (Terms, SampleData, Header, Row)
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


view : DataSources -> SampleData -> String -> Html Msg
view ds data token =
    div []
        [ button [ onClick (nextMsg ds token) ] [ text "Continue" ]
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


viewSelectors : (List Header) -> Html Msg
viewSelectors headers =
    tr [] (List.map viewSelector headers)


viewSelector : Header -> Html Msg
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


viewHeaders : (List Header) -> Html Msg
viewHeaders headers =
    tr [] (List.map viewHeaderEntry headers)


viewHeaderEntry : Header -> Html Msg
viewHeaderEntry header =
    th [ headerClass header.value ] [ text header.value ]


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


viewRows : List Row -> List (Html Msg)
viewRows rows =
    List.map viewRow rows


viewRow : Row -> Html Msg
viewRow row =
    tr [] (List.map viewRowEntry row)


viewRowEntry : (Maybe String) -> Html Msg
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
