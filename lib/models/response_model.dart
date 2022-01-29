class ResponseModel {
  int resCode;
  String resMessage;
  String resData;

  ResponseModel(
      {required this.resCode, required this.resMessage, required this.resData});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
        resCode: json['resCode'],
        resMessage: json['resMessage'],
        resData: json['resData']);
  }
}
