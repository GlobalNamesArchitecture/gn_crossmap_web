module DataSource.Helper exposing (..)

import Http
import Maybe exposing (withDefault)
import DataSource.Messages exposing (Msg(..))
import DataSource.Decoder exposing (..)
import DataSource.Models
    exposing
        ( DataSource
        , DataSources
        , DataSourceInfo
        )


getDataSources : String -> Cmd Msg
getDataSources url =
    let
        datasourceUrl =
            url ++ "/data_sources.json"
    in
        Http.send AllDataSources (Http.get datasourceUrl dataSourceDecoder)


prepareDataSources : DataSource -> DataSources -> DataSources
prepareDataSources ds dss =
    List.filter (includeDataSource (dataSourceIds ds.all)) dss


dataSourceIds : DataSources -> List Int
dataSourceIds dss =
    List.map (\ds -> ds.id) dss


includeDataSource : List Int -> DataSourceInfo -> Bool
includeDataSource dsIds ds =
    List.member ds.id dsIds


currentDataSourceInfo : DataSource -> DataSourceInfo
currentDataSourceInfo ds =
    let
        default =
            DataSourceInfo 0 Nothing Nothing
    in
        withDefault default <|
            List.head <|
                List.filter (\dsi -> dsi.id == ds.current) ds.all
