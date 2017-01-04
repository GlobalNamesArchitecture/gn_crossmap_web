module Messages exposing (Msg(..))

import Navigation exposing (Location)
import FileUpload.Messages
import Terms.Messages
import DataSource.Messages
import Resolver.Messages


type Msg
    = OnLocationChange Location
    | FileUploadMsg FileUpload.Messages.Msg
    | TermsMsg Terms.Messages.Msg
    | DataSourceMsg DataSource.Messages.Msg
    | ResolverMsg Resolver.Messages.Msg
