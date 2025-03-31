import 'package:http/http.dart' as http;
import 'dart:convert';

class API {

  static Future<Map<String, dynamic>?> APICall(String dir, String outgoing) async {
    String url = "http://10.0.2.2:8000${dir}";
    print(outgoing); //debug
    try {
      http.Response response = await http.post(
        Uri.parse(url),
        body: utf8.encode(outgoing),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        encoding: Encoding.getByName("utf-8"),
      );
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        // Decode the JSON response body into a Map
        Map<String, dynamic> data = jsonDecode(response.body);
        data['code'] = statusCode; //for frontend changes on fail
        return data;
      } else {
        print('Request failed with status: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      print('Error making API call: ${e}');
    }
    return null;
  }
}