port module XmlToJson exposing (..)

import Msg exposing (..)

port send_xml_to_js       : (String, Int) -> Cmd msg

port receive_json_from_js : ((String, Int) -> msg) -> Sub msg