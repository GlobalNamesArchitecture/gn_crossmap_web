module Resolver.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing(style, alt, href)
import Maybe exposing (withDefault)
import Terms.Models exposing (SampleData)
import Target.Models exposing (DataSource)
import Resolver.Models
    exposing
        ( Resolver
        , Status(..)
        , Stats
        , Ingestion
        , Resolution
        , Matches
        )
import Resolver.Messages exposing (Msg(..))
import Resolver.Helper as RH
import Widgets.Slider as Slider
import Widgets.Pie as Pie


view : Resolver -> DataSource -> Maybe SampleData -> Html Msg
view resolver ds sample =
    div []
        [ viewTitle resolver ds
        , viewIngestionStage resolver
        , viewResolutinStage resolver
        , viewGraph resolver
        , viewDownload resolver sample
        ]


viewTitle : Resolver -> DataSource -> Html Msg
viewTitle model ds =
    h3 []
        [ Html.text <|
            "Crossmapping your file against \""
                ++ (withDefault "Unknown" ds.title)
                ++ "\" data"
        ]


viewIngestionStage : Resolver -> Html Msg
viewIngestionStage resolver =
    let
        ingStatus =
            case (status resolver) of
                Pending ->
                    "Pending"

                InIngestion ->
                    "In Progress " ++ (eta resolver True)

                _ ->
                    "Done " ++ (timeSummary resolver True)
    in
        div []
            [ div []
                [ Html.text <|
                    "Ingestion Status: "
                        ++ ingStatus
                ]
            , Slider.slider (ingestedSliderData resolver)
            ]


status : Resolver -> Status
status resolver =
    case resolver.stats of
        Nothing ->
            Pending

        Just st ->
            setStatus st.status


setStatus : String -> Status
setStatus s =
    if s == "init" then
        Pending
    else if s == "ingestion" then
        InIngestion
    else if s == "resolution" then
        InResolution
    else if s == "finish" then
        Done
    else
        Unknown


timeSummary : Resolver -> Bool -> String
timeSummary resolver isResolution =
    case resolver.stats of
        Nothing ->
            ""

        Just s ->
            RH.summaryString <| timeEstInput s isResolution


eta : Resolver -> Bool -> String
eta resolver isResolution =
    case resolver.stats of
        Nothing ->
            ""

        Just s ->
            RH.etaString <| RH.estimate <| timeEstInput s isResolution


timeEstInput : Stats -> Bool -> RH.Input
timeEstInput stats isResolution =
    if isResolution then
        RH.ingestionInput stats
    else
        RH.resolutionInput stats


ingestedSliderData : Resolver -> Slider.Datum
ingestedSliderData resolver =
    let
        datum =
            case (status resolver) of
                Pending ->
                    ( 0, 1 )

                InIngestion ->
                    sliderData resolver InIngestion

                _ ->
                    ( 1.0, 1 )
    in
        (\( x, y ) -> Slider.Datum x y) datum


sliderData : Resolver -> Status -> ( Float, Float )
sliderData model st =
    let
        norm =
            (\( x, y ) -> ( (toFloat x) / (toFloat y), 1.0 ))
    in
        case st of
            InIngestion ->
                Tuple.first <| normalizedStats model

            InResolution ->
                Tuple.second <| normalizedStats model

            _ ->
                ( 0, 1 )


normalizedStats : Resolver -> ( ( Float, Float ), ( Float, Float ) )
normalizedStats resolver =
    case resolver.stats of
        Nothing ->
            ( ( 0, 1 ), ( 0, 1 ) )

        Just x ->
            harvestStats x.ingestion x.resolution x.totalRecords


harvestStats :
    Ingestion
    -> Resolution
    -> Int
    -> ( ( Float, Float ), ( Float, Float ) )
harvestStats i r t =
    let
        iPart =
            toFloat i.ingestedRecords

        rPart =
            toFloat r.resolvedRecords

        total =
            toFloat t
    in
        ( ( iPart, total ), ( rPart, total ) )


viewResolutinStage : Resolver -> Html Msg
viewResolutinStage resolver =
    let
        resStatus =
            case (status resolver) of
                Pending ->
                    "Pendig"

                InIngestion ->
                    "Pending"

                InResolution ->
                    "In Progress " ++ (eta resolver False)

                _ ->
                    "Done " ++ (timeSummary resolver False)
    in
        div []
            [ div []
                [ Html.text <|
                    "ResolutionStatus: "
                        ++ resStatus
                ]
            , Slider.slider (resolutionSliderData resolver)
            ]


resolutionSliderData : Resolver -> Slider.Datum
resolutionSliderData resolver =
    let
        datum =
            case (status resolver) of
                Pending ->
                    ( 0, 1 )

                InIngestion ->
                    ( 0, 1 )

                InResolution ->
                    sliderData resolver InResolution

                _ ->
                    ( 1.0, 1.0 )
    in
        (\( x, y ) -> Slider.Datum x y) datum


viewGraph : Resolver -> Html Msg
viewGraph resolver =
    case (chartData resolver) of
        Nothing ->
            div [] [ Html.text "" ]

        Just m ->
            Pie.pie 200 m


chartData : Resolver -> Maybe Pie.PieData
chartData resolver =
    case resolver.stats of
        Nothing ->
            Nothing

        Just s ->
            let
                res =
                    List.filter (\( _, x, _ ) -> x > 0.05) <|
                        matchesList
                            s.totalRecords
                            s.matches
                            s.fails

                cd =
                    List.map
                        (\( x, y, z ) ->
                            Pie.PieDatum x y z
                        )
                        res
            in
                if (List.isEmpty cd) then
                    Nothing
                else
                    (Just cd)


matchesList :
    Int
    -> Matches
    -> Float
    -> List ( String, Float, String )
matchesList total matches fails =
    let
        m =
            matches
    in
        [ ( "#a00", m.noMatch, "No match" )
        , ( "#080", m.exactString, "Identical" )
        , ( "#0f0", m.exactCanonical, "Canonical match" )
        , ( "#8f0", m.fuzzy, "Fuzzy match" )
        , ( "#aa8", m.partial, "Partial match" )
        , ( "#880", m.partialFuzzy, "Partial fuzzy match" )
        , ( "#440", m.genusOnly, "Genus-only match" )
        , ( "#000", fails, "Resolver Errors" )
        ]


viewDownload : Resolver -> Maybe SampleData -> Html Msg
viewDownload resolver sample =
    case (status resolver) of
        Done ->
            showOutput sample

        _ ->
            div [] []


showOutput : Maybe SampleData -> Html Msg
showOutput sample =
    case sample of
        Nothing ->
            div [] []

        Just sd ->
            div
                [ style
                    [ ( "clear", "left" )
                    , ( "padding", "2em" )
                    , ( "background-color", "#afa" )
                    , ( "color", "#2c2" )
                    ]
                ]
                [ a
                    [ href <| sd.output
                    , alt "Download result"
                    , style
                        [ ( "font-size"
                          , "1.5em"
                          )
                        ]
                    ]
                    [ Html.text "Download crossmapping results" ]
                ]
