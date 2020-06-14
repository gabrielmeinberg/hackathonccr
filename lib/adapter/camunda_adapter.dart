import 'dart:convert';

import 'package:http/http.dart' as http;



class CamundaAdapter{

  Future<String> createAppointment(String dataValue, String descricaoValue) async {
    Map jason = {
                "variables": {
                  "nome": {
                    "value":"Caminhoneiro Top",
                    "type":"string"
                  },
                  "idade": {
                    "value":45,
                    "type":"integer"
                  },
                  "dataAtendimento": {
                    "value":"$dataValue",
                    "type":"string"
                  },
                  "telefone": {
                    "value":"11 99999-9999",
                    "type":"string"
                  },
                  "descricao": {
                    "value":"$descricaoValue",
                    "type":"string"
                  }
                }
              };
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
    };
    final response = await http.post('http://192.168.1.64:8080/engine-rest/process-definition/key/medico/start',
        headers: headers, body: json.encode(jason));
    if (response.statusCode != 200) {
      throw Exception('Failed to Make Order');
    }
    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    return responseJson['id'];
  }

  Future<String> getAppointment(String id) async{
    final response = await http.get('http://192.168.1.64:8080/engine-rest/history/process-instance/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to Make Order');
    }
    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    return responseJson['state'];
  }
}
