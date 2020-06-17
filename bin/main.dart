import 'package:http_request/http_request.dart' as http_request;
import 'converter.dart' as converter;
import 'exceptions.dart';
import 'objects.dart' as objects;
import 'requests/admin.dart' as admin;
import 'requests/debug.dart' as debug;
import 'requests/login.dart' as login;
import 'requests/user.dart' as user;
import 'requests/variables.dart' as variables;


// TODO Checkliste für fertige Files, sprich Files in denen alles dokumentiert und getestet wurde
// * requests/debug.dart
// * exceptions.dart
// * converter.dart
// * pruefungen.dart
// * requests/user.dart
// * requests/login.dart
//      - bei Link müssen noch die Übergabe von name & model implementiert werden, hierfür ist jedoch ein Flutter-Projekt nötig
// * objects.dart
// * requests/variables.dart
//      - sind noch diverse Änderungen notwendig, hierfür ist jedoch ein Flutter-Projekt nötig


// TODO unfertige Files
// * requests/admin.dart
//      - bearbeiteUser wirft Code 500 (auch in Postman)

main(List<String> arguments) async {
//  await admin.Termin.addUserZuTermin(42, 23);
//  await admin.Termin.zusageUserTermin(42, 23, 'Test');
//  await admin.Termin.bearbeiteTermin(42, 'Prüfung-Test', null, null, null, DateTime(2020, 8, 1, 3, 19));
//  print(await login.validate());
//  print(await login.requestUser());
//  admin.User.erstelleUser('Gertrud', 'Müller', 1, '1010', 'Wien', null, null, null, 'raimondo.montecuccoli84@gmail.com');
//  debug.printListe(await admin.User.requestUserListe());
//await admin.User.bearbeiteUser(4, null, 'Schubertus');
//  print(await admin.User.requestUser(23));
//  print(await admin.Termin.requestTermin(42));
//  await admin.Termin.terminLoeschen(38);
//  debug.printListe(await user.requestAlleTermine());
//  debug.printListe(await user.requestMeineTermine());
//  print(await user.requestTermin(39));
//  var termin = objects.AdminTermin(
//      3,
//      'Wien',
//      'Prüfung',
//      'Teste ob erstelleTermin funktioniert',
//      DateTime(2020, 7, 20, 3, 19),
//      DateTime(2020, 8, 1, 3, 19),
//      objects.Zyklus(1, 'test'),
//      null,
//      null,
//      null,
//      null,
//      DateTime(2020, 9, 1));
//  print(termin);
//    admin.Termin.erstelleTermin(termin);
//    debug.printListe(await admin.Termin.requestTerminListe(false));
}
