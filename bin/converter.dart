import 'dart:collection';
import 'objects.dart' as objects;

objects.User jsonToUser(LinkedHashMap jsonAsList) {
  var _children = [];
  if (jsonAsList['children'] != null && jsonAsList['children'].isNotEmpty) {
    for (var id in jsonAsList['children']) {
      _children.add(id);
    }
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

objects.UserTyp jsonToUserTyp(LinkedHashMap jsonAsList) {
  return objects.UserTyp(jsonAsList['typid'], jsonAsList['name'],
      jsonToPermission(jsonAsList['permissions']));
}

List<objects.Permission> jsonToPermission(var jsonAsList) {
  var permissions = <objects.Permission>[];
  for (var p in jsonAsList) {
    permissions.add(objects.Permission(
        p['permissionid'], p['name'], p['description'], p['code']));
  }
  return permissions;
}