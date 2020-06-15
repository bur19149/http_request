import 'dart:io';

import '../objects.dart' as objects;

// @formatter:off
final String url        = 'https://jugendevent.mainlevel.at/api';                             // Verbindungs-URL
final String appVersion = 'alpha 0.1';                                                        // aktuelle Version der App
      String token      = 'rVMWQRDvHY0NpO-c_8S!nMRhmi=pXZ4gLQ3szHY7wYVVEV-z=RwhvezRxu8lkcB!'; // Token zur Identifizierung beim Server
//      String token      = 'LOHbk!6=EtRWZklq=A79hVSKSQElgEm%k_3E\$ayvDhjuCFVw7=FoQp-z6EVm98et'; // Token zur Identifizierung beim Server (Admin)

/// alle existierenden Permissions
var permissions = const <objects.Permission>[objects.Permission(null, null, 'Erlaubt das Anmelden zu Terminen',                                                   'termin.antwort.teilnehmer'   ),
                                             objects.Permission(null, null, 'Erlaubt es Kinder Accounts für einen Termin anzumelden',                             'termin.antwort.eltern'       ),
                                             objects.Permission(null, null, 'Erlaubt das Erstellen eines neuen Termins',                                          'termin.erstellen'            ),
                                             objects.Permission(null, null, 'Erlaubt das bearbeiten von Terminen',                                                'termin.bearbeiten'           ),
                                             objects.Permission(null, null, 'Erlaubt das Anmelden zu Terminen',                                                   'termin.antwort.teilnehmer'   ),
                                             objects.Permission(null, null, 'Erlaubt eine Antwort auf eine Terminanmeldung zugeben',                              'termin.antwort.gruppenleiter'),
                                             objects.Permission(null, null, 'Erlaubt es Kinder Accounts für einen Termin anzumelden',                             'termin.antwort.eltern'       ),
                                             objects.Permission(null, null, 'Es werden auch nicht freigeschaltete Termine angezeigt',                             'termin.alle_zeigen'          ),
                                             objects.Permission(null, null, 'Bestimmt ob die Adminleiste im Menü angezeigt wird.',                                'adminmenu.show'              ),
                                             objects.Permission(null, null, 'Erlaubt nach Anmeldeschluss oder bei voller Veranstaltung einen User hinzuzufügen.', 'termin.antwort.nachtrag'     ),
                                             objects.Permission(null, null, 'Gibt alle Rechte',                                                                   '*'                           ),
                                             objects.Permission(null, null, 'Erlaubt das Erstellen eines neuen Termins',                                          'termin.erstellen'            ),
                                             objects.Permission(null, null, 'Erlaubt das bearbeiten von Terminen',                                                'termin.bearbeiten'           ),
                                             objects.Permission(null, null, 'Erlaubt das Anmelden zu Terminen',                                                   'termin.antwort.teilnehmer'   ),
                                             objects.Permission(null, null, 'Erlaubt eine Antwort auf eine Terminanmeldung zu geben',                             'termin.antwort.gruppenleiter'),
                                             objects.Permission(null, null, 'Erlaubt es Kinder Accounts für einen Termin anzumelden',                             'termin.antwort.eltern'       ),
                                             objects.Permission(null, null, 'Es werden auch nicht freigeschaltete Termine angezeigt',                             'termin.alle_zeigen'          ),
                                             objects.Permission(null, null, 'Bestimmt ob die Adminleiste im Menü angezeigt wird.',                                'adminmenu.show'              ),
                                             objects.Permission(null, null, 'Erlaubt nach Anmeldeschluss oder bei voller Veranstaltung einen User hinzuzufügen.', 'termin.antwort.nachtrag'     ),
                                             objects.Permission(null, null, 'Erlaubt das Erstellen von einem Bewerb/Lager',                                       'bewerb.erstellen'            ),
                                             objects.Permission(null, null, 'Darf Bewerbe bearbeiten jedoch nocht löschen',                                       'bewerb.bearbeiten'           ),
                                             objects.Permission(null, null, 'Erlaubt das Abschliessen, festlegen von Ergebnissen etc.',                           'bewerb.schliessen'           ),
                                             objects.Permission(null, null, 'Darf eine Liste aller Bewerbe einsehen',                                             'bewerb.alle_zeigen'          )];
// @formatter:on

// Wird vermutlich nicht benötigt
//abstract class Verwaltung {
//      var orgAppConfig = File('OrgAppConfig.txt');
//      List<UserTermin> eigeneTermine;
//      List<AdminTermin> adminTermine;
//      List<Zyklus> listeZyklusse;
//}

abstract class FileHandler {
  static Future<String> get _localPath async {
    //TODO auskommentieren bei einem Flutter Projekt
//    final directory=await getApplicationDocumentsDirectory();
//    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/orgAppToken.txt');
  }

  static Future<File> writeFile(String value) async {
    final file = await _localFile; // Writes the file.
    return file.writeAsString(value);
  }

  static void readFile() async {
    try {
      final file = await _localFile;
      token = await file.readAsString();
    } catch (e) {
      throw Exception('Zugriff verweigert, oder Datei $_localFile konnte nicht gefunden werden.');
    }
  }
}