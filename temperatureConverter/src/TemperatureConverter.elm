module TemperatureConverter exposing (..)

import Html exposing (Html, input, div, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String
import Utils


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = model, view = view, update = update }



-- MODEL


type alias Model =
    { celsius : String
    , fahrenheit : String
    }


model : Model
model =
    { celsius = ""
    , fahrenheit = ""
    }



-- UPDATE


type Msg
    = CelsiusChanged String
    | FahrenheitChanged String


update : Msg -> Model -> Model
update msg model =
    case msg of
        CelsiusChanged newCelsius ->
            case String.toFloat newCelsius of
                Err msg ->
                    { model
                        | celsius = newCelsius
                        , fahrenheit = model.fahrenheit
                    }

                Ok celsius ->
                    { model
                        | celsius = newCelsius
                        , fahrenheit =
                            celsius
                                |> Utils.celsiusToFahrenheit
                                |> toString
                    }

        FahrenheitChanged newFahrenheit ->
            case String.toFloat newFahrenheit of
                Err msg ->
                    { model
                        | fahrenheit = newFahrenheit
                        , celsius = model.celsius
                    }

                Ok fahrenheit ->
                    { model
                        | fahrenheit = newFahrenheit
                        , celsius =
                            fahrenheit
                                |> Utils.fahrenheitToCelsius
                                |> toString
                    }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input
            [ type_ "text", value model.celsius, onInput CelsiusChanged, placeholder "Celsius" ]
            []
        , span
            []
            [ text "Celsius = " ]
        , input
            [ type_ "text", value model.fahrenheit, onInput FahrenheitChanged, placeholder "Fahrenheit" ]
            []
        , span
            []
            [ text "Fahrenheit" ]
        ]
