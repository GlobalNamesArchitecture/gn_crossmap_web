module Target.Helper exposing (..)

import Http
import Maybe exposing (withDefault)
import Target.Messages exposing (Msg(..))
import Target.Decoder exposing (..)
import Target.Models
    exposing
        ( Target
        , DataSources
        , DataSource
        )


getDataSources : String -> Cmd Msg
getDataSources url =
    let
        datasourceUrl =
            url ++ "/data_sources.json"
    in
        Http.send AllDataSources (Http.get datasourceUrl dataSourceDecoder)


prepareDataSources : Target -> DataSources -> DataSources
prepareDataSources ds dss =
    List.filter (includeTarget (dataSourceIds ds.all)) dss


dataSourceIds : DataSources -> List Int
dataSourceIds dss =
    List.map (\ds -> ds.id) dss


includeTarget : List Int -> DataSource -> Bool
includeTarget dsIds ds =
    List.member ds.id dsIds


currentTarget: Target -> DataSource
currentTarget ds =
    let
        default =
            DataSource 0 Nothing Nothing
    in
        withDefault default <|
            List.head <|
                List.filter (\dsi -> dsi.id == ds.current) ds.all
