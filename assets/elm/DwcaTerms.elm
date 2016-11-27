module DwcaTerms exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, type_, value)
import Html.Events exposing (onClick)
import Common exposing (..)


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model
        DwcaTermsState
        flags.token
        flags.server
        flags.headers
        flags.rows
    , Cmd.none
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Continue ->
            ( { model | state = DataSourcesState }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        token_url =
            "http://" ++ model.server ++ "/crossmaps/" ++ model.token
    in
        div []
            [ a [ href token_url ]
                [ text token_url ]
            , div []
                [ button [ onClick Continue ] [ text "Continue" ]
                ]
            , table []
                ((viewHeaders model.headers)
                    :: (viewRows model.rows)
                )
            ]


viewHeaders : Headers -> Html Msg
viewHeaders headers =
    tr [] (List.map viewHeaderEntry headers)


viewHeaderEntry : String -> Html Msg
viewHeaderEntry header =
    th [] [ text header ]


viewRows : Rows -> List (Html Msg)
viewRows rows =
    List.map viewRow rows


viewRow : Row -> Html Msg
viewRow row =
    tr [] (List.map viewRowEntry row)


viewRowEntry : RowEntry -> Html Msg
viewRowEntry re =
    let
        val =
            case re of
                Just entry ->
                    entry

                Nothing ->
                    ""
    in
        td [] [ text val ]
