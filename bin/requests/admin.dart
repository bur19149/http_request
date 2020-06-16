import 'package:http/http.dart' as http;
import '../converter.dart' as converter;
import '../exceptions.dart';
import 'variables.dart' as variables;
import '../objects.dart' as objects;
import 'dart:convert' as convert;

/// "4.7.15 Zyklus abfragen
/// Endpunkt, um alle Termin Wiederholzyklen zu bekommen. [...]"
///
/// Dokumentation der API-Doku v2.5 v. Tobias Möller entnommen
Future<List<objects.Zyklus>> requestZyklen() async { // @formatter:off
  var _response = await http.get('${variables.url}/zyklus?token=${variables.token}');
  if (_response.statusCode != 200) {
    throw Exception('Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}');
  }
  var zyklen = <objects.Zyklus>[];
  for (var zyklus in convert.jsonDecode(_response.body)['zyklus_list']) {
    zyklen.add(converter.jsonToZyklus(zyklus));
  }
  return zyklen;
} // @formatter:on

abstract class User {
  //TODO for GUI PGM'er pfuefung ob mindestens ein optionaler Parameter dabei sind
  // @formatter:off
  static void bearbeiteUser(int userID,
      [String vorname, String nachname, String email, String plz, String ort, String jugendgruppe,
        int berechtigung, int elternID, String elternmail]) async {

    var parameter = <String, String>{};
                              parameter['token']        = variables.token;
                              parameter['userid']       = '$userID';
    if (vorname      != null) parameter['vorname']      = vorname;
    if (nachname     != null) parameter['nachname']     = nachname;
    if (email        != null) parameter['email']        = email;
    if (plz          != null) parameter['plz']          = plz;
    if (ort          != null) parameter['ort']          = ort;
    if (jugendgruppe != null) parameter['jugendgruppe'] = jugendgruppe;
    if (berechtigung != null) parameter['berechtigung'] = '$berechtigung';
    if (elternID     != null) parameter['elternID']     = '$elternID';
    if (elternmail   != null) parameter['elternmail']   = elternmail;

    var _response = await http.patch('${variables.url}/admin/user/', body: parameter);
    if (_response.statusCode != 204) {
      throw exceptionHandler(_response.statusCode, c404: 'Der Angefragte User existiert nicht',
                                                   c422: 'Es fehlt ein Parameter');
    }
  } // @formatter:on

  static void loescheUser(int id) async { // @formatter:off
    var _response = await http.delete('${variables.url}/admin/user?token=${variables.token}&userid=$id');
    if (_response.statusCode != 204) {
      throw exceptionHandler(_response.statusCode, c404: 'Der Angefragte User existiert nicht',
                                                   c422: 'Es fehlt ein Parameter');
    }
  } // @formatter:on

//TODO funktioniert nicht
//  static void erstelleUser(
//      String vorname, String nachname, int berechtigung, String plz, String ort,
//      [String jugendgruppe, int elternid, String elternemail, String email]) async {
//    var _response = await http.post(
//        '${variables.url}/admin/user?token=${variables.token}&vorname=$vorname&nachname=$nachname&berechtigung=$berechtigung&plz=$plz&ort=$ort' +
//            (jugendgruppe != null ? '&jugendgruppe=$jugendgruppe' : '') +
//            (elternid != null ? '&elternid=$elternid' : '') +
//            (elternemail != null ? '&elternemail=$elternemail' : '') +
//            (email != null ? '&email=$email' : ''));
////  var body = {};
////  body.
////    var _response = await http.post(
////        '${variables.url}/admin/user', body: {'token': variables.token, 'vorname': vorname, 'nachname': nachname, 'berechtigung': '$berechtigung', 'plz': plz, 'ort': ort/*,
////            jugendgruppe != null ? 'jugendgruppe': jugendgruppe' : null,
////            (elternid != null ? '&elternid=$elternid' : ''),
////            (elternemail != null ? '&elternemail=$elternemail' : ''),
////            (email != null ? '&email=$email' : '')*/});
//    if(_response.statusCode != 200) {
//      throw Exception(
//          'Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}');
//    }
//  }

  /// "4.7.25 Admin User Daten
  /// Endpunkt, um die Daten über einen User zu bekommen. Es muss die Userid [...]
  /// übergeben werden."
  ///
  /// Dokumentation der API-Doku v2.5 v. Tobias Möller entnommen
  static Future<objects.User> requestUser(int userID) async { // @formatter:off
    var _response = await http.get('${variables.url}/admin/user?token=${variables.token}&userid=${userID}');
    if (_response.statusCode != 200) {
      throw Exception('Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}');
    }
    return converter.jsonToUser(convert.jsonDecode(_response.body)['data']['user']);
  } // @formatter:on

  /// "4.7.24 Admin Userliste
  /// Endpunkt, um eine Userliste nach ID sortiert von allen Usern zu bekommen. [...]"
  ///
  /// Dokumentation der API-Doku v2.5 v. Tobias Möller entnommen
  static Future<List<objects.User>> requestUserListe() async { // @formatter:off
    var _response = await http.get('${variables.url}/admin/user?token=${variables.token}');
    if (_response.statusCode != 200) {
      throw Exception('Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}');
    }
    var userliste = <objects.User>[];
    for (var user in convert.jsonDecode(_response.body)['data']['users']) {
      userliste.add(converter.jsonToUser(user));
    }
    return userliste;
  } // @formatter:on
}

abstract class Termin {

  static void erstelleTermin(objects.AdminTermin termin) async { // @formatter:off

    var _parameters = <String, String>{};
                                       _parameters['token']        = variables.token;
                                       _parameters['name']         = termin.name;
                                       _parameters['beschreibung'] = termin.beschreibung;
                                       _parameters['ort']          = termin.ort;
                                       _parameters['start_datum']  = '${converter.dateTimeFormat(termin.timeVon)}';
                                       _parameters['end_datum']    = '${converter.dateTimeFormat(termin.timeBis)}';
                                       _parameters['zyklusid']     = '${termin.zyklus.zyklusID}';
//                                     _parameters['zyklus_ende']  = '${termin.zyklus. }'; TODO
                                       _parameters['plaetze']      = '${termin.plaetze}';
    if (termin.freigeschaltet != null) _parameters['oeffentlich']  = '${termin.freigeschaltet}';
    if (termin.anmeldungStart != null) _parameters['sichtbar_ab']  = '${converter.dateTimeFormat(termin.anmeldungStart)}';
    if (termin.anmeldungEnde  != null) _parameters['sichtbar_bis'] = '${converter.dateTimeFormat(termin.anmeldungEnde)}';

    var _response = await http.post('${variables.url}/admin/termin', body: _parameters);
    if (_response.statusCode != 201) {
      if (_response.statusCode == 400) {
        throw Exception('Termin konnte nicht angelegt werden.');
      } else if (_response.statusCode == 422) {
        throw Exception('Ein Parameter fehlt.');
      }
      throw Exception('Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}');
    }
  } // @formatter:on

  /// "4.7.17 Admin Termin anzeigen
  /// Endpunkt, um den Termin, alle Anmeldungen, und alle Abmeldungen anzuzeigen. Als Parameter
  /// \[wird\] die Terminid [...] übergeben."
  ///
  /// Dokumentation der API-Doku v2.5 v. Tobias Möller entnommen
  static Future<objects.AdminTermin> requestTermin(int eventID) async { // @formatter:off
    var _response = await http.get('${variables.url}/admin/termin?token=${variables.token}&eventid=$eventID');
    if (_response.statusCode != 200) {
      throw Exception('Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}');
    }
    return converter.jsonToTermin(convert.jsonDecode(_response.body)['termin']);
  } // @formatter:on

  /// "4.7.16 Admin Terminliste
  /// Endpunkt, um alle Termine anzufragen. Es werden alle Termine, auch noch nicht veröffentlichte,
  /// sortiert nach ID ausgegeben. Wenn der Parameter archive auf true gesetzt ist werden alle Termine
  /// bis zum aktuellen Zeitpunkt ausgegeben. Ist archive false werden alle anstehenden, Termin Start in
  /// der Zukunft, ausgegeben. Parameter \[ist\] archive [...]"
  ///
  /// Dokumentation der API-Doku v2.5 v. Tobias Möller entnommen
  static Future<List<objects.UserTermin>> requestTerminListe( // @formatter:off
      bool archive) async {
    var _response = await http.get('${variables.url}/admin/termin?token=${variables.token}&archive=$archive');
    if (_response.statusCode != 200) {
      throw Exception('Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}.');
    }
    var terminliste = <objects.UserTermin>[];
    for (var termin in convert.jsonDecode(_response.body)['termine']) {
      terminliste.add(converter.jsonToTermin(termin));
    }
    return terminliste;
  } // @formatter:on

  /// "4.7.20 Admin Termin löschen
  /// Endpunkt, um einen Termin zu löschen. Es \[wird\] die Terminid [...] übergeben."
  ///
  /// Dokumentation der API-Doku v2.5 v. Tobias Möller entnommen
  static void terminLoeschen(int id) async { // @formatter:off
    var _response = await http.delete('${variables.url}/admin/termin?token=${variables.token}&eventid=$id');
    if (_response.statusCode != 204) {
      throw Exception('Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}.');
    }
  } // @formatter:on

  //@formatter:off
  static void addUserZuTermin(int eventID, [String kommentar, bool bestaetigt]) async {
    var parameters = <String, String>{};
                            parameters['token']      = variables.token;
                            parameters['eventid']    = '$eventID';
    if (kommentar  != null) parameters['kommentar']  = kommentar;
    if (bestaetigt != null) parameters['bestaetigt'] = '$bestaetigt';

    var _response = await http.post('${variables.url}/admin/user}', body:parameters);
    if (_response.statusCode != 201){
      if (_response.statusCode == 404){
        throw Exception('User oder Event ist unbekannt.');
      } else if (_response.statusCode == 400){
        throw Exception('Der User ist schon im Termin eingetragen.');
      } else {
        throw Exception('Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}.');
      }
    }
  }//@foramtter:on

  //TODO API Dokumentation ist noch nicht fertig -> Wegen den Exceptions.
  static void absageUserTermin(int eventID, int userID, [String kommentar]) async { // @formatter:off
    var parameters = <String, String>{};
                           parameters['token']     = variables.token;
                           parameters['eventid']   = '$eventID';
                           parameters['userid']    = '$userID';
    if (kommentar != null) parameters['kommentar'] = kommentar;

    var _response = await http.patch('${variables.url}/admin/termin/absagen', body: parameters);
    if (_response.statusCode != 204) {
      if (_response.statusCode == 404) {
        throw Exception('Termin oder User existiert nicht!');
      }
      throw Exception('Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}.');
    }
  } // @formatter:on

  static void zusageUsertermin(int eventID,int userID, [String kommentar]) async { // @formatter:off
    var parameters = <String, String>{};
                           parameters['token']     = variables.token;
                           parameters['eventid']   = '$eventID';
                           parameters['userid']    = '$userID';
    if (kommentar != null) parameters['kommentar'] = kommentar;

    var _response = await http.patch('${variables.url}/admin/termin/zusagen', body: parameters);
    if (_response.statusCode != 204) {
      if (_response.statusCode == 404) {
        throw Exception('UserID oder Termin ist unbekannt.');
      } else {
        throw Exception('Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}.');
      }
    }// @foramtter:on
  }

  // @formatter:off
  //TODO ungetestet und DATETIME in dart ist anders als DATETIME in MYSQL siehe DOKU sollte umgewandelt werden.
  static void bearbeiteTermin(int eventID,
      [String name, String beschreibung, String ort, DateTime startDatum, DateTime endDatum,
      int plaetze, bool oeffentlich, DateTime sichtbarAb, DateTime anmeldungBis]) async {
    var parameters = <String, String>{};
                              parameters['token']        = variables.token;
                              parameters['eventid']      = '$eventID';
    if (name         != null) parameters['name']         = name;
    if (beschreibung != null) parameters['beschreibung'] = beschreibung;
    if (ort          != null) parameters['ort']          = ort;
    if (startDatum   != null) parameters['startdatum']   = '${converter.dateTimeFormat(startDatum)}';
    if (endDatum     != null) parameters['enddatum']     = '${converter.dateTimeFormat(endDatum)}';
    if (plaetze      != null) parameters['plaetze']      = '$plaetze';
    if (oeffentlich  != null) parameters['oeffentlich']  = '$oeffentlich';
    if (sichtbarAb   != null) parameters['sichtbarab']   = '${converter.dateTimeFormat(sichtbarAb)}';
    if (anmeldungBis != null) parameters['anmeldungbis'] = '${converter.dateTimeFormat(anmeldungBis)}';

    var _response = await http.patch('${variables.url}/admin/termin', body: parameters);
    if (_response.statusCode != 204) {
      throw Exception('Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}.');
    }
  } // @formatter:on
}