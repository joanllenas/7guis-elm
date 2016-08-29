module Timer exposing (..)

import Html exposing (Html, div, text, button, span, progress, input)
import Html.App as Html
import Html.Attributes as Attrs
import Html.Attributes exposing (style, value, type', step)
import Html.Events exposing (onClick, on, targetValue)

import Time exposing (Time, millisecond)
import Json.Decode as Json
import String

import Styles



main : Program Never
main =
    Html.program 
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL



type alias Model = 
    { elapsed : Time.Time
    , duration : Time.Time
    , interval : Time.Time
    }


init : (Model, Cmd Action)
init = 
    ( 
        { elapsed = 0
        , duration = 5000
        , interval = 500 * millisecond
        } 
        , Cmd.none 
    )



-- UPDATE



type Action
    = DurationChanged Int
    | Tick Time
    | ResetTimer


update : Action -> Model -> (Model, Cmd Action)
update action model 
    = case action of
        Tick newTime ->
            (
                { model | elapsed = min model.duration (model.elapsed + model.interval) }
                , Cmd.none
            )
        DurationChanged newDuration ->
            (
                { model | duration = toFloat newDuration }
                , Cmd.none
            )
        ResetTimer ->
            (
                { model | elapsed = 0 }
                , Cmd.none
            )
            -- stop timer



-- SUBSCRIPTIONS



subscriptions : Model -> Sub Action
subscriptions model =
  Time.every model.interval Tick



-- VIEW



elapsedToSeconds : Float -> Float
elapsedToSeconds t
    = t / 1000


targetValueIntDecoder : Json.Decoder Int
targetValueIntDecoder =
  targetValue `Json.andThen` \val ->
    case String.toInt val of
      Ok i -> Json.succeed i
      Err err -> Json.fail err


view : Model -> Html Action
view model =
    div [ style Styles.mainContainerStyles ]
        [ div []
              [ text "Elapsed time:"
              , progress [ Attrs.max (toString model.duration), value (toString model.elapsed) ] []
              ]
        , div []
              [ text (String.append (model.elapsed |> elapsedToSeconds |> floor |> toString) "s" ) ]
        , div []
              [ text "Duration:"
              , input [ type' "range"
                      , step "100"
                      , Attrs.min "1000"
                      , Attrs.max "10000" 
                      , value (toString model.duration)
                      , on "change" ( Json.map DurationChanged targetValueIntDecoder ) 
                      ]
                      [] 
              ]
        , button [ onClick ResetTimer ]
                 [ text "Reset" ]
        ]