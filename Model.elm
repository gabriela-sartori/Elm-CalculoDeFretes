module Model exposing (..)

type alias Model =
    { cepOrigem           : String
    , cepDestino          : String
    , peso                : String
    , altura              : String
    , largura             : String
    , comprimento         : String
    , avisoRecebimento    : Bool 
    , entregaMaoPropria   : Bool 
    , valorDeclarado      : String 
    , possuiContrato      : Bool
    , codigoEmpresa       : String
    , senha               : String
    , codigoServicoPac    : String
    , codigoServicoSedex  : String
    , codigoServicoESedex : String
    , resultPac           : Maybe (Result String RetornoPac)
    , resultSedex         : Maybe (Result String RetornoPac)
    , resultESedex        : Maybe (Result String RetornoPac)
    }                   
     
type alias RetornoPac =
    { valor        : String
    , prazoEntrega : String
    , obs          : Maybe String
    }

init : (Model, Cmd a)
init =                  
    { cepOrigem           = ""
    , cepDestino          = ""
    , peso                = "0.3"
    , altura              = "2"
    , largura             = "11"
    , comprimento         = "16"
    , avisoRecebimento    = False
    , entregaMaoPropria   = False
    , valorDeclarado      = "0.0"
    , possuiContrato      = False
    , codigoEmpresa       = "0"
    , senha               = "0"
    , codigoServicoPac    = "0"
    , codigoServicoSedex  = "0"
    , codigoServicoESedex = "0"

    , resultPac           = Nothing
    , resultSedex         = Nothing
    , resultESedex        = Nothing

    } ! []
