module CircleDrawer exposing (..)

import Html exposing (..)
import Html.Attributes as Attrs exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import Styles


main : Program Never Model Action
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Point =
    { x : Float
    , y : Float
    }


type alias Circle =
    { id : String
    , x : Float
    , y : Float
    , rad : Float
    }


type SelectedCircleId
    = String
    | NoSelection


type alias Model =
    { circles : List Circle
    , undos : List Circle
    , redos : List Circle
    , selectedCircleId : SelectedCircleId
    , changingDiameter : Bool
    }


init : ( Model, Cmd Action )
init =
    ( { circles = []
      , undos = []
      , redos = []
      , selectedCircleId = NoSelection
      , changingDiameter = False
      }
    , Cmd.none
    )



-- UPDATE


type Action
    = CanvasClicked Point
    | UndoClicked
    | RedoClicked


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        CanvasClicked point ->
            ( { model | circles = [] }
            , Cmd.none
            )

        UndoClicked ->
            ( { model | undos = [] }
            , Cmd.none
            )

        RedoClicked ->
            ( { model | redos = [] }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Action
view model =
    div []
        [ text "Hello" ]
