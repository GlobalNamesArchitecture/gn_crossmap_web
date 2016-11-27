module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href)
import Common exposing (..)
import DwcaTerms as Dwca


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Continue ->
            ( { model | state = DataSourcesState }, Cmd.none )


view : Model -> Html Msg
view model =
    case model.state of
        DwcaTermsState ->
            Dwca.view model

        DataSourcesState ->
            p [] [ text "Next step" ]

        _ ->
            Debug.crash "TMP"


main =
    programWithFlags
        { init = Dwca.init
        , subscriptions = Dwca.subscriptions
        , update = update
        , view = view
        }
