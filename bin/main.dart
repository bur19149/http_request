import 'package:http_request/http_request.dart' as http_request;
import 'objects.dart' as objects;
import 'requests/login.dart' as login;

main(List<String> arguments) async {

print('${await login.requestUser()}');















  /*print(objects.AdminTermin(
      10,
      1,
      2,
      'Wien',
      'Freibier für Alle',
      'Saufgelage',
      DateTime(2021),
      DateTime(2021),
      DateTime(2021),
      DateTime(2021),
      objects.Zyklus(1, 'abcdefghij'), [
    objects.AntwortTermin(
        objects.User(
            2,
            'Jürgen',
            'Maier',
            'juergenmaier@gaymail.com',
            '1020',
            'Wien',
            objects.UserTyp(1, 'bla', [
              objects.Permission(1, 'admin', 'kann alles', 'termin.bearbeiten')
            ]),
            'Die jungen Spritzen',
            null,
            [null, null],
            true),
        objects.Antwort(1, 'bla'),
        objects.Antwort(1, 'bla'),
        'Das ist ein kommentar'),
    objects.AntwortTermin(
        objects.User(
            2,
            'Jürgen',
            'Maier',
            'juergenmaier@gaymail.com',
            '1020',
            'Wien',
            objects.UserTyp(1, 'bla', [
              objects.Permission(1, 'admin', 'kann alles', 'termin.bearbeiten')
            ]),
            'Die jungen Spritzen',
            null,
            [null, null],
            true),
        objects.Antwort(1, 'bla'),
        objects.Antwort(1, 'bla'),
        'Das ist ein kommentar')
  ], true)); */

//print(
//objects.AntwortTermin(
//objects.User(
//    2,
//    'Jürgen',
//    'Maier',
//    'juergenmaier@gaymail.com',
//    '1020',
//    'Wien',
//    objects.UserTyp(1, 'bla', [
//      objects.Permission(1, 'admin', 'kann alles', 'termin.bearbeiten')
//    ]),
//    'Die jungen Spritzen',
//    null,
//    [null, null],
//    true),objects.Antwort(1, 'bla'), objects.Antwort(1, 'bla'),'Das ist ein kommentar'));
  /*
  print(objects.Admin(
      1,
      'Hans',
      'Müller',
      'hansmueller@gaymail.com',
      '1010',
      'Wien',
      objects.UserTyp(1, 'Günther', [
        objects.Permission(1, 'admin', 'kann alles', 'termin.bearbeiten'),
        objects.Permission(2, 'user', 'kann nicht alles', 'blabla'),
        objects.Permission(3, 'elternteil', 'bevormundet', 'xyz')
      ]),
      'Die jungen Spritzen',
      objects.User(
          2,
          'Jürgen',
          'Maier',
          'juergenmaier@gaymail.com',
          '1020',
          'Wien',
          objects.UserTyp(1, 'bla', [
            objects.Permission(1, 'admin', 'kann alles', 'termin.bearbeiten')
          ]),
          'Die jungen Spritzen',
          null,
          [null, null],
          true),
      [      objects.User(
          2,
          'Jürgen',
          'Maier',
          'juergenmaier@gaymail.com',
          '1020',
          'Wien',
          objects.UserTyp(1, 'bla', [
            objects.Permission(1, 'admin', 'kann alles', 'termin.bearbeiten')
          ]),
          'Die jungen Spritzen',
          null,
          [null, null],
          true),       objects.User(
          2,
          'Jürgen',
          'Maier',
          'juergenmaier@gaymail.com',
          '1020',
          'Wien',
          objects.UserTyp(1, 'bla', [
            objects.Permission(1, 'admin', 'kann alles', 'termin.bearbeiten')
          ]),
          'Die jungen Spritzen',
          null,
          [null, null],
          true)],
      true, 'bla', 'bla', 'bla'));
      */
}
