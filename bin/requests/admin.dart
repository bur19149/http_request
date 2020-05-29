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