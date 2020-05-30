import 'package:http/http.dart' as http;
import 'debug.dart' as debug;
import 'variables.dart' as variables;
import 'variables.dart' as variables;

//requestMeineTermine() async {
//  var response = await http.get('${variables.url}meine-termine',
//      headers: {'token': '${variables.token}'});
//  if (response.statusCode == 200) {
//    //TODO
//  } else {
//    throw Exception(
//        'unvorhergesehene HTTP Rückmeldung: ${response.statusCode}');
//  }
//}

requestTermin(int eventID) async {
  var _response = http.get('${variables.url}/termin?token=${variables.token}&eventid=$eventID');
  debug.output(await _response);
}