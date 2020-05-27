import 'package:http/http.dart' as http;

/// Nur zu Debuggingzwecken
/// Wird verwendet um die Reaktion des Servers in der Console zu dokumentieren
void output(http.Response response) {
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
}
