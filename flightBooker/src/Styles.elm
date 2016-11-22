module Styles exposing (..)


mainContainerStyles : List ( String, String )
mainContainerStyles =
    [ ( "display", "flex" )
    , ( "flex-direction", "column" )
    , ( "width", "250px" )
    , ( "padding", "10px" )
    ]


dateInputStyles : Bool -> List ( String, String )
dateInputStyles isValidDate =
    case isValidDate of
        True ->
            [ ( "background-color", "white" ) ]

        False ->
            [ ( "background-color", "red" ) ]


messageContainerStyles : Bool -> List ( String, String )
messageContainerStyles isVisible =
    case isVisible of
        True ->
            [ ( "display", "block" )
            , ( "border", "1px solid #000" )
            , ( "padding", "5px" )
            ]

        False ->
            [ ( "display", "none" ) ]
