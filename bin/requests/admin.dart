import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import '../converter.dart' as converter;
import '../objects.dart' as objects;
import 'variables.dart' as variables;

Future<List<objects.Zyklus>> requestZyklen() async {
  var _response =
  await http.get('${variables.url}/zyklus?token=${variables.token}');
  if (_response.statusCode != 200) {
    throw Exception(
        'Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}');
  }
  var zyklen = <objects.Zyklus>[];
  for (var zyklus in convert.jsonDecode(_response.body)['zyklus_list']) {
    zyklen.add(converter.jsonToZyklus(zyklus));
  }
  return zyklen;
}

abstract class User {
  static Future<objects.User> requestUser(int userID) async {
    var _response =
    await http.get('${variables.url}/admin/user?token=${variables
        .token}&userid=${userID}');
    if (_response.statusCode != 200) {
      throw Exception(
          'Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}');
    }
    return converter
        .jsonToUser(convert.jsonDecode(_response.body)['data']['user']);
  }

  static Future<List<objects.User>> requestUserListe() async {
    var _response =
    await http.get('${variables.url}/admin/user?token=${variables.token}');
    if (_response.statusCode != 200) {
      throw Exception(
          'Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}');
    }
    var userliste = <objects.User>[];
    for (var user in convert.jsonDecode(_response.body)['data']['users']) {
      userliste.add(converter.jsonToUser(user));
    }
    return userliste;
  }
}


abstract class Termin {}
