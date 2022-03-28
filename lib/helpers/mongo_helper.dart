import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoHelper extends Disposable {
  String get connectionString =>
      "mongodb+srv://fasting:RcmY0VWseJKPCYhn@cluster0.njavs.mongodb.net/fastingretryWrites=true&w=majority";

  dynamic updateWater(String deviceInfo, int waterOfGlasses) async {
    dynamic retVal;

    try {
      var db = await Db.create(connectionString);
      await db.open();
      var coll = db.collection('water');
      var exist = await coll.findOne({
        'device': deviceInfo,
        'date': DateFormat('dd-MM-yyyy').format(DateTime.now())
      });
      if (exist == null) {
        retVal = await coll.insertOne({
          'device': deviceInfo,
          'glassofwater': waterOfGlasses,
          'date': DateFormat('dd-MM-yyyy').format(DateTime.now())
        });
      } else {
        coll.update(where.eq('device', deviceInfo),
            modify.set('glassofwater', waterOfGlasses));
      }
      await db.close();
    } catch (e) {
      retVal = e;
    } finally {}

    return retVal;
  }

  Future<dynamic> getHowManyGlassOfWater(
    String deviceInfo,
  ) async {
    dynamic retVal;

    try {
      var db = await Db.create(connectionString);
      await db.open();
      var coll = db.collection('water');
      retVal = await coll.findOne({
        'device': deviceInfo,
        'date': DateFormat('dd-MM-yyyy').format(DateTime.now())
      });
      await db.close();
    } catch (e) {
      retVal = Future.value(e);
    } finally {}
    return Future.value(retVal);
  }

  dynamic lockDiet(String diet, String deviceInfo, bool lockStatus) async {
    dynamic retVal;

    try {
      var db = await Db.create(connectionString);
      await db.open();
      var coll = db.collection('fasting');
      var exist = await coll.findOne({'device': deviceInfo});
      if (exist == null) {
        retVal = await coll.insertOne({
          'device': deviceInfo,
          'diet': diet,
          'lockStatus': lockStatus,
          'lockDate':
              lockStatus ? DateFormat('dd-MM-yyyy').format(DateTime.now()) : "",
          'unlockDate':
              !lockStatus ? DateFormat('dd-MM-yyyy').format(DateTime.now()) : ""
        });
      } else {
        retVal = await coll.update(where.eq('device', deviceInfo),
            modify.set('lockStatus', lockStatus));
        await coll.update(
            where.eq('device', deviceInfo), modify.set('diet', diet));

        if (lockStatus) {
          await coll.update(
              where.eq('device', deviceInfo),
              modify.set(
                  'lockDate', DateFormat('dd-MM-yyyy').format(DateTime.now())));
        } else {
          await coll.update(
              where.eq('device', deviceInfo),
              modify.set('unlockDate',
                  DateFormat('dd-MM-yyyy').format(DateTime.now())));
        }
      }
      await db.close();
    } catch (e) {
      retVal = e;
    } finally {}
    return retVal;
  }

  Future<dynamic> getLockedDiet(
    String deviceInfo,
  ) async {
    dynamic retVal;

    try {
      var db = await Db.create(connectionString);
      await db.open();
      var coll = db.collection('fasting');
      retVal = await coll.findOne({'device': deviceInfo});
      db.close();
    } catch (e) {
      retVal = Future.value(e);
    } finally {}

    return Future.value(retVal);
  }

  Future<dynamic> getLastSync(
    String deviceInfo,
  ) async {
    dynamic retVal;

    try {
      var db = await Db.create(connectionString);
      await db.open();
      var coll = db.collection('sssync');
      retVal = await coll.findOne({'device': deviceInfo});
      await db.close();
    } catch (e) {
      retVal = Future.value(e);
      print(e);
    } finally {}
    return retVal;
  }

  dynamic insertLastSS(
      {required String deviceInfo,
      required DateTime sunriseTime,
      required DateTime sunsetTime,
      required DateTime civilTwilightBegin,
      required DateTime civilTwilightEnd}) async {
    dynamic retVal;
    try {
      var db = await Db.create(connectionString);
      await db.open();
      var coll = db.collection('sssync');

      retVal = await coll.insertOne({
        'device': deviceInfo,
        'syncdate': DateTime.now(),
        'sunriseTime': sunriseTime,
        'sunsetTime': sunsetTime,
        'civilTwilightBegin': civilTwilightBegin,
        'civilTwilightEnd': civilTwilightEnd,
      });
      await db.close();
    } catch (e) {
      retVal = Future.value(e);
      print(e);
    } finally {}
    return retVal;
  }

  @override
  FutureOr onDispose() {
    // throw UnimplementedError();
  }
}
