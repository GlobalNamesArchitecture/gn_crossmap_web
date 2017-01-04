module FileUpload.Messages exposing (Msg(..))

import FileUpload.Ports as FP
import FileUpload.Models exposing (File, UploadedFileData)


type Msg
    = UploadSupported Bool
    | FileSelected
    | FileSelectedData (Maybe File)
    | FileUpload
    | FileUploadResult (Maybe UploadedFileData)
