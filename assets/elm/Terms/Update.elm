module Terms.Update exposing (update)

import Navigation exposing (newUrl)
import Terms.Messages exposing (Msg(..))
import Terms.Models exposing (Terms, Header)


update : Msg -> Terms -> ( Terms, Cmd Msg )
update msg terms =
    case msg of
        MapTerm id term ->
            let
                headers =
                    updateHeaders terms.headers id term
            in
                ( { terms | headers = headers }, Cmd.none )

        ToDataSources token ->
            ( terms, newUrl <| "/#target/" ++ token )

        ToResolver token ->
            ( terms, newUrl <| "/#resolver/" ++ token )

        GetTerms (Ok newTerms) ->
            ( newTerms, Cmd.none )

        GetTerms (Err err) ->
            ( terms, Cmd.none )


updateHeaders : List Header -> Int -> String -> List Header
updateHeaders headers id term =
    List.map
        (\h ->
            if h.id == id then
                Header h.id h.value <| prepareTerm term
            else
                h
        )
        headers

prepareTerm : String -> Maybe String
prepareTerm term =
  if String.isEmpty term then
    Nothing
  else
    Just term
