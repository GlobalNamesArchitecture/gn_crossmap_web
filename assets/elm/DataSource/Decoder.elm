module DataSource.Decoder exposing (dataSourceDecoder)

import Json.Decode exposing (Decoder, field, list, map3, int, string, nullable)
import DataSource.Models exposing (DataSources, DataSourceInfo)


dataSourceDecoder : Decoder DataSources
dataSourceDecoder =
    list (map3 DataSourceInfo id title desc)


id : Decoder Int
id =
    field "id" int


title : Decoder (Maybe String)
title =
    field "title" (nullable string)


desc : Decoder (Maybe String)
desc =
    field "description" (nullable string)
