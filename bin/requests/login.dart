import '../pruefungen.dart' as pruefungen;
import 'package:http/http.dart' as http;
import '../converter.dart' as converter;
import 'variables.dart' as variables;
import '../objects.dart' as objects;
import 'dart:convert' as convert;
import 'debug.dart' as debug;

//formatter:off
//TODO parameter name und model implemetieren
/// Wird zum Einloggen verwendet
/// value ist der Key der auf der Website generiert werden kann
void link(String value) async {
  debug.output(await http.post('${variables.url}/link', body: {
    'userkey': '$value',
    'name': 'Dominiks PC',
    'model': 'ASUS-PC',
    'version': '0.1'
  }));
}

//formatter:on
// TODO mergen von validateToken & validate
//  Future<bool> valtidateToken() async {
//    ReusableMethods.stringPrufung(variables.token);
//    var response =
//        await http.get('${variables.url}/validate?token=${variables.token}');
//    // var response=await http.get('${Verwaltung.url}validate',headers:{'token': '${Verwaltung.token}'});
//    /*for debugging*/
//    print(response.statusCode);
//    if (response.statusCode == 200) {
//      return true;
//    } else
//    // 401 = Ein solcher Token existiert nicht in der Datenbank.
//    // 403 = Der Token ist abgelaufen bzw. wurde vom User entfernt.
//    //TODO schauen ob writeFile('') den token im file überschreibt, und alle möglichkeiten triggern aka 401/403
//    if (response.statusCode == 401 || response.statusCode == 403) {
//      await variables.FileHandler.writeFile('');
//      return false;
//    }
//    throw Exception(
//        'unvorhergesehene HTTP Rückmeldung: ${response.statusCode}');
//  }
/// Lässt den Server den beim Einloggen generierten Token validieren
Future<bool> validate() async {
  debug.output(await http.get('${variables.url}/validate?token=${variables.token}'));
  //TODO
  return null;
}

void login(String value) async {
  RegExp a = RegExp(r'^[A-Za-z0-9]+$');
  if (!a.hasMatch(pruefungen.stringPrufung(value))) {
    throw ('Ungültiger UserToken.');
  } else {
    var url = '${variables.url}link';
    //TODO für model das Handy modell holen und ka was wir mit Name machen.
    var response = await http.post(url, body: {
      'userkey': '$value',
      'name': 'POST',
      'model': '???',
      'version': '${variables.appVersion}'
    });

    // API DOKU SAGT:
    // Userkey unknown: 404 Ein solcher Schlüssel existiert nicht in der Datenbank.
    // Userkey invalid: 400 Der Schlüssel ist abgelaufen oder wurde bereits erfolgreich benutzt.
    // Parameter missing: 422 Es fehlen ein oder mehr Parameter

    if (response.statusCode == 200) {
      await variables.FileHandler.writeFile(
          RegExp('.*"(.*)"}}').allMatches(response.body).toList()[0].group(1));
    } else {
      throw ('Error: Response status: ${response.statusCode}');
    }
  }
}

/// Liefert den eigenen User zurück.
/// Kann je nach Usertyp ein User-, oder ein Admin-Objekt zurückliefern.
Future<objects.User> requestUser() async {
  var _response =
      await http.get('${variables.url}/user?token=${variables.token}');
  if (_response.statusCode != 200) {
    throw Exception(
        'Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}');
  }
  return converter
      .jsonToUser(convert.jsonDecode(_response.body)['data']['user']);
}
