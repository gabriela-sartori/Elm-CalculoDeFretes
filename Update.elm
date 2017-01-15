module Update exposing (..)

import Msg     exposing (..)
import Model   exposing (..)
import Request exposing (..)
import XmlToJson

import Json.Decode as JD

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Nop ->
            model ! []

        ReceivedJsonFromJs (tipo, json) ->
            case JD.decodeString Request.decodePAC json of
                Err fail_decode ->  
                    case tipo of
                        Pac ->
                            { model | resultPac    = Just <| Err fail_decode } ! []
                        Sedex ->
                            { model | resultSedex  = Just <| Err fail_decode } ! []
                        ESedex ->
                            { model | resultESedex = Just <| Err fail_decode } ! []

                Ok result ->
                    case tipo of 
                        Pac ->
                            { model | resultPac    = Just result } ! []
                        Sedex ->
                            { model | resultSedex  = Just result } ! []
                        ESedex ->
                            { model | resultESedex = Just result } ! []


        Calcular ->
            model
                ! [ sendRequest Pac    model
                  , sendRequest Sedex  model
                  , sendRequest ESedex model
                  ]
            
        ReceivedRequest (tipo, result) ->
            case result of
                Ok xml ->
                    model ! [ XmlToJson.send_xml_to_js (xml, (tipoEnvioToInt tipo)) ]
                    
                Err error ->
                    case tipo of
                        Pac ->
                            { model | resultPac    = Just <| Err error } ! []
                        Sedex ->
                            { model | resultSedex  = Just <| Err error } ! []
                        ESedex ->
                            { model | resultESedex = Just <| Err error } ! []
        
        UpdateCepOrigem str ->
            { model | cepOrigem = str } ! []
        
        UpdateCepDestino str ->
            { model | cepDestino = str } ! []
                                           
        UpdatePeso str ->
            { model | peso = str } ! []
        
        UpdateAltura str ->
            { model | altura = str } ! []
                                           
        UpdateLargura str ->
            { model | largura = str } ! []
                                           
        UpdateComprimento str ->
            { model | comprimento = str } ! []
                                            
        UpdateAvisoRecebimento b ->
            { model | avisoRecebimento = b } ! []
        
        UpdateEntregaMaoPropria b ->
            { model | entregaMaoPropria = b } ! []
                                           
        UpdateValorDeclarado str ->
            { model | valorDeclarado = str } ! []

        UpdatePossuiContrato b ->
            { model | possuiContrato = b } ! []
                                           
        UpdateCodigoEmpresa str ->
            { model | codigoEmpresa = str } ! []
                                            
        UpdateSenha str ->
            { model | senha = str } ! []

        UpdateCodigoServicoPac str ->
            { model | codigoServicoPac = str } ! []

        UpdateCodigoServicoSedex str ->
            { model | codigoServicoSedex = str } ! []

        UpdateCodigoServicoESedex str ->
            { model | codigoServicoESedex = str } ! []

