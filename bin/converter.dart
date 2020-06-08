import 'dart:collection';
import 'objects.dart' as objects;

// ------------------------------ JSON zu User ------------------------------

/// Konvertiert ein, mittels jsonDecode aus der dart:convert Library in eine LinkedHashMap konvertiertes, json-File
/// in ein User-, oder Admin-Objekt.
objects.User jsonToUser(LinkedHashMap jsonAsList) {
  var _children = <int>[];
  if (jsonAsList['children'] != null && jsonAsList['children'].isNotEmpty) {
    for (var id in jsonAsList['children']) {
      _children.add(id is int ? id : jsonToUser(id).userID);
    }
  }
  if (jsonAsList['dsgvo'] != null &&
      jsonAsList['anmeldung'] != null &&
      jsonAsList['portal'] != null) {
    return objects.Admin(
        jsonAsList['userid'],
        jsonAsList['vorname'],
        jsonAsList['nachname'],
        jsonAsList['email'],
        jsonAsList['plz'],
        jsonAsList['ort'],
        jsonToUserTyp(jsonAsList['typ']),
        jsonAsList['jugendgruppe'],
        jsonAsList['parent'] is int || jsonAsList['parent'] == null
            ? jsonAsList['parent']
            : jsonToUser(jsonAsList['parent']).userID,
        _children.isNotEmpty ? _children : null,
        jsonAsList['registered'],
        jsonAsList['dsgvo'],
        jsonAsList['anmeldung'],
        jsonAsList['portal']);
  }
  return objects.User(
      jsonAsList['userid'],
      jsonAsList['vorname'],
      jsonAsList['nachname'],
      jsonAsList['email'],
      jsonAsList['plz'],
      jsonAsList['ort'],
      jsonToUserTyp(jsonAsList['typ']),
      jsonAsList['jugendgruppe'],
      jsonAsList['parent'] is int || jsonAsList['parent'] == null
          ? jsonAsList['parent']
          : jsonToUser(jsonAsList['parent']).userID,
      _children.isNotEmpty ? _children : null,
      jsonAsList['registered']);
}

/// Konvertiert ein, mittels jsonDecode aus der dart:convert Library in eine LinkedHashMap konvertiertes, json-File
/// in ein UserTyp-Objekt.
objects.UserTyp jsonToUserTyp(LinkedHashMap jsonAsList) {
  return objects.UserTyp(
      jsonAsList['typid'],
      jsonAsList['name'],
      jsonAsList['permissions'] != null
          ? jsonToPermission(jsonAsList['permissions'])
          : null);
}

/// Konvertiert ein, mittels jsonDecode aus der dart:convert Library in eine LinkedHashMap konvertiertes, json-File
/// in eine Liste mit Permission-Objekten.
List<objects.Permission> jsonToPermission(var jsonAsList) {
  var permissions = <objects.Permission>[];
  for (var p in jsonAsList) {
    permissions.add(objects.Permission(
        p['permissionid'], p['name'], p['description'], p['code']));
  }
  return permissions;
}

// ----------------------------- JSON zu Termin -----------------------------

objects.UserTermin jsonToTermin(LinkedHashMap jsonAsList) {
  var teilnehmer = <objects.AntwortTermin>[];
  for (var antwortTermin in jsonAsList['users']) {
    teilnehmer.add(jsonToAntwortTermin(antwortTermin));
  }
  if(jsonAsList['freigeschaltet'] != null) {
    return objects.AdminTermin(
        jsonAsList['plaetze'],
        jsonAsList['terminid'],
        jsonAsList['veranstaltungid'],
        jsonAsList['ort'],
        jsonAsList['name'],
        jsonAsList['beschreibung'],
        DateTime.parse(jsonAsList['anmeldung']['start']),
        DateTime.parse(jsonAsList['anmeldung']['ende']),
        DateTime.parse(jsonAsList['time']['start']),
        DateTime.parse(jsonAsList['time']['ende']),
        jsonToZyklus(jsonAsList['zyklus']),
        teilnehmer, jsonAsList['freigeschaltet']);
  }
  return objects.UserTermin(
      jsonAsList['plaetze'],
      jsonAsList['terminid'],
      jsonAsList['veranstaltungid'],
      jsonAsList['ort'],
      jsonAsList['name'],
      jsonAsList['beschreibung'],
      DateTime.parse(jsonAsList['anmeldung']['start']),
      DateTime.parse(jsonAsList['anmeldung']['ende']),
      DateTime.parse(jsonAsList['time']['start']),
      DateTime.parse(jsonAsList['time']['ende']),
      jsonToZyklus(jsonAsList['zyklus']),
      teilnehmer);
}

objects.AntwortTermin jsonToAntwortTermin(LinkedHashMap jsonAsList) {
  return objects.AntwortTermin(
      jsonToUser(jsonAsList['user']),
      jsonToAntwort(jsonAsList['antwort']['user']),
      jsonToAntwort(jsonAsList['antwort']['leiter']),
      jsonAsList['kommentar']);
}

objects.Antwort jsonToAntwort(LinkedHashMap jsonAsList) {
  return objects.Antwort(jsonAsList['id'], jsonAsList['name']);
}

objects.Zyklus jsonToZyklus(LinkedHashMap jsonAsList) {
  return objects.Zyklus(jsonAsList['zyklusid'] ?? jsonAsList['id'], jsonAsList['name']);
}