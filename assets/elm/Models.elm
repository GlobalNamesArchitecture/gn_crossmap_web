module Models exposing (Model, Flags, initModel)

import Maybe exposing (withDefault)
import Routing
import FileUpload.Models exposing (Upload, initUpload)
import Terms.Models exposing (Terms, initTerms)
import DataSource.Models exposing (DataSource, initDataSource)
import Resolver.Models exposing (Resolver, initResolver)


type alias Model =
    { route : Routing.Route
    , resolverUrl : String
    , localDomain : String
    , token : Maybe String
    , upload : Upload
    , terms : Terms
    , dataSource : DataSource
    , resolver : Resolver
    }


type alias Flags =
    { resolverUrl : String
    , localDomain : String
    , dataSourcesIds : List Int
    }


initModel : Flags -> Routing.Route -> Model
initModel flags route =
    Model route
        flags.resolverUrl
        flags.localDomain
        Nothing
        initUpload
        initTerms
        (initDataSource flags.dataSourcesIds)
        initResolver
