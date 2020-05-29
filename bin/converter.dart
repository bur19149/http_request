import 'dart:collection';
import 'objects.dart' as objects;

/// Konvertiert ein, mittels jsonDecode aus der dart:convert Library in eine LinkedHashMap konvertiertes, json-File
/// in ein User-, oder Admin-Objekt.
objects.User jsonToUser(LinkedHashMap jsonAsList) {
  var _children = [];
  if (jsonAsList['children'] != null && jsonAsList['children'].isNotEmpty) {
    for (var id in jsonAsList['children']) {
      _children.add(id);
    }
  }
  if (jsonAsList['dsgvo'] != null ||
      jsonAsList['anmeldung'] != null ||
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
        jsonAsList['parent'],
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
      jsonAsList['parent'],
      _children.isNotEmpty ? _children : null,
      jsonAsList['registered']);
}

/// Konvertiert ein, mittels jsonDecode aus der dart:convert Library in eine LinkedHashMap konvertiertes, json-File
/// in ein UserTyp-Objekt.
objects.UserTyp jsonToUserTyp(LinkedHashMap jsonAsList) {
  return objects.UserTyp(jsonAsList['typid'], jsonAsList['name'],
      jsonToPermission(jsonAsList['permissions']));
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

objects.Zyklus jsonToZyklus(LinkedHashMap jsonAsList) {
  return objects.Zyklus(jsonAsList['zyklusid'], jsonAsList['name']);
}
