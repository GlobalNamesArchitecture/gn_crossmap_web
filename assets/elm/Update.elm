module Update exposing (update)

import Maybe exposing (withDefault)
import Messages exposing (Msg(..))
import Models exposing (Model)
import Navigation exposing (Location)
import Routing exposing (Route(..))
import FileUpload.Messages as FUM
import FileUpload.Update as FUU
import Terms.Messages as TM
import Terms.Update as TU
import DataSource.Messages as DSM
import DataSource.Update as DSU
import DataSource.Helper as DSH
import Resolver.Messages as RM
import Resolver.Update as RU
import Resolver.Helper as RH


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange location ->
            updateRoute location model

        FileUploadMsg msg ->
            updateUpload msg model

        TermsMsg msg ->
            updateTerms msg model

        DataSourceMsg msg ->
            updateDataSource msg model

        ResolverMsg msg ->
            updateResolver msg model


updateRoute : Location -> Model -> ( Model, Cmd Msg )
updateRoute location model =
    let
        newRoute =
            Routing.parseLocation location

        command =
            routingCommand model newRoute
    in
        ( { model | route = newRoute }, command )


routingCommand : Model -> Route -> Cmd Msg
routingCommand model route =
    case route of
        DataSources _ ->
            Cmd.map DataSourceMsg <| DSH.getDataSources model.resolverUrl

        Resolution token ->
            Cmd.map ResolverMsg <| RH.startResolution token

        _ ->
            Cmd.none


updateUpload : FUM.Msg -> Model -> ( Model, Cmd Msg )
updateUpload msg model =
    let
        ( uploadModel, uploadCmd ) =
            FUU.update msg model.upload
    in
        ( { model | upload = uploadModel }, Cmd.map FileUploadMsg uploadCmd )


updateTerms : TM.Msg -> Model -> ( Model, Cmd Msg )
updateTerms msg model =
    let
        ( termsModel, termsCmd ) =
            TU.update msg model.terms
    in
        ( { model | terms = termsModel }, Cmd.map TermsMsg termsCmd )


updateDataSource : DSM.Msg -> Model -> ( Model, Cmd Msg )
updateDataSource msg model =
    let
        ( dataSourceModel, dataSourceCmd ) =
            DSU.update msg model.dataSource
    in
        ( { model | dataSource = dataSourceModel }
        , Cmd.map DataSourceMsg dataSourceCmd
        )


updateResolver : RM.Msg -> Model -> ( Model, Cmd Msg )
updateResolver msg model =
    let
        token =
            case model.upload.uploadedFile of
                Nothing ->
                    ""

                Just f ->
                    f.token

        ( resolverModel, resolverCmd ) =
            RU.update msg model.resolver token
    in
        ( { model | resolver = resolverModel }
        , Cmd.map ResolverMsg resolverCmd
        )
