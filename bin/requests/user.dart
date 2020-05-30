import 'package:http/http.dart' as http;
import 'debug.dart' as debug;
import 'variables.dart' as variables;
import '../objects.dart' as objects;
import '../converter.dart' as converter;
import 'dart:convert' as convert;

  void anmeldungTermin() {
  }

  Future<List<objects.UserTermin>> requestMeineTermine() async {
  var _response = await http.get('${variables.url}/meine-termine?token=${variables.token}');
  if (_response.statusCode != 200) {
    throw Exception(
        'unvorhergesehene HTTP Rückmeldung: ${_response.statusCode}');
  }
  var terminliste = <objects.UserTermin>[];
  for (var termin in convert.jsonDecode(_response.body)['termine']) {
    terminliste.add(converter.jsonToTermin(termin));
  }
  return terminliste;
}

// TODO Exception-Handling hier ev. noch einmal überarbeiten
Future<objects.UserTermin> requestTermin(int eventID) async {
  var _response = await http.get('${variables.url}/termin?token=${variables.token}&eventid=$eventID');
  if (_response.statusCode != 200) {
    throw Exception(
        'Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}');
  }
  return converter.jsonToTermin(convert.jsonDecode(_response.body)['termin']);
}

Future<List<objects.UserTermin>> requestAlleTermine() async {
  var _response = await http.get('${variables.url}/termin?token=${variables.token}');
  if (_response.statusCode != 200) {
    throw Exception(
        'Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}');
  }
  var terminliste = <objects.UserTermin>[];
  for (var termin in convert.jsonDecode(_response.body)['termine']) {
    terminliste.add(converter.jsonToTermin(termin));
  }
  return terminliste;
}