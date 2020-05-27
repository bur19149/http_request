import 'package:http/http.dart' as http;
import 'debug.dart' as debug;
import 'variables.dart' as variables;
import '../projekt.dart' as projekt;
import 'dart:convert' as convert;


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

/// Lässt den Server den beim Einloggen generierten Token validieren
Future<bool> validate() async {
  debug.output(await http.get('${variables.url}/validate?token=${variables.token}'));
  return null;
}

void requestUser() async {
  var _response = await http.get('${variables.url}/user?token=${variables.token}');
  var _resp = convert.jsonDecode(_response.body);
  var _user = _resp['data']['user'];
  var _usertyp = _user['typ'];

  var permissions = <projekt.Permission>[];
  for (var p in _usertyp['permissions']) {
    permissions.add(projekt.Permission(
        p['permissionid'], p['name'], p['description'], p['code']));
  }

//  var children = <projekt.User>[];

  projekt.User(
      _user['userid'],
      _user['vorname'],
      _user['nachname'],
      _user['email'],
      _user['plz'],
      _user['ort'],
      projekt.UserTyp(_usertyp['typid'], _usertyp['name'], permissions),
      _user['jugendgruppe'],
      _user['parent'],
//          List(_user['children']),
      null,
      _user['registered'])
      .toString();

  print('\n\n\n-----------------------------------------------\n\n\n' +
      _resp.toString() +
      '\n\n\n-----------------------------------------------\n\n\n');
  debug.output(_response);
}