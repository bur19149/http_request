import 'package:http_request/http_request.dart' as http_request;
import 'objects.dart' as objects;
import 'requests/admin.dart' as admin;
import 'requests/debug.dart' as debug;
import 'requests/login.dart' as login;
import 'requests/user.dart' as user;

main(List<String> arguments) async {
//  print(await login.requestUser());
//  debug.printListe(await admin.User.requestUserListe());
//  admin.User.erstelleUser('John', 'Doe', 1, '1010', 'Wien');
//  print(await admin.Termin.requestTermin(31));
//  await admin.Termin.terminLoeschen(38);
//  debug.printListe(await admin.Termin.requestTerminListe(true));
//  debug.printListe(await user.requestAlleTermine());
  debug.printListe(await user.requestMeineTermine());
//  print(await user.requestTermin(31));
}
