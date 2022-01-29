import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoHelper {
  static Db? _db;

  static String _getConnectionString() {
    return "mongodb+srv://fasting:bWX9vvD3l1HWiRtE@cluster0.njavs.mongodb.net/fasting";
  }

  static Future getDB() async {
    if (_db == null) {
      _db = await Db.create(_getConnectionString());
      await _db!.open();
    }
    if (_db != null && _db!.isConnected && _db!.state == State.OPEN) {
      return _db;
    }
    await _db!.close();
    await _db!.open();
    if (_db != null && _db!.isConnected && _db!.state == State.OPEN) {
      return _db;
    }

    return null;
  }

  Future cleanupDatabase() async {
    await _db!.close();
  }

  static dynamic updateWater(String deviceInfo, int waterOfGlasses) {
    getDB().then((db) async {
      if (db != null) {
        var coll = db.collection('water');
        var exist = await coll.findOne({
          'device': deviceInfo,
          'date': DateFormat('dd-MM-yyyy').format(DateTime.now())
        });
        if (exist == null) {
          await coll.insertOne({
            'device': deviceInfo,
            'glassofwater': waterOfGlasses,
            'date': DateFormat('dd-MM-yyyy').format(DateTime.now())
          });
        } else {
          coll.update(where.eq('device', deviceInfo),
              modify.set('glassofwater', waterOfGlasses));
        }
      }
    });
  }

  static Future<dynamic> getHowManyGlassOfWater(
    String deviceInfo,
  ) async {
    var db = await getDB();
    var coll = db.collection('water');
    return await coll.findOne({
      'device': deviceInfo,
      'date': DateFormat('dd-MM-yyyy').format(DateTime.now())
    });
  }

  static dynamic lockDiet(
      String diet, String deviceInfo, bool lockStatus) async {
    return getDB().then((db) async {
      if (db != null) {
        var coll = db.collection('fasting');
        var exist = await coll.findOne({'device': deviceInfo});
        if (exist == null) {
          await coll.insertOne({
            'device': deviceInfo,
            'diet': diet,
            'lockStatus': lockStatus,
            'lockDate': lockStatus
                ? DateFormat('dd-MM-yyyy').format(DateTime.now())
                : "",
            'unlockDate': !lockStatus
                ? DateFormat('dd-MM-yyyy').format(DateTime.now())
                : ""
          });
        } else {
          await coll.update(where.eq('device', deviceInfo),
              modify.set('lockStatus', lockStatus));
          await coll.update(
              where.eq('device', deviceInfo), modify.set('diet', diet));

          if (lockStatus) {
            await coll.update(
                where.eq('device', deviceInfo),
                modify.set('lockDate',
                    DateFormat('dd-MM-yyyy').format(DateTime.now())));
          } else {
            await coll.update(
                where.eq('device', deviceInfo),
                modify.set('unlockDate',
                    DateFormat('dd-MM-yyyy').format(DateTime.now())));
          }
        }
      }
    });
  }

  static Future<dynamic> getLockedDiet(
    String deviceInfo,
  ) async {
    var db = await getDB();
    var coll = db.collection('fasting');
    return await coll.findOne({'device': deviceInfo});
  }
}
