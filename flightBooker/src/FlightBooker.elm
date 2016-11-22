module FlightBooker exposing (..)

import Html exposing (Html, div, text, button, select, option, input)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, on, onInput)
import Utils
import Styles
import Json.Decode as Json


main : Program Never Model Action
main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }



-- MODEL


type FlightType
    = OneWayFlight
    | ReturnFlight


type alias Item =
    { id : Int
    , label : String
    , flightType : FlightType
    }


type alias Model =
    { selectedFlightType : FlightType
    , flightTypes : List Item
    , displayBookedMessage : Bool
    , startDate : String
    , returnDate : String
    }


initialModel : Model
initialModel =
    { selectedFlightType = OneWayFlight
    , flightTypes =
        [ { id = 0, label = "Return Flight", flightType = ReturnFlight }
        , { id = 1, label = "One Way Flight", flightType = OneWayFlight }
        ]
    , startDate = "1999/12/31"
    , returnDate = "1999/12/31"
    , displayBookedMessage = False
    }



-- UPDATE


type Action
    = FlightTypeChanged Int
    | StartDateChanged String
    | ReturnDateChanged String
    | FlightBooked


update : Action -> Model -> Model
update action model =
    case action of
        FlightTypeChanged id ->
            let
                selection =
                    List.filter (\item -> id == item.id) model.flightTypes |> List.head
            in
                { model
                    | selectedFlightType =
                        case selection of
                            Nothing ->
                                OneWayFlight

                            Just val ->
                                val.flightType
                }

        StartDateChanged dateString ->
            { model | startDate = dateString }

        ReturnDateChanged dateString ->
            { model | returnDate = dateString }

        FlightBooked ->
            { model | displayBookedMessage = True }



-- VIEW


createFlightOption : FlightType -> Item -> Html Action
createFlightOption selectedFlightType flightType =
    option
        [ value (toString flightType.id)
        , selected (flightType.flightType == selectedFlightType)
        ]
        [ text flightType.label ]


dateInputStyles : String -> List ( String, String )
dateInputStyles dateString =
    dateString
        |> Utils.isValidDateString
        |> Styles.dateInputStyles


bookButtonDisabled : Model -> Bool
bookButtonDisabled model =
    Utils.anyDateIsInvalid model.startDate model.returnDate
        || (model.selectedFlightType
                == ReturnFlight
                && Utils.stringToTime model.returnDate
                < Utils.stringToTime model.startDate
           )


flightLabel : Model -> String
flightLabel model =
    let
        selection =
            List.filter (\item -> model.selectedFlightType == item.flightType) model.flightTypes |> List.head
    in
        case selection of
            Nothing ->
                "--"

            Just val ->
                val.label


view : Model -> Html Action
view model =
    div [ style Styles.mainContainerStyles ]
        [ select [ on "change" (Json.map FlightTypeChanged Utils.targetValueIntDecoder) ]
            (List.map (createFlightOption model.selectedFlightType) model.flightTypes)
        , input
            [ value model.startDate
            , style (dateInputStyles model.startDate)
            , onInput StartDateChanged
            ]
            []
        , input
            [ value model.returnDate
            , style (dateInputStyles model.returnDate)
            , disabled (model.selectedFlightType == OneWayFlight)
            , onInput ReturnDateChanged
            ]
            []
        , button
            [ onClick FlightBooked
            , disabled (bookButtonDisabled model)
            ]
            [ text "Book" ]
        , div [ style (Styles.messageContainerStyles model.displayBookedMessage) ]
            [ text ("You have booked a " ++ (flightLabel model) ++ " flight on " ++ model.startDate) ]
        ]
