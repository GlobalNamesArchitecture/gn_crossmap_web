module DataSource.Messages exposing (Msg(..))

import Http
import DataSource.Models exposing (DataSources)


type Msg
    = CurrentDataSource String Int
    | SaveDataSource (Result Http.Error ())
    | AllDataSources (Result Http.Error DataSources)
    | ToResolver String
