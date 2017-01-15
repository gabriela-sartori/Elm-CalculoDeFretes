module Request exposing (..)

import Msg   exposing (..)
import Model exposing (..)

import Json.Decode as JD
import Http
import Task 

decodePAC : JD.Decoder (Result String RetornoPac)
decodePAC =
    let
        error =
            JD.at ["Servicos", "cServico", "MsgErro", "__cdata"] JD.string
            |> JD.map Err

        -- Correios fez um negocio bugado e quando vem mensagem de observação
        -- ele vem na tag MsgErro mesmo
        success =
            JD.map3 RetornoPac
                (JD.at ["Servicos", "cServico", "Valor"]        JD.string)
                (JD.at ["Servicos", "cServico", "PrazoEntrega"] JD.string)
                (JD.oneOf
                    [ JD.at ["Servicos", "cServico", "MsgErro", "__cdata"] JD.string
                        |> JD.map Just
                    , JD.succeed Nothing
                    ])

            |> JD.map (\retornoPac ->
                if retornoPac.valor == "0,00" then
                    Err <| Maybe.withDefault "?" retornoPac.obs
                else
                    Ok retornoPac)
    in
        JD.oneOf [ success, error ]

build_url : TipoEnvio -> Model -> String
build_url tipo model =
    let
        codigo_servico =
            case tipo of
                Pac    ->
                    if model.possuiContrato then
                        model.codigoServicoPac
                    else
                        "41106"

                Sedex  ->
                    if model.possuiContrato then
                        model.codigoServicoSedex
                    else
                        "40010"

                ESedex ->
                    if model.possuiContrato then
                        model.codigoServicoESedex
                    else
                        "81019"
    in
        "http://ws.correios.com.br/calculador/CalcPrecoPrazo.aspx" ++
        "?nCdEmpresa="          ++ model.codigoEmpresa ++
        "&sDsSenha="            ++ model.senha         ++
        "&nCdServico="          ++ codigo_servico ++
        "&sCepOrigem="          ++ model.cepOrigem     ++
        "&sCepDestino="         ++ model.cepDestino    ++ 
        "&nVlPeso="             ++ model.peso          ++
        "&nCdFormato=1"         ++
        "&nVlComprimento="      ++ model.comprimento   ++
        "&nVlLargura="          ++ model.largura       ++
        "&nVlAltura="           ++ model.altura        ++
        "&nVlDiametro=0"        ++
        "&sCdMaoPropria="       ++ (if model.entregaMaoPropria then "S" else "N") ++
        "&nVlValorDeclarado="   ++ model.valorDeclarado ++
        "&sCdAvisoRecebimento=" ++ (if model.avisoRecebimento then "S" else "N") ++
        "&StrRetorno=XML"

sendRequest : TipoEnvio -> Model -> Cmd Msg 
sendRequest tipo model =
    Http.getString (build_url tipo model)
    |> Http.toTask
    |> Task.mapError toString
    |> Task.attempt ((,) tipo >> ReceivedRequest)
