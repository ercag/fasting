import 'dart:convert';

import 'package:fasting/helpers/http_helper.dart';
import 'package:fasting/models/ss_model.dart';

class FastingService {
  static String apiUrl = "localhost:8000";

  static Future<SSModel> getSS(String lat, String long, String date) async {
    SSModel retval = SSModel(
        sunrise: "",
        sunset: "",
        solar_noon: "",
        day_length: 0,
        civil_twilight_begin: "",
        civil_twilight_end: "",
        astronomical_twilight_begin: "",
        astronomical_twilight_end: "",
        nautical_twilight_begin: "",
        nautical_twilight_end: "");

    await HttpHelper.fetch(apiUrl, "getss", parameters: {
      "lat": lat, //lat
      "long": long, //long
      "date": date //date
    }).then((value) {
      if (value.resCode > 0) {
        retval = SSModel.fromJson(jsonDecode(value.resData));
      }
    });
    return retval;
  }
}
