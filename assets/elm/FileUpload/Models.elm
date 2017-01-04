module FileUpload.Models exposing (..)


type alias Upload =
    { token : Maybe String
    , file : Maybe File
    , isSupported : Bool
    , id : String
    , uploadedFile : Maybe UploadedFileData
    }


initUpload =
    Upload Nothing Nothing False "file-upload" Nothing


type alias File =
    { filename : String
    , filetype : String
    , size : Float
    }


type alias UploadedFileData =
    { token : String
    , filename : String
    , output : String
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
