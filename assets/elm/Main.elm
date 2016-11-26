module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href)


type alias Model =
    { token : String
    , server : String
    , headers : Headers
    , rows : Rows
    }


type alias Headers =
    List String


type alias Rows =
    List Row


type alias Row =
    List RowEntry


type alias RowEntry =
    Maybe String


type alias Flags =
    { token : String
    , server : String
    , headers : Headers
    , rows : Rows
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model
        flags.token
        flags.server
        flags.headers
        flags.rows
    , Cmd.none
    )


type Msg
    = NothingYet


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    let
        token_url =
            "http://" ++ model.server ++ "/crossmaps/" ++ model.token
    in
        div []
            [ a [ href token_url ]
                [ text token_url ]
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


main =
    programWithFlags
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }
