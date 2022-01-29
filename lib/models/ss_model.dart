// ignore_for_file: non_constant_identifier_names

class SSModel {
  String sunrise;
  String sunset;
  String solar_noon;
  int day_length;
  String civil_twilight_begin;
  String civil_twilight_end;
  String nautical_twilight_begin;
  String nautical_twilight_end;
  String astronomical_twilight_begin;
  String astronomical_twilight_end;

  SSModel(
      {required this.sunrise,
      required this.sunset,
      required this.solar_noon,
      required this.day_length,
      required this.civil_twilight_begin,
      required this.civil_twilight_end,
      required this.astronomical_twilight_begin,
      required this.astronomical_twilight_end,
      required this.nautical_twilight_begin,
      required this.nautical_twilight_end});

  factory SSModel.fromJson(Map<String, dynamic> json) {
    return SSModel(
        sunrise: json["results"]["sunrise"],
        sunset: json["results"]["sunset"],
        solar_noon: json["results"]["solar_noon"],
        day_length: json["results"]["day_length"],
        civil_twilight_begin: json["results"]["civil_twilight_begin"],
        civil_twilight_end: json["results"]["civil_twilight_end"],
        nautical_twilight_begin: json["results"]["nautical_twilight_begin"],
        nautical_twilight_end: json["results"]["nautical_twilight_end"],
        astronomical_twilight_begin: json["results"]
            ["astronomical_twilight_begin"],
        astronomical_twilight_end: json["results"]
            ["astronomical_twilight_end"]);
  }
}
