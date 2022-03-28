import 'dart:convert';

import 'package:fasting/models/ss_model.dart';
import 'package:http/http.dart' as http;

class FastingService {
  static String apiUrl = "ercaguysal.com/";

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
//  String url = "https:///json?lat=" + lat + "&lng=" + long + "&" + date + "&formatted=0";
    var uri = Uri.https("api.sunrise-sunset.org", "json", {
      "lat": lat, //lat
      "long": long, //long
      "date": date,
      "formatted": "0" //date
    });
    await http.get(uri).then((value) {
      if (value.statusCode == 200) {
        retval = SSModel.fromJson(jsonDecode(value.body));
      }
    });

    return retval;
  }
}
