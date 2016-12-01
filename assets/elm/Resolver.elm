module Resolver exposing (view, startResolution, queryResolutionProgress)

import Html exposing (..)
import Http
import Json.Decode as JD
import Maybe exposing (withDefault)
import Common exposing (..)
import Pie
import Slider


view : Model -> Html Msg
view model =
    div []
        [ viewTitle model
        , viewIngestionStage model
        , viewResolutinStage model
        , viewGraph model
        ]


viewIngestionStage : Model -> Html Msg
viewIngestionStage model =
    let
        ingStatus =
            case (status model) of
                StatusPending ->
                    "Pending"

                StatusIngestion ->
                    "In Progress"

                _ ->
                    "Done"
    in
        div []
            [ div [] [ Html.text <| "Ingestion Status: " ++ ingStatus ]
            , Slider.slider (ingestedSliderData model)
            ]


ingestedSliderData : Model -> Slider.Datum
ingestedSliderData model =
    let
        datum =
            case (status model) of
                StatusPending ->
                    ( 0, 1 )

                StatusIngestion ->
                    sliderData model StatusIngestion

                _ ->
                    ( 1.0, 1 )
    in
        (\( x, y ) -> Slider.Datum x y) datum


sliderData : Model -> Status -> ( Float, Float )
sliderData model st =
    let
        norm =
            (\( x, y ) -> ( (toFloat x) / (toFloat y), 1.0 ))
    in
        case st of
            StatusIngestion ->
                Tuple.first <| normalizedStats model

            StatusResolution ->
                Tuple.second <| normalizedStats model

            _ ->
                ( 0, 1 )


normalizedStats : Model -> ( ( Float, Float ), ( Float, Float ) )
normalizedStats model =
    case model.stats of
        Nothing ->
            ( ( 0, 1 ), ( 0, 1 ) )

        Just x ->
            harvestStats x.ingestion x.resolution x.totalRecords


harvestStats :
    IngestionStats
    -> ResolutionStats
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


viewResolutinStage : Model -> Html Msg
viewResolutinStage model =
    let
        resStatus =
            case (status model) of
                StatusPending ->
                    "Pendig"

                StatusIngestion ->
                    "Pending"

                StatusResolution ->
                    "In Progress"

                _ ->
                    "Done"
    in
        div []
            [ div [] [ Html.text <| "ResolutionStatus: " ++ resStatus ]
            , Slider.slider (resolutionSliderData model)
            ]


resolutionSliderData : Model -> Slider.Datum
resolutionSliderData model =
    let
        datum =
            case (status model) of
                StatusPending ->
                    ( 0, 1 )

                StatusIngestion ->
                    ( 0, 1 )

                StatusResolution ->
                    sliderData model StatusResolution

                _ ->
                    ( 1.0, 1.0 )
    in
        (\( x, y ) -> Slider.Datum x y) datum


viewGraph : Model -> Html Msg
viewGraph model =
    case (chartData model) of
        Nothing ->
            div [] [ Html.text "Graph will be here" ]

        Just m ->
            Pie.pie 200 m


chartData : Model -> Maybe PieData
chartData model =
    case model.stats of
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
                            PieDatum x y z
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
        , ( "#0a0", m.exactString, "Identical" )
        , ( "#0f0", m.exactCanonical, "Canonical match" )
        , ( "#3fa", m.fuzzy, "Fuzzy match" )
        , ( "#8f0", m.partial, "Partial match" )
        , ( "#af0", m.partialFuzzy, "Partial fuzzy match" )
        , ( "#df0", m.genusOnly, "Genus-only match" )
        , ( "#000", fails, "Resolver Errors" )
        ]


viewTitle : Model -> Html Msg
viewTitle model =
    let
        ds =
            dataSource model.dataSources model.selectedDataSource

        title =
            case ds of
                Nothing ->
                    "Unknown"

                Just dataSource ->
                    dataSource.title
    in
        h3 []
            [ Html.text <|
                "Crossmapping your file against \""
                    ++ title
                    ++ "\" checklist"
            ]


startResolution : String -> Cmd Msg
startResolution token =
    let
        url =
            "/resolver/" ++ token
    in
        Http.send LaunchResolution
            (Http.get url
                (JD.field "status" JD.string)
            )


queryResolutionProgress : String -> Cmd Msg
queryResolutionProgress token =
    let
        url =
            "/stats/" ++ token
    in
        Http.send ResolutionProgress
            (Http.get url resolutionStatsDecoder)


dataSource : List DataSource -> Int -> Maybe DataSource
dataSource dss dataSourceId =
    List.head <| List.filter (\ds -> ds.id == dataSourceId) dss


status : Model -> Status
status model =
    case model.stats of
        Nothing ->
            StatusPending

        Just st ->
            setStatus st.status


setStatus : String -> Status
setStatus s =
    if s == "init" then
        StatusPending
    else if s == "ingestion" then
        StatusIngestion
    else if s == "resolution" then
        StatusResolution
    else if s == "finish" then
        StatusDone
    else
        StatusUnknown



-- DECODERS


resolutionStatsDecoder : JD.Decoder Stats
resolutionStatsDecoder =
    JD.map7 Stats
        (JD.at [ "status" ] JD.string)
        (JD.at [ "total_records" ] JD.int)
        ingestion
        resolution
        lastBatchesTime
        matches
        fails


lastBatchesTime : JD.Decoder (List Float)
lastBatchesTime =
    (JD.at [ "last_batches_time" ] (JD.list JD.float))


ingestion : JD.Decoder IngestionStats
ingestion =
    JD.map3 IngestionStats
        (JD.at [ "ingested_records" ] JD.int)
        (JD.at [ "ingestion_start" ] (JD.nullable JD.float))
        (JD.at [ "ingestion_span" ] (JD.nullable JD.float))


resolution : JD.Decoder ResolutionStats
resolution =
    JD.map4 ResolutionStats
        (JD.at [ "resolved_records" ] JD.int)
        (JD.at [ "resolution_start" ] (JD.nullable JD.float))
        (JD.at [ "resolution_stop" ] (JD.nullable JD.float))
        (JD.at [ "resolution_span" ] (JD.nullable JD.float))


matches : JD.Decoder Matches
matches =
    JD.map7 Matches
        (JD.at [ "matches", "0" ] JD.float)
        (JD.at [ "matches", "1" ] JD.float)
        (JD.at [ "matches", "2" ] JD.float)
        (JD.at [ "matches", "3" ] JD.float)
        (JD.at [ "matches", "4" ] JD.float)
        (JD.at [ "matches", "5" ] JD.float)
        (JD.at [ "matches", "6" ] JD.float)


fails : JD.Decoder Float
fails =
    (JD.at [ "matches", "7" ] JD.float)
