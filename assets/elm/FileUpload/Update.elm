module FileUpload.Update exposing (update)

import FileUpload.Models exposing (Upload, File, UploadedFileData)
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

        FileUploadResult data ->
            ( { upload | uploadedFile = data }
            , tokenCmd data
            )


tokenCmd : Maybe UploadedFileData -> Cmd Msg
tokenCmd data =
    case data of
        Nothing ->
            Cmd.none

        Just d ->
            newUrl <|
                "/#terms/"
                    ++ d.token
