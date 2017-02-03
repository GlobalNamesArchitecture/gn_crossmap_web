module FileUpload.Update exposing (update)

import FileUpload.Models exposing (Upload, File)
import FileUpload.Messages exposing (Msg(..))
import FileUpload.Ports exposing (..)
import Navigation exposing (newUrl)


update : Msg -> Upload -> ( Upload, Cmd Msg )
update msg upload =
    case msg of
        UploadSupported value ->
            ( { upload | isSupported = value }, Cmd.none )

        FileSelected ->
            ( upload, fileSelected upload.id )

        FileSelectedData file ->
            ( { upload | file = file }, Cmd.none )

        FileUpload ->
            ( upload, fileUpload upload.id )

        FileUploadResult token ->
            ( { upload | token = token }
            , tokenCmd token
            )


tokenCmd : Maybe String -> Cmd Msg
tokenCmd mbToken =
    case mbToken of
        Nothing ->
            Cmd.none

        Just token ->
            newUrl <|
                "/#terms/"
                    ++ token
