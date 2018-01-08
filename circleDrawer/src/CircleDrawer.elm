module CircleDrawer exposing (..)

import Html exposing (..)
import Html.Attributes as HtmlAttrs exposing (..)
import Html.Events as HtmlEvt exposing (..)
import Json.Decode as Decode exposing (..)
import Styles exposing (..)
import Svg exposing (circle, svg)
import Svg.Attributes as SvgAttr exposing (..)
import Svg.Events as SvgEvt exposing (..)


main : Program Never Model Action
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


defaultCircleRadius : Float
defaultCircleRadius =
    50.0


type alias Coords =
    { offsetX : Float
    , offsetY : Float
    }


type alias Circle =
    { id : String
    , x : Float
    , y : Float
    , rad : Float
    }


type alias Model =
    { circles : List Circle
    , history : List (List Circle)
    , historyCursor : Int
    , selectedCircle : Maybe Circle
    , lastId : Int
    }


init : ( Model, Cmd Action )
init =
    ( { circles = []
      , history = [ [] ]
      , historyCursor = 0
      , selectedCircle = Nothing
      , lastId = 1
      }
    , Cmd.none
    )



-- UPDATE


type Action
    = CanvasClick Coords
    | UndoClicked
    | RedoClicked
    | CloseDiameterDialog
    | DiameterChanged String


createCircle : Coords -> String -> Circle
createCircle coords newId =
    Circle newId coords.offsetX coords.offsetY defaultCircleRadius


distanceBetween : ( Float, Float ) -> ( Float, Float ) -> Float
distanceBetween ( x1, y1 ) ( x2, y2 ) =
    sqrt (((x1 - x2) ^ 2) + ((y1 - y2) ^ 2))


findFirstCircleUnderPoint : List Circle -> Coords -> Maybe Circle
findFirstCircleUnderPoint circles coords =
    List.filter (\c -> distanceBetween ( c.x, c.y ) ( coords.offsetX, coords.offsetY ) <= c.rad) circles
        |> List.head



{--
Cursor included.
allItemsToCursor [1,2,3,4] 2 --> [1,2,3]
--}


allItemsToCursor : List a -> Int -> List a
allItemsToCursor list cur =
    List.take (cur + 1) list


update : Action -> Model -> ( Model, Cmd Action )
update action model =
    case action of
        CanvasClick coords ->
            case findFirstCircleUnderPoint model.circles coords of
                Just circle ->
                    ( { model
                        | selectedCircle = Just circle
                      }
                    , Cmd.none
                    )

                Nothing ->
                    let
                        newId =
                            model.lastId + 1

                        newCircles =
                            List.append model.circles [ createCircle coords (toString newId) ]

                        newHistory =
                            List.append (allItemsToCursor model.history model.historyCursor) [ newCircles ]
                    in
                    ( { model
                        | circles = newCircles
                        , history = newHistory
                        , historyCursor = List.length newHistory - 1
                        , lastId = newId
                      }
                    , Cmd.none
                    )

        UndoClicked ->
            let
                newCursor =
                    model.historyCursor - 1

                newCircles =
                    List.head (List.drop newCursor model.history)
            in
            ( { model
                | circles =
                    case newCircles of
                        Nothing ->
                            model.circles

                        Just circles ->
                            circles
                , historyCursor = newCursor
              }
            , Cmd.none
            )

        RedoClicked ->
            let
                newCursor =
                    model.historyCursor + 1

                newCircles =
                    List.head (List.drop newCursor model.history)
            in
            ( { model
                | circles =
                    case newCircles of
                        Nothing ->
                            model.circles

                        Just circles ->
                            circles
                , historyCursor = newCursor
              }
            , Cmd.none
            )

        CloseDiameterDialog ->
            ( { model
                | selectedCircle = Nothing
              }
            , Cmd.none
            )

        DiameterChanged rad ->
            case model.selectedCircle of
                Just circle ->
                    let
                        newCircle =
                            { circle | rad = String.toFloat rad |> Result.withDefault 25 }

                        newCircles =
                            List.map
                                (\c ->
                                    if c.id == circle.id then
                                        newCircle
                                    else
                                        c
                                )
                                model.circles
                    in
                    ( { model
                        | selectedCircle = Just newCircle
                        , circles = newCircles
                        , history = List.append model.history [ newCircles ]
                        , historyCursor = model.historyCursor + 1
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( model
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
        (field "offsetX" float)
        (field "offsetY" float)


rangeValueDecoder : Decoder Action
rangeValueDecoder =
    Decode.map DiameterChanged HtmlEvt.targetValue


diameterDialog : Maybe Circle -> Html Action
diameterDialog selectedCircle =
    case selectedCircle of
        Nothing ->
            div [] []

        Just circle ->
            div [ HtmlAttrs.style Styles.modalStyles ]
                [ div [ HtmlAttrs.style Styles.changeDiameterDialogStyles ]
                    [ button
                        [ HtmlAttrs.style Styles.closeModalButtonStyles
                        , HtmlEvt.onClick CloseDiameterDialog
                        ]
                        [ text "X" ]
                    , span []
                        [ text ("Change diameter: " ++ toString (circle.rad * 2))
                        , input
                            [ HtmlAttrs.style [ ( "width", "'200px'" ) ]
                            , HtmlAttrs.type_ "range"
                            , HtmlAttrs.min "10"
                            , HtmlAttrs.value (toString circle.rad)
                            , HtmlAttrs.max "200"
                            , HtmlEvt.on "change" rangeValueDecoder
                            ]
                            []
                        ]
                    ]
                ]


svgCircle : Circle -> Maybe Circle -> Svg.Svg Action
svgCircle circleData selectedCircle =
    let
        fillColor =
            case selectedCircle of
                Just circle ->
                    if circleData.id == circle.id then
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
    div [ HtmlAttrs.style Styles.mainContainerStyles ]
        [ div [ HtmlAttrs.style Styles.buttonContainerStyles ]
            [ button
                [ HtmlEvt.onClick UndoClicked
                , disabled (model.historyCursor == 0)
                ]
                [ text "Undo" ]
            , text (((model.historyCursor + 1) |> toString) ++ "/" ++ (model.history |> List.length |> toString))
            , button
                [ HtmlEvt.onClick RedoClicked
                , disabled (List.length model.history == model.historyCursor + 1)
                ]
                [ text "Redo" ]
            ]
        , div [ HtmlAttrs.style Styles.svgContainerStyles ]
            [ svg
                [ SvgAttr.width "100%"
                , SvgAttr.height "100%"
                , SvgEvt.on "click" (Decode.map CanvasClick coordsDecoder)
                ]
                (List.map
                    (\circle -> svgCircle circle model.selectedCircle)
                    model.circles
                )
            ]
        , diameterDialog model.selectedCircle
        ]
