module Subscriptions exposing (..)

import Keyboard

import Msg       exposing (..)
import Model     exposing (..)
import XmlToJson

receive_json_from_js =
    XmlToJson.receive_json_from_js
            (\(json, tipo) ->
                ReceivedJsonFromJs ((intToTipoEnvio tipo), json))

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ receive_json_from_js
        , Keyboard.downs (\n -> if n == 13 then Calcular else Nop)
        ]
    
