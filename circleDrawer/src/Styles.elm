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
    , ( "height", "calc( 100% - 50px )" )
    , ( "backgroundColor", "#666" )
    ]



-- Modal styles


modalStyles : List ( String, String )
modalStyles =
    [ ( "position", "absolute" )
    , ( "left", "0" )
    , ( "right", "0" )
    , ( "top", "0" )
    , ( "bottom", "0" )
    , ( "backgroundColor", "#333" )
    , ( "opacity", "0.9" )
    ]


closeModalButtonStyles : List ( String, String )
closeModalButtonStyles =
    [ ( "position", "absolute" )
    , ( "right", "10px" )
    , ( "top", "10px" )
    ]


changeDiameterDialogStyles : List ( String, String )
changeDiameterDialogStyles =
    [ ( "position", "absolute" )
    , ( "left", "calc(50% - 100px)" )
    , ( "top", "calc(50% - 50px)" )
    , ( "width", "300px" )
    , ( "height", "150px" )
    , ( "borderRadius", "10px" )
    , ( "backgroundColor", "#fff" )
    , ( "opacity", "0.9" )
    , ( "display", "flex" )
    , ( "alignItems", "center" )
    , ( "justifyContent", "center" )
    ]
