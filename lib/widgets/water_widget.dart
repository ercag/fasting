import 'package:fasting/helpers/device_info_helper.dart';
import 'package:fasting/helpers/mongo_helper.dart';
import 'package:fasting/widgets/loading_widget.dart';
import 'package:fasting/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WaterWidget extends StatefulWidget {
  const WaterWidget({Key? key}) : super(key: key);

  @override
  State<WaterWidget> createState() => _WaterWidgetState();
}

class _WaterWidgetState extends State<WaterWidget> {
  int glassOfWater = 0;
  int oneGlassOfWater = 200; //200ml
  String deviceInfo = "";
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    deviceInfo = (await DeviceInfoHelper.getDeviceInfo())!;
    var mGlass = await MongoHelper().getHowManyGlassOfWater(deviceInfo);
    if (mGlass != null) {
      if (mGlass is Map) {
        glassOfWater = mGlass['glassofwater'];
      } else {
        // MessageBoxHelper.show(context, "Error", mGlass.toString(), () {});
        print(mGlass);
      }
    }
    setState(() {
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
        loaded: loaded,
        child: Stack(children: [
          Row(
            children: [
              Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: glassOfWater < 1
                              ? null
                              : () {
                                  setState(() {
                                    glassOfWater--;
                                  });
                                  MongoHelper()
                                      .updateWater(deviceInfo, glassOfWater);
                                },
                          icon: const Icon(Icons.remove)),
                      SizedBox(
                        width: 64,
                        child: Image.asset("assets/images/glassofwater.png"),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              glassOfWater++;
                            });
                            MongoHelper().updateWater(deviceInfo, glassOfWater);
                          },
                          icon: const Icon(Icons.add)),
                    ],
                  )),
              Expanded(
                  flex: 5,
                  child: Row(children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CText("${calcGlassOfWater()}"),
                          CText(AppLocalizations.of(context)!.liter)
                        ]),
                    Expanded(child: createLiter(calcGlassOfWater()))
                  ]))
            ],
          )
        ]));
  }

  double calcGlassOfWater() {
    double retVal = 0;

    try {
      retVal = (glassOfWater * oneGlassOfWater) / 1000;
    } catch (e) {
      //for: divide by zero
      retVal = 0;
    }

    return retVal;
  }

  Widget createLiter(double howMany) {
    return howMany.toInt() == 0
        ? Container()
        : SizedBox(
            height: 50,
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: howMany.toInt(),
              itemBuilder: (context, index) {
                return Stack(children: [
                  Image.asset("assets/images/liter.png"),
                  CText(
                    "${index + 1}",
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  )
                ]);
              },
            ));
  }
}
