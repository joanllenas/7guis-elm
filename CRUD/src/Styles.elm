module Styles exposing (..)


crudContainerStyles : List ( String, String )
crudContainerStyles =
    [ ( "position", "absolute" )
    , ( "left", "calc(50% - 200px)" )
    , ( "top", "calc(50% - 150px)" )
    , ( "width", "400px" )
    , ( "height", "300px" )
    , ( "background-color", "#DDD" )
    , ( "padding", "5px" )
    , ( "box-sizing", "border-box" )
    ]


crudButtonBarStyles : List ( String, String )
crudButtonBarStyles =
    [ ( "position", "absolute" )
    , ( "left", "0" )
    , ( "right", "0" )
    , ( "height", "50px" )
    , ( "bottom", "0" )
    , ( "background-color", "#BBB" )
    , ( "padding", "5px" )
    , ( "box-sizing", "border-box" )
    ]


userFilterStyles : List ( String, String )
userFilterStyles =
    [ ( "position", "absolute" )
    , ( "left", "0" )
    , ( "right", "0" )
    , ( "height", "50px" )
    , ( "top", "0" )
    , ( "background-color", "#DDD" )
    , ( "padding", "5px" )
    , ( "box-sizing", "border-box" )
    ]


userListStyles : List ( String, String )
userListStyles =
    [ ( "position", "absolute" )
    , ( "left", "0" )
    , ( "width", "50%" )
    , ( "top", "50px" )
    , ( "bottom", "50px" )
    , ( "background-color", "#AAA" )
    , ( "padding", "5px" )
    , ( "box-sizing", "border-box" )
    ]


selectStyles : List ( String, String )
selectStyles =
    [ ( "width", "100%" )
    , ( "height", "100%" )
    , ( "box-sizing", "border-box" )
    ]


userFormStyles : List ( String, String )
userFormStyles =
    [ ( "position", "absolute" )
    , ( "right", "0" )
    , ( "width", "50%" )
    , ( "top", "50px" )
    , ( "bottom", "50px" )
    , ( "background-color", "#CCC" )
    , ( "padding", "5px" )
    , ( "box-sizing", "border-box" )
    ]
