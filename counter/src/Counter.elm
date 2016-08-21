module Counter exposing (..)

import Html exposing (Html, button, div, span, text)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


main : Program Never
main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    Int


model : Model
model =
    0



-- UPDATE


type Msg
    = Increment


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ span [ style [ ( "padding", "5px" ) ] ] [ text (toString model) ]
        , button [ onClick Increment ] [ text "Count" ]
        ]
