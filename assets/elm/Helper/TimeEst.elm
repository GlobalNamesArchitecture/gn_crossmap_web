module Helper.TimeEst exposing (..)

-- exposing
--     ( Input
--     , estimate
--     , ingestionInput
--     , resolutionInput
--     , etaString
--     )

import Maybe exposing (withDefault, andThen)
import Common exposing (..)


type alias Input =
    { total : Int, processed : Int, timeSpan : Int, velocity : List Velocity }


type alias Velocity =
    { recordsNum : Int, timeSpan : Float }


type alias WaitTime =
    { h : Int, m : Int, s : Int }


type alias Estimate =
    { namesPerSec : Float, eta : Int, etaFormatted : WaitTime }


estimate : Input -> Estimate
estimate input =
    let
        namesPerSec =
            normalizeVelocity input.velocity

        eta =
            round <|
                (toFloat (input.total - input.processed))
                    / namesPerSec
    in
        Estimate namesPerSec eta (hrMinSec <| hmsEta eta [ 3600, 60, 1 ] [])


etaString : Estimate -> String
etaString est =
    let
        t =
            est.etaFormatted
    in
        "("
            ++ (toString (floor est.namesPerSec))
            ++ " names/sec, Est. wait: "
            ++ (toString t.h)
            ++ "h, "
            ++ (toString t.m)
            ++ "m, "
            ++ (toString t.s)
            ++ "s)"


ingestionInput : Stats -> Input
ingestionInput s =
    let
        total =
            s.totalRecords

        processed =
            s.ingestion.ingestedRecords

        vel =
            Velocity processed (withDefault 0 s.ingestion.ingestionSpan)

        timeSpan =
            case s.resolution.resolutionStart of
                Nothing ->
                    maybeSubtract
                        s.ingestion.ingestionSpan
                        s.ingestion.ingestionStart

                Just ingestionEnd ->
                    maybeSubtract
                        s.resolution.resolutionStart
                        s.ingestion.ingestionStart
    in
        Input total processed timeSpan [ vel ]


summaryString : Input -> String
summaryString input =
    let
        hms =
            hrMinSec <| hmsEta input.timeSpan [ 3600, 60, 1 ] []
    in
        "("
            ++ "Processed "
            ++ (toString input.total)
            ++ " names in "
            ++ (toString hms.h)
            ++ "h, "
            ++ (toString hms.m)
            ++ "m, "
            ++ (toString hms.s)
            ++ "s)"


resolutionInput : Stats -> Input
resolutionInput s =
    let
        total =
            s.totalRecords

        processed =
            s.resolution.resolvedRecords

        timeSpan =
            maybeSubtract
                (resSpan s)
                s.resolution.resolutionStart

        vel =
            List.map (\t -> Velocity 200 t) s.lastBatchesTime
    in
        Input total processed timeSpan vel



-- PRIVATE


resSpan : Stats -> Maybe Float
resSpan s =
    List.maximum <|
        (withDefault 0 s.resolution.resolutionStop)
            :: s.lastBatchesTime


maybeSubtract : Maybe Float -> Maybe Float -> Int
maybeSubtract a b =
    let
        a_ =
            withDefault 0 a

        b_ =
            withDefault 0 b

        res =
            round <| a_ - b_
    in
        if res > 0 then
            res
        else
            0


normalizeVelocity : List Velocity -> Float
normalizeVelocity vs =
    let
        vSum =
            List.foldr
                (\v a -> (toFloat v.recordsNum / v.timeSpan) + a)
                0
                vs
    in
        vSum / (toFloat <| List.length vs)


hrMinSec : List Int -> WaitTime
hrMinSec smh =
    let
        hr =
            withDefault 0 <| List.head <| List.drop 2 smh

        min =
            withDefault 0 <| List.head <| List.drop 1 smh

        sec =
            withDefault 0 <| List.head smh
    in
        WaitTime hr min sec


hmsEta : Int -> List Int -> List Int -> List Int
hmsEta eta hms res =
    case hms of
        [] ->
            res

        x :: xs ->
            let
                split =
                    splitEta eta x
            in
                hmsEta (Tuple.second split) xs ((Tuple.first split) :: res)


splitEta : Int -> Int -> ( Int, Int )
splitEta eta span =
    let
        spanUnits =
            eta // span

        reminder =
            rem eta span
    in
        ( spanUnits, reminder )
