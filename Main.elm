module Main exposing (..)

import Msg           exposing (..)
import Model         exposing (..)
import Update        exposing (..)
import View          exposing (..)
import Subscriptions exposing (..)

import Html

main =
    Html.program
        { init          = init
        , update        = update
        , view          = view
        , subscriptions = subscriptions
        }
