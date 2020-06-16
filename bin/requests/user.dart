import 'package:http/http.dart' as http;

//import 'debug.dart' as debug;
import '../exceptions.dart';
import 'variables.dart' as variables;
import '../objects.dart' as objects;
import '../converter.dart' as converter;
import 'dart:convert' as convert;

//@formatter:off
  anmeldungTermin(int eventID, [int userID]) async {
    var parameters = <String, String>{};
                       parameters['token']   = variables.token;
                       parameters['eventid'] = '$eventID';
    if(userID != null) parameters['userid']  = '$userID';

    var _response = await http.patch('${variables.url}/termin/anmelden/', body: parameters);
    if(_response.statusCode != 201 && _response.statusCode != 204) {
      throw exceptionHandler(_response.statusCode, c404: 'Termin existiert nicht / Userid unbekannt',
                                                   c423: 'Termin ist noch nicht sichtbar',
                                                   c410: 'Anmeldung geschlossen');
    }
  }

//TODO API Dokumentation ist noch nicht fertig -> Wegen den Exceptions.
  void abmeldungTermin(int eventID, [int userID]) async { // @formatter:off
  var parameters = <String, String>{};
                     parameters['token']   = variables.token;
                     parameters['eventid'] = '$eventID';
  if(userID != null) parameters['userid']  = '$userID';

  var _response = await http.patch('${variables.url}/termin/abmelden', body: parameters);
  if (_response.statusCode != 204) throw exceptionHandler(_response.statusCode, c404: 'Termin existiert nicht / Userid unbekannt');
} // @formatter:on

/// "4.7.4 Meine Termine
/// Endpunkt, um eigene Termine anzeigen zu lassen. Es werden nur Termine angezeigt, die noch nicht
/// stattgefunden haben und zu denen der User oder ein verbundener Account angemeldet ist. Die
/// Leiter Antwort ist dabei egal. [...]"
///
/// Dokumentation der API-Doku v2.5 v. Tobias Möller entnommen
Future<List<objects.UserTermin>> requestMeineTermine() async { // @formatter:off
  var _response = await http.get('${variables.url}/meine-termine?token=${variables.token}');
  if (_response.statusCode != 200) throw exceptionHandler(_response.statusCode);
  var terminliste = <objects.UserTermin>[];
  for (var termin in convert.jsonDecode(_response.body)['termine']) {
    terminliste.add(converter.jsonToTermin(termin));
  }
  return terminliste;
} // @formatter:on

// TODO Exception-Handling hier ev. noch einmal überarbeiten
Future<objects.UserTermin> requestTermin(int eventID) async {
  var _response = await http
      .get('${variables.url}/termin?token=${variables.token}&eventid=$eventID');
  if (_response.statusCode != 200) throw exceptionHandler(_response.statusCode);
  return converter.jsonToTermin(convert.jsonDecode(_response.body)['termin']);
}

/// "4.7.5 Alle Termine
/// Endpunkt, um alle anstehenden Termine anzeigen zu lassen. Es werden nur Termine angezeigt, die
/// noch nicht stattgefunden haben und die als sichtbar eingetragen sind. Es werden auch Termine
/// angezeigt, bei denen die Anmeldung bereits beendet ist. [...]"
///
/// Dokumentation der API-Doku v2.5 v. Tobias Möller entnommen
Future<List<objects.UserTermin>> requestAlleTermine() async { // @foramtter:off
  var _response = await http.get('${variables.url}/termin?token=${variables.token}');
  if (_response.statusCode != 200) throw exceptionHandler(_response.statusCode);
  var terminliste = <objects.UserTermin>[];
  for (var termin in convert.jsonDecode(_response.body)['termine']) {
    terminliste.add(converter.jsonToTermin(termin));
  }
  return terminliste;
} // @formatter:on