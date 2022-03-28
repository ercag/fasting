import 'package:fasting/helpers/device_info_helper.dart';
import 'package:fasting/helpers/location_helper.dart';
import 'package:fasting/helpers/messagebox_helper.dart';
import 'package:fasting/helpers/mongo_helper.dart';
import 'package:fasting/services/fasting_service.dart';
import 'package:fasting/widgets/loading_widget.dart';
import 'package:fasting/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slide_digital_clock/slide_digital_clock.dart';

class SSWidget extends StatefulWidget {
  const SSWidget({Key? key}) : super(key: key);

  @override
  State<SSWidget> createState() => _SSWidgetState();
}

class _SSWidgetState extends State<SSWidget> {
  DateTime? sunsetTime;
  DateTime? sunriseTime;
  DateTime? civilTwilightBegin;
  DateTime? civilTwilightEnd;
  String imagePath = "assets/images/hendrik-kespohl-UPnxtRNH8q8-unsplash.jpg";
  bool loaded = false;

  @override
  void initState() {
    super.initState();

    try {
      initasync();
    } catch (e) {
      // Helper.show(context, "Error", e.toString(), () {});
      print(e);
    }
  }

  void initasync() async {
    var lastSync = await MongoHelper()
        .getLastSync((await DeviceInfoHelper.getDeviceInfo())!);

    if (lastSync == null) {
      var pos = await LocationHelper.determinePosition();
      getSSInfo(pos.latitude, pos.longitude);
    } else {
      if (lastSync is Map) {
        sunriseTime =
            DateFormat('yyyy-MM-ddThh:mm:ss').parse(lastSync["sunrise"]);
        sunsetTime =
            DateFormat('yyyy-MM-ddThh:mm:ss').parse(lastSync["sunset"]);
        civilTwilightBegin = DateFormat('yyyy-MM-ddThh:mm:ss')
            .parse(lastSync["civil_twilight_begin"]);
        civilTwilightEnd = DateFormat('yyyy-MM-ddThh:mm:ss')
            .parse(lastSync["astronomical_twilight_end"]);
      } else {
        MessageBoxHelper.show(context, "Error", lastSync.toString(), () {});
      }
    }
  }

  void getSSInfo(double? lat, double? lng) {
    // print("Lat: $lat - Lng: $lng - Date: ${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}");

    FastingService.getSS(lat.toString(), lng.toString(), "today")
        .then((value) async {
      await MongoHelper().insertLastSS(
          deviceInfo: (await DeviceInfoHelper.getDeviceInfo())!,
          sunriseTime: DateFormat('yyyy-MM-ddThh:mm:ss').parse(value.sunrise),
          sunsetTime: DateFormat('yyyy-MM-ddThh:mm:ss').parse(value.sunset),
          civilTwilightBegin: DateFormat('yyyy-MM-ddThh:mm:ss')
              .parse(value.civil_twilight_begin),
          civilTwilightEnd: DateFormat('yyyy-MM-ddThh:mm:ss')
              .parse(value.astronomical_twilight_end));
      setState(() {
        sunriseTime = DateFormat('yyyy-MM-ddThh:mm:ss').parse(value.sunrise);
        sunsetTime = DateFormat('yyyy-MM-ddThh:mm:ss').parse(value.sunset);
        civilTwilightBegin =
            DateFormat('yyyy-MM-ddThh:mm:ss').parse(value.civil_twilight_begin);
        civilTwilightEnd = DateFormat('yyyy-MM-ddThh:mm:ss')
            .parse(value.astronomical_twilight_end);

        imagePath = pickImage();
        loaded = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
        loaded: loaded,
        child: Stack(children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        colorFilter: const ColorFilter.mode(
                            Colors.black, BlendMode.softLight),
                        image: ExactAssetImage(imagePath),
                        fit: BoxFit.cover)),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3,
                      color: Colors.transparent,
                      child: CustomPaint(
                        painter: CurvePainter(),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CText(
                                  sunriseTime == null
                                      ? ""
                                      : "${sunriseTime!.hour}:${sunriseTime!.minute}",
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: DigitalClock(
                                      areaHeight: 60,
                                      areaDecoration: const BoxDecoration(
                                          color: Colors.transparent),
                                    )),
                                CText(
                                  sunsetTime == null
                                      ? ""
                                      : "${sunsetTime!.hour}:${sunsetTime!.minute}",
                                  fontSize: 16,
                                  color: Colors.white,
                                )
                              ],
                            )))
                  ],
                ),
              )
            ],
          ),
        ]));
  }

  String pickImage() {
    DateTime currentDate = DateTime.now();
    if (sunriseTime != null && sunsetTime != null) {
      // print("currentTime: ${currentDate.hour}:${currentDate.minute} - SunriseTime: ${sunriseTime!.hour}:${sunriseTime!.minute} - Sunset Time: ${sunsetTime!.hour}:${sunriseTime!.minute}");
      if (currentDate.hour <= sunriseTime!.hour &&
          currentDate.hour >= civilTwilightBegin!.hour) {
//sunrising
        // print("sunrising");
        return "assets/images/dawid-zawila--G3rw6Y02D0-unsplash.jpg";
      }

      if ((currentDate.hour >= sunriseTime!.hour) &&
          currentDate.hour <= sunsetTime!.hour) {
        //noon
        // print("noon");
        return "assets/images/hendrik-kespohl-UPnxtRNH8q8-unsplash.jpg";
      }

      if (currentDate.hour >= sunsetTime!.hour &&
          currentDate.hour <=
              civilTwilightEnd!.add(const Duration(hours: 2)).hour) {
        //sunset
        // print("sunset");
        return "assets/images/jordan-wozniak-xP_AGmeEa6s-unsplash.jpg";
      }

      if (currentDate.hour >=
          civilTwilightEnd!.add(const Duration(hours: 2)).hour) {
        //twilight
        // print("twilight");
        return "assets/images/joshua-song-4JRSVcXuI90-unsplash.jpg";
      }
    }

    return "";
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.brown;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;

    paint.strokeWidth = 2;

    var leftCurvePath = Path();
    leftCurvePath.moveTo(size.width / 8, size.height - 40);
    //x1,y1,x2,y2
    //Bezier Curves draw with the control point
    //So x1,x2 is the line width actually
    //and y1 / y2 is the control point.
    //ref: https://medium.com/flutter-community/paths-in-flutter-a-visual-guide-6c906464dcd0
    leftCurvePath.quadraticBezierTo(
        size.width / 15, size.height, 0, size.height);

    canvas.drawPath(leftCurvePath, paint);

    var rightCurvePath = Path();
    rightCurvePath.moveTo(size.width - 49, size.height - 40);
    //x1,y1,x2,y2
    //Bezier Curves draw with the control point
    //So x1,x2 is the line width actually
    //and y1 / y2 is the control point.
    //ref: https://medium.com/flutter-community/paths-in-flutter-a-visual-guide-6c906464dcd0
    rightCurvePath.quadraticBezierTo(
        size.width - 20, size.height, size.width * 1.1, size.height);

    canvas.drawPath(rightCurvePath, paint);

    paint.strokeWidth = 3;
    paint.color = Colors.brown;

    var curvePath = Path();
    curvePath.moveTo(size.width / 8, size.height - 40);
    //x1,y1,x2,y2
    //Bezier Curves draw with the control point
    //So x1,x2 is the line width actually
    //and y1 / y2 is the control point.
    //ref: https://medium.com/flutter-community/paths-in-flutter-a-visual-guide-6c906464dcd0
    curvePath.quadraticBezierTo(size.width / 2, (size.height / 100) * -1,
        size.width - (size.width / 8), size.height - 40);
    canvas.drawPath(curvePath, paint);

    var linePath = Path();
    linePath.moveTo(0, size.height - 40);
    linePath.relativeLineTo(size.width, 0);

    paint.strokeWidth = 2;

    canvas.drawPath(linePath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
