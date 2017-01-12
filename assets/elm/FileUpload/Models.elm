module FileUpload.Models exposing (..)


type alias Upload =
    { token : Maybe String
    , file : Maybe File
    , isSupported : Bool
    , id : String
    }


initUpload =
    Upload Nothing Nothing False "file-upload" 


type alias File =
    { filename : String
    , filetype : String
    , size : Float
    }
