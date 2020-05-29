import 'dart:io';

// @formatter:off
final String url        = 'https://jugendevent.mainlevel.at/api';                             // Verbindungs-URL
final String appVersion = 'alpha 0.1';                                                        // aktuelle Version der App
//      String token      = 'rVMWQRDvHY0NpO-c_8S!nMRhmi=pXZ4gLQ3szHY7wYVVEV-z=RwhvezRxu8lkcB!'; // Token zur Identifizierung beim Server
      String token      = 'LOHbk!6=EtRWZklq=A79hVSKSQElgEm%k_3E\$ayvDhjuCFVw7=FoQp-z6EVm98et'; // Token zur Identifizierung beim Server (Admin)
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
      // Reads the file.
      token = await file.readAsString();
    } catch (e) {
      throw Exception(
          'Zugriff verweigert, oder Datei $_localFile konnte nicht gefunden werden.');
    }
  }
}