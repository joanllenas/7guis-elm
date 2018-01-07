module CircleDrawer exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as HtmlEvt exposing (onClick)
import Json.Decode as Decode exposing (Decoder, at, field, int, map2)
import Styles
import Svg exposing (circle, svg)
import Svg.Attributes as SvgAttr exposing (cx, cy, fill, height, id, r, stroke, width)
import Svg.Events as SvgEvt exposing (on)


main : Program Never Model Action
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Coords =
    { offsetX : Int
    , offsetY : Int
    }


type alias Circle =
    { id : String
    , x : Int
    , y : Int
    , rad : Float
    }


type alias Model =
    { circles : List Circle
    , undos : List Circle
    , redos : List Circle
    , selectedCircleId : Maybe String
    , changingDiameter : Bool
    , lastId : Int
    }


init : ( Model, Cmd Action )
init =
    ( { circles = []
      , undos = []
      , redos = []
      , selectedCircleId = Nothing
      , changingDiameter = False
      , lastId = 1
      }
    , Cmd.none
    )



-- UPDATE


type Action
    = CanvasClick Coords
    | UndoClicked
    | RedoClicked


createCircle : Coords -> String -> Circle
createCircle coords newId =
    Circle newId coords.offsetX coords.offsetY 50.0


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        CanvasClick coords ->
            let
                newId =
                    model.lastId + 1
            in
            ( { model
                | circles = model.circles |> (::) (createCircle coords (toString newId))
                , lastId = newId
              }
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


coordsDecoder : Decoder Coords
coordsDecoder =
    map2 Coords
        (field "offsetX" int)
        (field "offsetY" int)


createSvgCircle : Circle -> Maybe String -> Svg.Svg Action
createSvgCircle circleData selectedCircleId =
    let
        fillColor =
            case selectedCircleId of
                Just id ->
                    if circleData.id == id then
                        "gray"
                    else
                        "white"

                Nothing ->
                    "white"
    in
    Svg.circle
        [ SvgAttr.id circleData.id
        , SvgAttr.cx (toString circleData.x)
        , SvgAttr.cy (toString circleData.y)
        , SvgAttr.r (toString circleData.rad)
        , SvgAttr.stroke "black"
        , SvgAttr.fill fillColor
        ]
        []


view : Model -> Html Action
view model =
    div [ style Styles.mainContainerStyles ]
        [ div [ style Styles.buttonContainerStyles ]
            [ button
                [ HtmlEvt.onClick UndoClicked
                , disabled (List.length model.undos == 0)
                ]
                [ text "Undo" ]
            , button
                [ HtmlEvt.onClick RedoClicked
                , disabled (List.length model.redos == 0)
                ]
                [ text "Redo" ]
            ]
        , div [ style Styles.svgContainerStyles ]
            [ svg
                [ SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgEvt.on "click" (Decode.map CanvasClick coordsDecoder)
                ]
                (List.map
                    (\circle -> createSvgCircle circle model.selectedCircleId)
                    model.circles
                )
            ]
        ]
