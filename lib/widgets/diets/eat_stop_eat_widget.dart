import 'package:fasting/helpers/device_info_helper.dart';
import 'package:fasting/helpers/mongo_helper.dart';
import 'package:fasting/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class EatStopEat extends StatefulWidget {
  const EatStopEat({Key? key}) : super(key: key);

  @override
  State<EatStopEat> createState() => _EatStopEatState();
}

class _EatStopEatState extends State<EatStopEat> {
  int howManyDaysPast = 0;
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    DeviceInfoHelper.getDeviceInfo().then((value) async {
      var dietList = await MongoHelper.getLockedDiet(value!);
      if (dietList != null) {
        // "2012-02-27"

        DateTime lockedDate =
            DateFormat('dd-MM-yyyy').parse(dietList['lockDate']);
        setState(() {
          howManyDaysPast =
              (DateTime.now().difference(lockedDate).inHours / 24).round();
          // if (howManyDaysPast > 7) {
          while (howManyDaysPast > 7) {
            howManyDaysPast = howManyDaysPast - 7;
          }
          // }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan[200],
      height: 300,
      child: ListView.builder(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (context, index) {
            Widget retVal = Container();

            retVal = Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width / 3,
                    child: dayCard(index + 1)));

            if (index < howManyDaysPast) {
              retVal = Stack(
                children: [retVal, passWidget()],
              );
            }
            if (index == howManyDaysPast) {
              //this must be a current day
              retVal = Stack(
                children: [retVal, currentWidget()],
              );
            }
            return retVal;
          }),
    );
  }

  Widget dayCard(int index) {
    return Column(
      children: [
        Container(
          color: Colors.orange,
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          alignment: Alignment.center,
          child: CText(
            "${AppLocalizations.of(context)!.day} $index",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            if (index == 2 || index == 5) {
              return Container(
                  padding: const EdgeInsets.fromLTRB(0, 100, 0, 100),
                  // constraints:
                  //     const BoxConstraints(maxWidth: 200, minWidth: 200),
                  alignment: Alignment.center,
                  child: Column(children: [
                    CText(
                      AppLocalizations.of(context)!.twentyfourhour,
                      fontWeight: FontWeight.bold,
                    ),
                    CText(
                      AppLocalizations.of(context)!.fast,
                      fontWeight: FontWeight.bold,
                    ),
                  ]));
            } else {
              return skipContainer();
            }
          },
        )
      ],
    );
  }

  Widget skipContainer() {
    return Container(
      color: Colors.amberAccent,
      padding: const EdgeInsets.fromLTRB(0, 100, 0, 100),
      width: MediaQuery.of(context).size.width / 3,
      height: 266,
      child: Column(
        children: [
          CText(
            AppLocalizations.of(context)!.eat,
            fontWeight: FontWeight.bold,
          ),
          CText(
            AppLocalizations.of(context)!.normally,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget passWidget() {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      height: 266,
      color: Colors.black.withAlpha(210),
      child: const Center(
          child: Icon(
        Icons.done_all_outlined,
        color: Colors.green,
        size: 64,
      )),
    );
  }

  Widget currentWidget() {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      height: 266,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
            Colors.brown.withAlpha(100),
            Colors.white.withAlpha(50)
          ])),
      child: const Align(
          alignment: Alignment.bottomCenter,
          child: Icon(
            Icons.grass,
            color: Colors.green,
            size: 64,
          )),
    );
  }
}
