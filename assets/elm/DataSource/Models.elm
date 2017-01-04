module DataSource.Models exposing (..)

import Maybe exposing (withDefault)


type alias DataSource =
    { all : DataSources
    , current : Int
    }


type alias DataSources =
    List DataSourceInfo


type alias DataSourceInfo =
    { id : Int, title : Maybe String, desc : Maybe String }


initDataSource : List Int -> DataSource
initDataSource dss =
    let
        current =
            withDefault 1 <| List.head dss

        infos =
            List.map (\id -> DataSourceInfo id Nothing Nothing) dss
    in
        DataSource infos current
