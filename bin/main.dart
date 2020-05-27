import 'package:http_request/http_request.dart' as http_request;
import 'objects.dart' as objects;

main(List<String> arguments) {
  print(objects.UserTyp(1, 'Günther', [objects.Permission(1, 'admin', 'kann alles', 'termin.bearbeiten'), objects.Permission(2, 'user', 'kann nicht alles', 'blabla'), objects.Permission(3, 'elternteil', 'bevormundet', 'xyz')]));
}