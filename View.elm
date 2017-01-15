module View exposing (..)

import Msg   exposing (..)
import Model exposing (..)

import Html            exposing (..)
import Html.Attributes exposing (..)
import Html.Events     exposing (..)

build_fieldset : String -> (Maybe (Result String RetornoPac)) -> Html Msg
build_fieldset title result =
    div [] <|
    case result of
        Nothing ->
            []

        Just result ->
            let
                data =
                    case result of 
                        Err error ->
                            [ text error, br [] []]

                        Ok pac ->
                            [ text <| "Valor: " ++ pac.valor
                            , br [] []
                            , text <| "Prazo Entrega: " ++ pac.prazoEntrega
                            , br [] []
                            ] ++
                            (case pac.obs of
                                Just obs ->
                                    [ text obs ]
                                Nothing ->
                                    [])
            in
                [ fieldset [] ([ legend [] [ text title ] ] ++ data)
                , br [] []]

txt : String -> (String -> Msg) -> String -> Html Msg
txt title msg value_ =
    div []
        [ text title
        , input [ type_ "text", onInput msg, value value_ ] []
        , br [] [], br [] [] ]

chk : String -> (Bool -> Msg) -> Bool -> Html Msg
chk title msg value_ =
    div []
        [ input [ type_ "checkbox", onCheck msg, checked value_ ] []
        , text <| " " ++ title
        , br [] []]

form_ : Model -> Html Msg
form_ model =
    div [ id "form" ]
        [   div [ class "column" ]
                [ txt "CEP Origem"          UpdateCepOrigem         model.cepOrigem
                , txt "CEP Destino"         UpdateCepDestino        model.cepDestino
                , txt "Peso"                UpdatePeso              model.peso
                , txt "Altura"              UpdateAltura            model.altura
                , txt "Largura"             UpdateLargura           model.largura
                , txt "Comprimento"         UpdateComprimento       model.comprimento
                , txt "Valor Declarado"     UpdateValorDeclarado    model.valorDeclarado
                , chk "Aviso Recebimento"   UpdateAvisoRecebimento  model.avisoRecebimento
                , chk "Entrega Mão Própria" UpdateEntregaMaoPropria model.entregaMaoPropria
                , chk "Possui Contrato"     UpdatePossuiContrato    model.possuiContrato
                , br [] []
                , button [ onClick Calcular ] [ text "Calcular" ]
                ]

        ,   div [ class "column"
                , style [ ("display", if model.possuiContrato then "block" else "none") ]]
                [ txt "Código Empresa:"         UpdateCodigoEmpresa       model.codigoEmpresa
                , txt "Senha:"                  UpdateSenha               model.senha
                , txt "Código Serviço PAC:"     UpdateCodigoServicoPac    model.codigoServicoPac
                , txt "Código Serviço Sedex:"   UpdateCodigoServicoSedex  model.codigoServicoSedex
                , txt "Código Serviço E-Sedex:" UpdateCodigoServicoESedex model.codigoServicoESedex
                ]

        ,   div [ class "column" ]
                [ build_fieldset "PAC"     model.resultPac
                , build_fieldset "Sedex"   model.resultSedex
                , build_fieldset "E-Sedex" model.resultESedex
                ]
        ]
    
view : Model -> Html Msg
view model =
    fieldset [ id "fieldset" ]
        [ legend [] [ text "Cálculo de Fretes" ]
        , br [] []
        , form_ model
        ]
