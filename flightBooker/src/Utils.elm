module Utils exposing (targetValueIntDecoder, stringToTime, isValidDateString, anyDateIsInvalid)

import Html.Events exposing (targetValue)
import Date as Date exposing (Date)
import Time as Time exposing (Time)
import Json.Decode as Json
import String


targetValueIntDecoder : Json.Decoder Int
targetValueIntDecoder =
    targetValue
        |> Json.andThen
            (\val ->
                case String.toInt val of
                    Ok i ->
                        Json.succeed i

                    Err err ->
                        Json.fail err
            )


stringToTime : String -> Float
stringToTime dateString =
    dateString
        |> Date.fromString
        |> Result.withDefault (Date.fromTime 0)
        |> Date.toTime
        |> Time.inSeconds


isValidDateString : String -> Bool
isValidDateString d =
    case (Date.fromString d) of
        Ok value ->
            True

        Err error ->
            False


anyDateIsInvalid : String -> String -> Bool
anyDateIsInvalid d1 d2 =
    (not (isValidDateString d1) || not (isValidDateString d2))
