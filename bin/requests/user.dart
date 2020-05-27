import 'package:http/http.dart' as http;
import 'variables.dart' as variables;

requestMeineTermine() async {
  var response = await http.get('${variables.url}meine-termine',
      headers: {'token': '${variables.token}'});
  if (response.statusCode == 200) {
    //TODO
  } else {
    throw Exception(
        'unvorhergesehene HTTP Rückmeldung: ${response.statusCode}');
  }
}