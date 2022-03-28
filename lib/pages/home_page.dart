// ignore_for_file: prefer_const_constructors_in_immutables
import 'package:fasting/widgets/fasting_status_widget.dart';
import 'package:fasting/widgets/ss_widget.dart';
import 'package:fasting/widgets/text_widget.dart';
import 'package:fasting/widgets/water_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CText(AppLocalizations.of(context)!.appname),
        actions: const [
          // TextButton(
          //     onPressed: () {
          //       // Navigator.of(context).push(
          //       //   MaterialPageRoute<void>(
          //       //     builder: (BuildContext context) => DummyPage(),
          //       //   ),
          //       // );
          //       MessageBoxHelper.show(context, "Title", "Description", () {
          //         Navigator.of(context).pop();
          //       });
          //     },
          //     child: CText(
          //       "Info",
          //       color: Colors.black,
          //     )),
          // TextButton(
          //     onPressed: () {
          //       // Navigator.of(context).push(
          //       //   MaterialPageRoute<void>(
          //       //     builder: (BuildContext context) => DummyPage(),
          //       //   ),
          //       // );
          //       // MessageBoxHelper.showQuestion(
          //       //     context, "Propose!", "Will your marry me ?", () {
          //       //   MessageBoxHelper.displaySnackbar(
          //       //       context, "She said yes! :)", null, () {});
          //       //   Navigator.of(context).pop();
          //       // }, () {
          //       //   MessageBoxHelper.displaySnackbar(
          //       //       context, "She said no :(", null, () {});
          //       //   Navigator.of(context).pop();
          //       // });
          //     },
          //     child: CText(
          //       "Propose",
          //       color: Colors.black,
          //     ))
        ],
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          // Text(AppLocalizations.of(context)!.appname),
          SSWidget(),
          Padding(
            padding: EdgeInsets.all(1),
            child: Divider(),
          ),
          FastingStatus(),
          Padding(
            padding: EdgeInsets.all(1),
            child: Divider(),
          ),
          WaterWidget(),
          Padding(padding: EdgeInsets.only(bottom: 20))
        ],
      )),
    );
  }
}
