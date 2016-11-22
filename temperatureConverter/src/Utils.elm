module Utils exposing (celsiusToFahrenheit, fahrenheitToCelsius)


celsiusToFahrenheit : Float -> Float
celsiusToFahrenheit c =
    c * (9 / 5) + 32


fahrenheitToCelsius : Float -> Float
fahrenheitToCelsius f =
    (f - 32) * (5 / 9)
