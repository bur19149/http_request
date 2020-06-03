import 'package:http/http.dart' as http;
//import 'debug.dart' as debug;
import 'variables.dart' as variables;
import '../objects.dart' as objects;
import '../converter.dart' as converter;
import 'dart:convert' as convert;
  //@formatter:off
  anmeldungTermin(String token, int eventID, [int userID]) async{
    var parameters = <String, dynamic>{};
                     parameters['token']   = token;
                     parameters['eventid'] = eventID;
    if(userID!=null) parameters['userid']  = userID;

    var _response = await http.patch(variables.url, body: parameters);
    if(_response.statusCode!=201||_response.statusCode!=204){
      if(_response.statusCode==404){
        throw Exception('Termin oder UserID existiert nicht.');
      }else if(_response.statusCode==423){
        throw Exception('Der Termin ist nicht sichtbar/oeffentlich.');
      }else if(_response.statusCode==410){
        throw Exception('Anmeldung Geschlossen.');
      }else{
        throw Exception('Unvorhergesehene HTTP Rückmeldung: ${_response.statusCode}.');
      }
    }
  }

  //TODO in der Dolu sind die ERROR Codes nicht Dokumentiert [-> Unfinished]
  abmeldungTermin(String token, eventID, [int userID]) async{
    var parameters = <String, dynamic>{};
                     parameters['token']   = token;
                     parameters['eventid'] = eventID;
    if(userID!=null) parameters['userid']  = userID;

    var _response = await http.post(variables.url, body: parameters);
    if(_response.statusCode!=204){
      throw Exception('Unvorhergesehene HTTP Rückmeldung: ${_response.statusCode}.');
    }
  }
  //@formatter:on

  Future<List<objects.UserTermin>> requestMeineTermine() async {
  var _response = await http.get('${variables.url}/meine-termine?token=${variables.token}');
  if (_response.statusCode != 200) {
    throw Exception('Unvorhergesehene HTTP Rückmeldung: ${_response.statusCode}.');
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
    throw Exception('Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}.');
  }
  return converter.jsonToTermin(convert.jsonDecode(_response.body)['termin']);
}

Future<List<objects.UserTermin>> requestAlleTermine() async {
  var _response = await http.get('${variables.url}/termin?token=${variables.token}');
  if (_response.statusCode != 200) {
    throw Exception('Unvorhergesehene HTTP-Rückmeldung: ${_response.statusCode}.');
  }
  var terminliste = <objects.UserTermin>[];
  for (var termin in convert.jsonDecode(_response.body)['termine']) {
    terminliste.add(converter.jsonToTermin(termin));
  }
  return terminliste;
}