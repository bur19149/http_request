import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../converter.dart' as converter;
import '../objects.dart' as objects;
import 'variables.dart' as variables;
//import 'debug.dart' as debug;


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



  static Future<objects.User> requestUser(int userID) async {
    var _response = await http.get(
        '${variables.url}/admin/user?token=${variables.token}&userid=${userID}');
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

abstract class Termin {
  static Future<objects.AdminTermin> requestTermin(int eventID) async {
    var _response = await http.get('${variables.url}/admin/termin?token=${variables.token}&eventid=$eventID');
    if (_response.statusCode != 200) {
      throw Exception(
          'Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}');
    }
    return converter.jsonToTermin(convert.jsonDecode(_response.body)['termin']);
  }

  static Future<List<objects.UserTermin>> requestTerminListe(bool archive) async {
    var _response = await http.get('${variables.url}/admin/termin?token=${variables.token}&archive=$archive');
    if (_response.statusCode != 200) {
      throw Exception(
          'Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}.');
    }
    var terminliste = <objects.UserTermin>[];
    for (var termin in convert.jsonDecode(_response.body)['termine']) {
      terminliste.add(converter.jsonToTermin(termin));
    }
    return terminliste;
  }

  static void terminLoeschen(int id) async {
    var _response = await http.delete('${variables.url}/admin/termin?token=${variables.token}&eventid=$id');
    if (_response.statusCode != 204) {
      throw Exception('Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}.');
    }
  }

  static loescheUser(int id) async{
    var _response = await http.delete('${variables.url}/admin/user?token=${variables.token}&userid=${id}');
    if(_response.statusCode==404){
      throw Exception('Der User Existiert nicht.');
    }else if(_response.statusCode!=204){
      throw Exception('Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}.');
    }
  }

  // @formatter:off
  static bearbeiteUser(String token, int userID,
      [String vorname, String nachname, String email, String plz, String ort, String jugendgruppe,
       int berechtigung, int elternID, String elternmail]) async{

    var parameterListe = <String, dynamic>{};
                            parameterListe['token']        = token;
                            parameterListe['userid']       = userID;
    if(vorname!=null)       parameterListe['vorname']      = vorname;
    if(nachname!=null)      parameterListe['nachname']     = nachname;
    if(email!=null)         parameterListe['email']        = email;
    if(plz!=null)           parameterListe['plz']          = plz;
    if(ort!=null)           parameterListe['ort']          = ort;
    if(jugendgruppe!=null)  parameterListe['jugendgruppe'] = jugendgruppe;
    if(berechtigung!= null) parameterListe['berechtigung'] = berechtigung;
    if(elternID!=null)      parameterListe['elternID']     = elternID;
    if(elternmail!=null)    parameterListe['elternmail']   = elternmail;

    var _response = await http.patch(variables.url, body: parameterListe);
    if(_response.statusCode!=204){
      if(_response.statusCode==404){
        throw Exception('Der User Existiert nicht.');
      }else{
        throw Exception('Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}.');
      }
    }// @formatter:on
  }




}