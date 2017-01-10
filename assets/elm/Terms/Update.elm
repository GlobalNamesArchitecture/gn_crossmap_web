module Terms.Update exposing (update)

import Navigation exposing (newUrl)
import Terms.Messages exposing (Msg(..))
import Terms.Models exposing (Terms)


update : Msg -> Terms -> ( Terms, Cmd Msg )
update msg terms =
    case msg of
        HeaderMap term ->
          ( terms, Cmd.none)
        ToDataSources token ->
            ( terms, newUrl <| "/#target/" ++ token )

        ToResolver token ->
            ( terms, newUrl <| "/#resolver/" ++ token )
