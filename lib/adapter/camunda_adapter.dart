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
/*
  Future<List<OrderModel>> createAppointment(Strig idCamunda) async {

    final response = await http.get('http://192.168.1.64:8000/store/order/');
    if (response.statusCode == 200) {

      List responseJson = json.decode(utf8.decode(response.bodyBytes)) as List;

      return responseJson.map((order) {
        List orderProducts = order['order_products'];
        List orderProductList = orderProducts.map((orderProduct) => OrderProduct.fromMap(orderProduct)).toList();
        return  OrderModel.fromMap(order, orderProductList);
      }).toList();

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Products');
    }
  }
  */
}
