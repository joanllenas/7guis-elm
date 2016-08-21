module Tests exposing (..)

import Test exposing (..)
import Expect
import Counter


all : Test
all =
    describe "Counter"
        [ test "Initial value should be 0" <|
            \() ->
                Expect.equal 0 Counter.model
        , test "Increment message should increment model by 1" <|
            \() ->
                let
                    newCount =
                        Counter.update Counter.Increment 0
                in
                    Expect.equal 1 newCount
        ]
