module Msg exposing (..)

type Msg 
    = Nop
    | Calcular
    | ReceivedJsonFromJs        (TipoEnvio, String)
    | ReceivedRequest           (TipoEnvio, (Result String String))
    | UpdateCepOrigem           String
    | UpdateCepDestino          String
    | UpdatePeso                String
    | UpdateAltura              String
    | UpdateLargura             String
    | UpdateComprimento         String
    | UpdateAvisoRecebimento    Bool
    | UpdateEntregaMaoPropria   Bool
    | UpdateValorDeclarado      String
    | UpdatePossuiContrato      Bool
    | UpdateCodigoEmpresa       String
    | UpdateSenha               String
    | UpdateCodigoServicoPac    String
    | UpdateCodigoServicoSedex  String
    | UpdateCodigoServicoESedex String

type TipoEnvio
    = Pac
    | Sedex
    | ESedex

tipoEnvioToInt : TipoEnvio -> Int
tipoEnvioToInt tipo =
    case tipo of 
        Pac   -> 1
        Sedex -> 2
        _     -> 3

intToTipoEnvio : Int -> TipoEnvio
intToTipoEnvio n =
    case n of 
        1 -> Pac
        2 -> Sedex
        _ -> ESedex
