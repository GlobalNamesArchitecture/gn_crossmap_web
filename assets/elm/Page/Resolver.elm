module Page.Resolver exposing (view, startResolution, queryResolutionProgress)

import Html exposing (..)
import Html.Attributes as HA exposing (style, href, alt)
import Http
import Maybe exposing (withDefault)
import Common exposing (..)
import Widget.Pie as Pie
import Widget.Slider as Slider
import Helper.TimeEst as TE
import Decoder.Resolver exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ viewTitle model
        , viewIngestionStage model
        , viewResolutinStage model
        , viewGraph model
        , viewDownload model
        ]


viewDownload : Model -> Html Msg
viewDownload model =
    case (status model) of
        StatusDone ->
            div
                [ HA.style
                    [ ( "clear", "left" )
                    , ( "padding", "2em" )
                    , ( "background-color", "#afa" )
                    , ( "color", "#2c2" )
                    ]
                ]
                [ a
                    [ href (Debug.log "output" model.output)
                    , alt "Download result"
                    , HA.style
                        [ ( "font-size"
                          , "1.5em"
                          )
                        ]
                    ]
                    [ Html.text "Download crossmapping results" ]
                ]

        _ ->
            div [] []


viewIngestionStage : Model -> Html Msg
viewIngestionStage model =
    let
        ingStatus =
            case (status model) of
                StatusPending ->
                    "Pending"

                StatusIngestion ->
                    "In Progress " ++ (eta model True)

                _ ->
                    "Done " ++ (timeSummary model True)
    in
        div []
            [ div []
                [ Html.text <|
                    "Ingestion Status: "
                        ++ ingStatus
                ]
            , Slider.slider (ingestedSliderData model)
            ]


timeSummary : Model -> Bool -> String
timeSummary model isResolution =
    case model.stats of
        Nothing ->
            ""

        Just s ->
            TE.summaryString <| timeEstInput s isResolution


eta : Model -> Bool -> String
eta model isResolution =
    case model.stats of
        Nothing ->
            ""

        Just s ->
            TE.etaString <| TE.estimate <| timeEstInput s isResolution


timeEstInput : Stats -> Bool -> TE.Input
timeEstInput stats isResolution =
    if isResolution then
        TE.ingestionInput stats
    else
        TE.resolutionInput stats


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
                    "In Progress " ++ (eta model False)

                _ ->
                    "Done " ++ (timeSummary model False)
    in
        div []
            [ div []
                [ Html.text <|
                    "ResolutionStatus: "
                        ++ resStatus
                ]
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
            div [] [ Html.text "" ]

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
        , ( "#3f0", m.fuzzy, "Fuzzy match" )
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
            (Http.get url statusDecoder)


queryResolutionProgress : String -> Cmd Msg
queryResolutionProgress token =
    let
        url =
            "/stats/" ++ token
    in
        Http.send ResolutionProgress
            (Http.get url statsDecoder)


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
