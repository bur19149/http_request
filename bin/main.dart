import 'package:http_request/http_request.dart' as http_request;
import 'converter.dart' as converter;
import 'exceptions.dart';
import 'objects.dart' as objects;
import 'requests/admin.dart' as admin;
import 'requests/debug.dart' as debug;
import 'requests/login.dart' as login;
import 'requests/user.dart' as user;

// TODO Checkliste für fertige Files, sprich Files in denen alles dokumentiert und getestet wurde
// * requests/debug.dart
// * exceptions.dart
// * converter.dart
// * pruefungen.dart
// * requests/user.dart

// TODO unfertige Files
// * objects.dart
// * requests/admin.dart
//      - bearbeiteUser wirft Code 500 (auch in Postman)
//      - bearbeiteUser und erstelleUser Parameterübergaben ev. auf User-Objekte ändern
// * requests/login.dart
// * requests/variables.dart

main(List<String> arguments) async {
//  print(await login.requestUser());
//  admin.User.erstelleUser('Gertrud', 'Müller', 1, '1010', 'Wien', null, null, null, 'raimondo.montecuccoli84@gmail.com');
//  debug.printListe(await admin.User.requestUserListe());
//await admin.User.bearbeiteUser(4, null, 'Schubertus');
//  print(await admin.User.requestUser(4));
//  print(await admin.Termin.requestTermin(31));
//  await admin.Termin.terminLoeschen(38);
//  debug.printListe(await user.requestAlleTermine());
//  debug.printListe(await user.requestMeineTermine());
//  print(await user.requestTermin(39));
  var termin = objects.AdminTermin(
      3,
      'Wien',
      'Prüfung',
      'Teste ob erstelleTermin funktioniert',
      DateTime(2020, 7, 20, 3, 19),
      DateTime(2020, 8, 1, 3, 19),
      objects.Zyklus(1, 'test'),
      null,
      null,
      null,
      null,
      DateTime(2020, 9, 1));
//  print(termin);
//    admin.Termin.erstelleTermin(termin);
//    debug.printListe(await admin.Termin.requestTerminListe(false));
}
