import 'package:http/http.dart' as http;
import '../objects.dart' as objects;

/// Nur zu Debuggingzwecken
/// Wird verwendet um die Reaktion des Servers in der Konsole zu dokumentieren.
void output(http.Response response) {
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}

/// Nur zu Debuggingzwecken
/// Wird verwendet um Userlisten in der Konsole auszugeben.
void printUserliste(List<objects.User> userliste) {
  for(var user in userliste){
  print('$user\n\n###########################################################################\n\n');
  }
}