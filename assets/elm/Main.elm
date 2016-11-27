module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href)
import Http
import Common exposing (..)
import DwcaTerms as Dwca
import DataSources as DS


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToDataSources ->
            ( { model | state = DataSourcesState }
            , DS.getDataSources model.resolverUrl
            )

        ToResolver ->
            ( { model | state = ResolutionState }
            , Cmd.none
            )

        AllDataSources (Ok ds) ->
            ( { model | dataSources = DS.prepareDataSources ds }, Cmd.none )

        AllDataSources (Err _) ->
            ( model, Cmd.none )

        SelectDataSource dsId ->
            ( { model | selectedDataSource = dsId }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    case model.state of
        DwcaTermsState ->
            Dwca.view model

        DataSourcesState ->
            DS.view model

        ResolutionState ->
            Html.text <| toString model.selectedDataSource


main =
    programWithFlags
        { init = Dwca.init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
