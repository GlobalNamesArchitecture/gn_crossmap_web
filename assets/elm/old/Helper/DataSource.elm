module Helper.DataSource exposing (..)

import Common exposing (..)
import Http
import Decoder.DataSource exposing (..)


getDataSources : ResolverUrl -> Cmd Msg
getDataSources url =
    let
        datasourceUrl =
            url ++ "/data_sources.json"
    in
        Http.send AllDataSources (Http.get datasourceUrl dataSourceDecoder)


prepareDataSources : Model -> List DataSource -> List DataSource
prepareDataSources model dss =
    List.filter (includeDataSource (dataSourceIds model.dataSources)) dss


dataSourceIds : List DataSource -> List Int
dataSourceIds dss =
    List.map (\ds -> ds.id) dss


includeDataSource : List Int -> DataSource -> Bool
includeDataSource dsIds ds =
    List.member ds.id dsIds
