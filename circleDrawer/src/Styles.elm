module Styles exposing (..)


mainContainerStyles : List ( String, String )
mainContainerStyles =
    [ ( "position", "absolute" )
    , ( "left", "0" )
    , ( "right", "0" )
    , ( "top", "0" )
    , ( "bottom", "0" )
    , ( "backgroundColor", "#fff" )
    ]


buttonContainerStyles : List ( String, String )
buttonContainerStyles =
    [ ( "top", "0" )
    , ( "height", "50px" )
    , ( "backgroundColor", "#ccc" )
    , ( "display", "flex" )
    , ( "alignItems", "center" )
    , ( "justifyContent", "center" )
    ]


svgContainerStyles : List ( String, String )
svgContainerStyles =
    [ ( "top", "50px" )
    , ( "bottom", "0" )
    , ( "backgroundColor", "#666" )
    ]
