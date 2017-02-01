module View exposing (view)

import Html exposing (..)
import Models exposing (Model)
import Messages exposing (Msg(..))
import Routing as R
import FileUpload.View as FUV
import Terms.View as TV
import Target.View as DSV
import Target.Helper as DSH
import Resolver.View as RV
import Widgets.BreadCrumbs as BC


view : Model -> Html Msg
view model =
    div [] 
    [ BC.view model
    , findRoute model
    ]


findRoute : Model -> Html Msg
findRoute model =
    case model.route of
        R.FileUpload ->
            fileUploadView model

        R.Terms token ->
            termsView model token

        R.Target token ->
            dataSourceView model token

        R.Resolver token ->
            resolverView model token

        R.NotFoundRoute ->
            text "404 Not found"


fileUploadView : Model -> Html Msg
fileUploadView model =
    Html.map FileUploadMsg (FUV.view model.upload)


termsView : Model -> R.Token -> Html Msg
termsView model token =
    Html.map TermsMsg
        (TV.view model.target.all model.terms token)


dataSourceView : Model -> String -> Html Msg
dataSourceView model token =
    Html.map TargetMsg
        (DSV.view model.target token)


resolverView : Model -> String -> Html Msg
resolverView model token =
    Html.map ResolverMsg <|
        RV.view model.resolver
            (DSH.currentTarget model.target)
            model.terms
