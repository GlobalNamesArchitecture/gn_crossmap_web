module View exposing (view)

import Html exposing (..)
import Models exposing (Model)
import Messages exposing (Msg(..))
import Routing as R
import FileUpload.View as FUV
import Terms.View as TV
import DataSource.View as DSV
import DataSource.Helper as DSH
import Resolver.View as RV


view : Model -> Html Msg
view model =
    div [] [ findRoute model ]


findRoute : Model -> Html Msg
findRoute model =
    case model.route of
        R.FileUpload ->
            fileUploadView model

        R.FileTerms token ->
            termsView model token

        R.DataSources token ->
            dataSourceView model token

        R.Resolution token ->
          resolverView model token

        R.NotFoundRoute ->
            text "404 Not found"


fileUploadView : Model -> Html Msg
fileUploadView model =
    Html.map FileUploadMsg (FUV.view model.upload)


termsView : Model -> R.Token -> Html Msg
termsView model token =
    case model.upload.uploadedFile of
        Nothing ->
            div [] []

        Just data ->
            Html.map TermsMsg
                (TV.view model.dataSource.all data)


dataSourceView : Model -> String -> Html Msg
dataSourceView model token =
    Html.map DataSourceMsg
        (DSV.view model.dataSource token)


resolverView : Model -> String -> Html Msg
resolverView model token =
    Html.map ResolverMsg <|
        RV.view model.resolver (DSH.currentDataSourceInfo model.dataSource) 
          model.upload.uploadedFile

