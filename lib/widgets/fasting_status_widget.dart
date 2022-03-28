import 'package:fasting/helpers/device_info_helper.dart';
import 'package:fasting/helpers/messagebox_helper.dart';
import 'package:fasting/helpers/mongo_helper.dart';
import 'package:fasting/widgets/diets/14_10_diet_widget.dart';
import 'package:fasting/widgets/diets/16_8_diet_widget.dart';
import 'package:fasting/widgets/diets/5_2_diet_widget.dart';
import 'package:fasting/widgets/diets/alternate_day_widget.dart';
import 'package:fasting/widgets/diets/eat_stop_eat_widget.dart';
import 'package:fasting/widgets/diets/warrior_diet_widget.dart';
import 'package:fasting/widgets/loading_widget.dart';
import 'package:fasting/widgets/slideable_widget.dart';
import 'package:flutter/material.dart';

class FastingStatus extends StatefulWidget {
  const FastingStatus({Key? key}) : super(key: key);

  @override
  State<FastingStatus> createState() => _FastingStatusState();
}

class _FastingStatusState extends State<FastingStatus> {
  List<SlidableWidgetProps> fastingTypes = [];
  bool loaded = false;
  String deviceInfo = "";
  bool lock = false;
// some global place
  final customWidgetKey = GlobalKey<State<SlidableWidget>>();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    fastingTypes.clear();

    fastingTypes.add(SlidableWidgetProps(
        key: "1", title: "The 16:8 Diet", child: const Diet168()));
    fastingTypes.add(SlidableWidgetProps(
        key: "2", title: "The 5:2 method", child: const Diet52()));
    fastingTypes.add(SlidableWidgetProps(
        key: "3",
        title: "Alternate-day fasting",
        child: const AlternateDayFasting()));
    fastingTypes.add(SlidableWidgetProps(
        key: "4", title: "Eat-stop-eat Diet", child: const EatStopEat()));
    fastingTypes.add(SlidableWidgetProps(
        key: "5", title: "The 14:10 Diet", child: const Diet1410()));
    fastingTypes.add(SlidableWidgetProps(
        key: "6", title: "The Warrior Diet", child: const WarriorDiet()));

    DeviceInfoHelper.getDeviceInfo().then((value) async {
      deviceInfo = value!;
      var dietList = await MongoHelper().getLockedDiet(deviceInfo);

      if (dietList != null) {
        if (dietList is Map) {
          lock = dietList['lockStatus'];
          fastingTypes
              .singleWhere((element) =>
                  element.key == dietList['diet'].toString().trim())
              .selected = true;
        } else {
          MessageBoxHelper.show(context, "Error", dietList.toString(), () {});
        }
      }
      setState(() {
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
        loaded: loaded,
        child: SlidableWidget(
          key: customWidgetKey,
          list: fastingTypes,
          lock: lock,
          // afterPrevious: (oldContainer, previousContainer) {
          //   print(oldContainer.title);
          //   print(previousContainer.title);
          // },
          // afterNext: (oldContainer, nextContainer) {
          //   print(oldContainer.title);
          //   print(nextContainer.title);
          // },
          onLock: (activeContainer, lockStatus) {
            print(activeContainer.title + " is " + lockStatus.toString());
            MongoHelper()
                .lockDiet(activeContainer.key!, deviceInfo, lockStatus);
          },
        ));
  }

  bool fastingstatus() {
    return DateTime.now().hour >= 12 && DateTime.now().hour <= 16;
  }
}
