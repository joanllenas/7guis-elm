module Tests exposing (..)

import Test exposing (..)
import Expect
import TemperatureConverter
import Utils


all : Test
all =
    describe "Test suite"
        [describe "Utils"
            [describe "celsiusToFahrenheit"
                [ test "Converts 0 to 32" <|
                    \() ->
                        Expect.equal 32 (Utils.celsiusToFahrenheit 0)
                , test "Converts -5 to 23" <|
                    \() ->
                        Expect.equal 23 (Utils.celsiusToFahrenheit -5)
                , test "Converts 5 to 41" <|
                    \() ->
                        Expect.equal 23 (Utils.celsiusToFahrenheit -5)
                ]
            , describe "fahrenheitToCelsius"
                [ test "Converts 0 to 32" <|
                    \() ->
                        Expect.equal 0 (Utils.fahrenheitToCelsius 32)
                , test "Converts -5 to 23" <|
                    \() ->
                        Expect.equal -5 (Utils.fahrenheitToCelsius 23)
                , test "Converts 5 to 41" <|
                    \() ->
                        Expect.equal -5 (Utils.fahrenheitToCelsius 23)
                ]
            ]
        , describe "TemperatureConverter"
            [ test "Initial temperature values are an empty string" <|
                \() ->
                    let 
                        model = 
                            TemperatureConverter.model
                    in
                        Expect.equal True ("" == model.celsius && "" == model.fahrenheit)
            , test "Changing Celsius updates Fahrenheit" <|
                \() ->
                    let
                        newModel =
                            TemperatureConverter.update (TemperatureConverter.CelsiusChanged "0") {celsius = "", fahrenheit = ""}
                    in
                        Expect.equal "32" newModel.fahrenheit
            , test "Changing Fahrenheit updates Celsius" <|
                \() ->
                    let
                        newModel =
                            TemperatureConverter.update (TemperatureConverter.FahrenheitChanged "32") {celsius = "", fahrenheit = ""}
                    in
                        Expect.equal "0" newModel.celsius
            , test "Introducing non numeric values does not update temperature values" <|
                \() ->
                    let
                        newModel =
                            TemperatureConverter.update (TemperatureConverter.FahrenheitChanged "32") {celsius = "0", fahrenheit = "32"}
                    in
                        Expect.equal "0" newModel.celsius
            ]
        ]
