// ignore_for_file: file_names
import 'package:fasting/helpers/device_info_helper.dart';
import 'package:fasting/helpers/mongo_helper.dart';
import 'package:fasting/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class Diet168 extends StatefulWidget {
  const Diet168({Key? key}) : super(key: key);

  @override
  State<Diet168> createState() => Diet168State();
}

class Diet168State extends State<Diet168> {
  int howManyDaysPast = 0;
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    DeviceInfoHelper.getDeviceInfo().then((value) async {
      var dietList = await MongoHelper().getLockedDiet(value!);
      if (dietList != null) {
        // "2012-02-27"
        if (dietList is Map) {
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
        } else {
          // MessageBoxHelper.show(context, "Error", dietList.toString(), () {});
          print(dietList);
        }
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
        itemCount: 8,
        itemBuilder: (context, index) {
          Widget retVal = Container();

          if (index == 0) {
            retVal = Padding(
                padding: const EdgeInsets.only(right: 5),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5)),
                      CText(
                        AppLocalizations.of(context)!.midnight.toUpperCase(),
                        fontWeight: FontWeight.bold,
                      ),
                      CText(
                        "04:00",
                        fontWeight: FontWeight.bold,
                      ),
                      CText(
                        "08:00",
                        fontWeight: FontWeight.bold,
                      ),
                      CText(
                        "12:00",
                        fontWeight: FontWeight.bold,
                      ),
                      CText(
                        "16:00",
                        fontWeight: FontWeight.bold,
                      ),
                      CText(
                        "20:00",
                        fontWeight: FontWeight.bold,
                      ),
                      CText(
                        AppLocalizations.of(context)!.midnight.toUpperCase(),
                        fontWeight: FontWeight.bold,
                      )
                    ],
                  ),
                ));
          } else {
            retVal = Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width / 3,
                    child: dayCard(index)));
          }
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
        },
      ),
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
        Container(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
          // constraints:
          //     const BoxConstraints(maxWidth: 200, minWidth: 200),
          alignment: Alignment.center,
          child: CText(
            AppLocalizations.of(context)!.fast.toUpperCase(),
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              color: Colors.amber,
              border: Border(bottom: BorderSide(color: Colors.white))),
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          alignment: Alignment.center,
          child: CText(
            AppLocalizations.of(context)!.firstmeal,
          ),
        ),
        Container(
          color: Colors.amber,
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          alignment: Alignment.center,
          child: Column(children: [
            CText(
              AppLocalizations.of(context)!.lastmeal,
            ),
            CText(
              AppLocalizations.of(context)!.by8PM,
            )
          ]),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          alignment: Alignment.center,
          child: CText(
            AppLocalizations.of(context)!.fast.toUpperCase(),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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
