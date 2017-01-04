module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href)
import Http
import Time exposing (Time, second)
import Common exposing (..)
import Helper.DataSource as HDS
import Page.DwcaTerms as Dwca
import Page.DataSources as DS
import Page.Resolver as R


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AllDataSources (Ok ds) ->
            ( { model | dataSources = HDS.prepareDataSources model ds }
            , Cmd.none
            )

        AllDataSources (Err _) ->
            ( model, Cmd.none )

        ToDataSources ->
            ( { model | state = DataSourcesState }
            , Cmd.none
            )

        SelectDataSource dsId ->
            ( { model | selectedDataSource = dsId }
            , DS.saveDataSource model.token dsId
            )

        SaveDataSource (Ok _) ->
            ( model, Cmd.none )

        SaveDataSource (Err _) ->
            ( model, Cmd.none )

        ToResolver ->
            ( { model | state = ResolutionState }
            , R.startResolution model.token
            )

        LaunchResolution (Ok _) ->
            ( model, Cmd.none )

        LaunchResolution (Err _) ->
            ( model, Cmd.none )

        QueryResolutionProgress _ ->
            ( model, R.queryResolutionProgress model.token )

        ResolutionProgress (Ok stats) ->
            ( { model | stats = Just stats }, Cmd.none )

        ResolutionProgress (Err _) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.state of
        ResolutionState ->
            Time.every (second * 2) QueryResolutionProgress

        _ ->
            Sub.none


view : Model -> Html Msg
view model =
    case model.state of
        DwcaTermsState ->
            Dwca.view model

        DataSourcesState ->
            DS.view model

        ResolutionState -:>
            R.view model


main =
    programWithFlags
        { init = Dwca.init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
