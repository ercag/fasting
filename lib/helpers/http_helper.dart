import 'dart:convert';

import 'package:fasting/models/response_model.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  static Future<ResponseModel> fetch(String authority, String unencodedPath,
      {Map<String, dynamic>? parameters}) async {
    ResponseModel retVal = ResponseModel(
        resCode: -1, resMessage: "Error", resData: "Failed to fetch data");

    // if (parameters != null) {
    //   if (parameters.isNotEmpty) {
    //     //starts with question mark
    //     url += "?";

    //     parameters.forEach((key, value) {
    //       //we add every key and value to url
    //       url += "$key=$value&";
    //     });

    //     //then we must remove tha & at the end
    //     url = url.substring(0, url.length - 1);
    //   }
    // }

    var uri = Uri.http(authority, unencodedPath, parameters);
    await http.get(uri).then((value) {
      if (value.statusCode == 200) {
        retVal = ResponseModel.fromJson(jsonDecode(value.body));
      }
    });

    return retVal;
  }
}
