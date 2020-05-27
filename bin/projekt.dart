import 'dart:io';
import 'package:http/http.dart' as http;
//import 'package:path_provider/path_provider.dart';

///Hier sind die Methoden die mehr als einmal verwendet werden
abstract class ReusableMethods {
  /// Prüft auf NULL, leeren String und liefert den String ohne
  /// nachfolgende und führende leerzeichen zurück.
  static String stringPrufung(String value) {
    if (value == null) {
      throw ('Null: Dieses feld darf nicht leer sein');
    } else {
      value = value.trim();
      if (value.isEmpty) {
        throw ('Dieses feld darf nicht leer sein');
      } else {
        return value;
      }
    }
  }

  /// Wird mit einer Regular Expression getestet. Wird in set Vorname und set Nachname verwendet
  static String prufeName(String value) {
    RegExp a = RegExp(
        r'^[A-Za-zöÖäÄüÜßàéëïáêèíîôóúûŠšŽžÅÕõÇÊÎŞÛçşĂÂŢăâţĳÆØæøåÔŴŶÁÉÍÏŵŷÓÚẂÝÀÈÌÒÙẀỲËẄŸẃýì'
        r'òùẁỳẅÿĈĜĤĴŜŬĉĝĥĵŝŭĞİğıÐÞðþŐŰőűŒœãÑñÃẼĨŨỸẽĩũỹĄĘĮŁŃąęįłńǪāēīōǫǭūŲųżćśźůŻČĆĐĎĚŇŘŤŮď'
        r'ěňřťĽĹŔľĺŕĀĒĢĪĶĻŅŌŖŪģķļņŗĖėẢẠẰẲẴẮẶẦẨẪẤẬẺẸỀỂỄẾỆỈỊỎỌỒỔỖỐỘƠỜỞỠỚỢỦỤƯỪỬỮỨỰỶỴđảạằẳẵắặầ'
        r'ẩẫấậẻẹềểễếệỉịỏọồổỗốơờởỡớợủụưừửữứựỷỵꞗĕŏ᷄]+$');
    if (a.hasMatch(value)) {
      return value;
    } else {
      throw ('Ungültiger Name.');
    }
  }

  /// 9007199254740992 ist der grosste Integer in Javascript (API in JS) *throws up*
  static int prufeID(int value) {
    if (value < 0 || value > 9007199254740992) {
      throw Exception('Die ID ist ungültig $value.');
    } else {
      return value;
    }
  }

  static String prufeOrt(String value) {
    RegExp a = RegExp(r'^[a-zA-ZöÖäÄüÜ]+$');
    if (a.hasMatch(value)) {
      return value;
    } else {
      throw ('Ungüliger Ort.');
    }
  }
}

abstract class Verwaltung {
  static String appVersion = 'alpha 0.1';
  static String token = ''; //Der Token wird beim Starten der App hinein geladen.
  static final String url = 'https://jugendevent.mainlevel.at/api/'; //For the http requests
  var orgAppConfig = new File('OrgAppConfig.txt');
  List<UserTermin> eigeneTermine;
  List<AdminTermin> adminTermine;
  List<Zyklus> listeZyklusse;

  getZyklen() {}

  getMeineTermine() async {
    var response = await http.get('${Verwaltung.url}meine-termine',
        headers: {'token': '${Verwaltung.token}'});
    if (response.statusCode == 200) {
      //TODO
    } else {
      throw Exception(
          'unvorhergesehene HTTP Rückmeldung: ${response.statusCode}');
    }
  }
}

abstract class Einloggen {
  Future<String> get _localPath async {
//    final directory=await getApplicationDocumentsDirectory();
//    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/orgAppToken.txt');
  }

  Future<File> writeFile(String value) async {
    final file = await _localFile; // Writes the file.
    return file.writeAsString(value);
  }

  void readFile() async {
    try {
      final file = await _localFile;
      // Reads the file.
      Verwaltung.token = await file.readAsString();
    } catch (e) {
      throw Exception('Zugriff verweigert, oder Datei $_localFile konnte nicht gefunden werden.');
    }
  }

  Future<bool> valtidateToken() async {
    ReusableMethods.stringPrufung(Verwaltung.token);
    var response =
        await http.get('${Verwaltung.url}/validate?token=${Verwaltung.token}');
    // var response=await http.get('${Verwaltung.url}validate',headers:{'token': '${Verwaltung.token}'});
    /*for debugging*/
    print(response.statusCode);
    if (response.statusCode == 200) {
      return true;
    } else
    // 401 = Ein solcher Token existiert nicht in der Datenbank.
    // 403 = Der Token ist abgelaufen bzw. wurde vom User entfernt.
    //TODO schauen ob writeFile('') den token im file überschreibt, und alle möglichkeiten triggern aka 401/403
    if (response.statusCode == 401 || response.statusCode == 403) {
      writeFile('');
      return false;
    }
    throw Exception(
        'unvorhergesehene HTTP Rückmeldung: ${response.statusCode}');
  }

  getEigeneUserDaten() async {
    var response = await http
        .post('${Verwaltung.url}user', body: {'token': '${Verwaltung.token}'});
    if (response.statusCode == 200) {
      //TODO
      print(response.body);
    }
    throw Exception(
        'unvorhergesehene HTTP Rückmeldung: ${response.statusCode}');
  }

  void einloggen(String value) async {
    RegExp a = RegExp(r'^[A-Za-z0-9]+$');
    if (!a.hasMatch(ReusableMethods.stringPrufung(value))) {
      throw ('Ungültiger UserToken.');
    } else {
      // var url = 'https://jugendevent.mainlevel.at/api/' <- URL in Verwaltung
      var url = '${Verwaltung.url}link';
      // print(url); /* For Debugging */ // print(value); /* For Debugging */
      var response = await http.post(url, body: {
        'userkey': '$value',
        'name': 'POST',
        'model': '???',
        'version': '${Verwaltung.appVersion}'
      });

      // API DOKU SAGT:
      // Userkey unknown: 404 Ein solcher Schlüssel existiert nicht in der Datenbank.
      // Userkey invalid: 400 Der Schlüssel ist abgelaufen oder wurde bereits erfolgreich benutzt.
      // Parameter missing: 422 Es fehlen ein oder mehr Parameter

      if (response.statusCode == 200) {
        writeFile(RegExp('.*"(.*)"}}').allMatches(response.body).toList()[0].group(1));
      } else {
        throw ('Error: Response status: ${response.statusCode}');
      }
    }
  }
}

class User {
  int _userid;
  String _jugendgruppe;
  String _nachname;
  String _vorname;
  String _email;
  String _plz; //KA WARUM DAS EIN STRING IST -> API will es leider so
  String _ort;
  User _parent;
  UserTyp _typ;
  List<User> _children;
  bool _registered;

  ///Constructor

  User(
      int userint,
      String vorname,
      String nachname,
      String email,
      String plz,
      String ort,
      UserTyp typ,
      String jugendgruppe,
      User parent,
      List<User> children,
      bool registered) {
    this.userint = userint;
    this.vorname = vorname;
    this.nachname = nachname;
    this.email = email;
    this.plz = plz;
    this.ort = ort;
    this.typ = typ;
    this.jugendgruppe = jugendgruppe;
    _parent = parent;
    this.children = children;
    _registered = registered;
  }

  ///Setter

  set userint(int value) {
    _userid = ReusableMethods.prufeID(value);
  }

  set vorname(String value) {
    _vorname = ReusableMethods.prufeName(ReusableMethods.stringPrufung(value));
  }

  set nachname(String value) {
    _nachname = ReusableMethods.prufeName(ReusableMethods.stringPrufung(value));
  }

  set jugendgruppe(String value) {
    _jugendgruppe = ReusableMethods.stringPrufung(value);
  }

  set plz(String value) {
    ///wann man "value" auf int setzt schreit der DUMME kompiler.
    var megaGay = int.parse(ReusableMethods.stringPrufung(value)); //workaround
    if (megaGay < 1010 || megaGay > 9992) {
      throw ('Die Postleitzahl ist ungültig.');
    } else {
      _plz = megaGay.toString();
    }
  }

  set ort(String value) {
    _ort = ReusableMethods.prufeOrt(ReusableMethods.stringPrufung(value));
  }

  set typ(UserTyp value) {
    if (value == null) {
      throw Exception('Null übergabe');
    } else {
      _typ = value;
    }
  }

  /// Die eingegebene E-Mail Adresse wird mit einer Regular Expression überprüft
  /// und mit nem Pusch wird geschaut ob mehr als ein "@" drinnen ist kann Verbessert werden
  set email(String value) {
    value = ReusableMethods.stringPrufung(value);
    RegExp abc = RegExp(
        r'[A-Za-z0-9!#\$%&+\/=?^_`{|}~-]+(?:.[A-Za-z0-9!#\$%&+\/=?^_`{|}~-]+)@(?:[a-zA-Z0-9]'
        r'[a-zA-Z0-9-]{0,253}.)[a-zA-Z0-9][a-zA-Z0-9-]{0,253}.[a-zA-Z0-9]{2,}');
    if (abc.hasMatch(value)) {
      int count = 0;
      for (int a = 0; a < value.length; a++) {
        if (value[a].contains('@')) {
          count++;
        }
      }
      if (count > 1) {
        throw ('Ungültige Email Adresse. Mehr als ein \"@\"');
      } else {
        _email = value;
      }
    } else {
      throw ('Ungültige Email Adresse.');
    }
  }

  ///Es darf Null übergeben werden da ein User auch keine kinder haben kann.
  set children(List<User> value) {
    _children = value;
  }
}

class Admin extends User {
  String _dsgvo;
  String _portal;
  String _anmeldung;

  ///Constructor

  Admin(int userint, String vorname, String nachname, String email, String plz, String ort,
      UserTyp typ, String jugendgruppe, User parent, List<User> children, bool registered,
      String dsgvo, String portal, String anmeldung) : super(userint, vorname, nachname, email,
      plz, ort, typ, jugendgruppe, parent, children, registered) {
    this.dsgvo = dsgvo;
    this.portal = portal;
    this.anmeldung = anmeldung;
  }

  ///Setter

  set dsgvo(String value) {
    _dsgvo = ReusableMethods.prufeName(ReusableMethods.stringPrufung(value));
  }

  set anmeldung(String value) {
    _anmeldung =
        ReusableMethods.prufeName(ReusableMethods.stringPrufung(value));
  }

  set portal(String value) {
    _portal = ReusableMethods.prufeName(ReusableMethods.stringPrufung(value));
  }
}

class UserTyp {
  int _typid;
  String _name;
  List<Permission> _permissions;

  ///Constructor

  UserTyp(int typid, String name, List<Permission> permission) {
    this.typID = typid;
    this.name = name;
    this.permissions = permission;
  }

  ///Setter

  set typID(int value) {
    _typid = ReusableMethods.prufeID(value);
  }

  set name(String value) {
    _name = ReusableMethods.prufeName(ReusableMethods.stringPrufung(value));
  }

  set permissions(List<Permission> value) {
    if (value == null || value.isEmpty) {
      throw Exception('Die Permissions Liste ist null.');
    } else {
      _permissions = value;
    }
  }
}

class Permission {
  int _permissionid;
  String _description;
  String _name;
  String _code;

  Permission(int permissionID, String name, String description, String code) {
    this.permissionID = permissionID;
    _name = name;
    this.code = code;
  }

  ///Setter

  set permissionID(int value) {
    _permissionid = ReusableMethods.prufeID(value);
  }

  set code(String value) {//TODO ka ob code auch Zahlen enthaten kann oder zahlen sind
    _code = ReusableMethods.stringPrufung(value);
  }
}

class UserTermin {
  int _platze;
  int _terminid;
  int _veranstaltungsid;
  String _ort;
  String _name;
  String _beschreibung;
  DateTime _anmeldungStart;
  DateTime _anmeldungEnde;
  DateTime _timeVon;
  DateTime _timeBis;
  Zyklus _zyklus;
  List<User> _teilnehmer;

  ///Constructor

  UserTermin(int platze, int terminid, int veranstaltungsid, String ort, String name,
      String beschreibung, DateTime anmeldungStart, DateTime anmeldungEnd, DateTime timeVon,
      DateTime timeBis, Zyklus zyklus, List<User> teilnehmer) {
    this.platze = platze;
    this.terminID = terminid;
    this.veranstaltungsid = veranstaltungsid;
    this.ort = ort;
    this.name = name;
    this.beschreibung = beschreibung;
    this.anmeldungStart = anmeldungStart;
    this.anmeldungEnde = anmeldungEnd;
    this.timeVon = timeVon;
    this.timeBis = timeBis;
    this.zyklus = zyklus;
    this.teilnehmer = teilnehmer;
  }

  ///Setter

  set anmeldungStart(DateTime value) {
    if (value == null) {
      throw ('Error:Das Datum ist Null.');
    } else if (_timeVon != null && value.isAfter(_timeBis)) {
      throw ('Error:Das Datum ist nach dem Ende.');
    } else if (value.isBefore(DateTime.now())) {
      throw ('Der Termin darf nicht in der Verganganheit stattfinden');
    } else {
      _anmeldungStart = value;
    }
  }

  set anmeldungEnde(DateTime value) {
    if (value == null) {
      throw ('Error:Das Datum ist Null.');
    } else if (_timeVon != null && value.isBefore(_timeVon)) {
      throw ('Das Enddatum darf nicht vor dem beginn stattfinden.');
    } else {
      _anmeldungEnde = value;
    }
  }

  set timeVon(DateTime value) {
    if (value == null) {
      throw ('Error:Das Datum ist Null.');
    } else if (_timeVon != null && value.isAfter(_timeBis)) {
      throw ('Error:Das Datum ist nach dem Ende.');
    } else if (value.isBefore(DateTime.now())) {
      throw ('Der Termin darf nicht in der Verganganheit stattfinden');
    } else {
      _timeVon = value;
    }
  }

  set timeBis(DateTime value) {
    if (value == null) {
      throw ('Error:Das Datum ist Null.');
    } else if (_timeVon != null && value.isBefore(_timeBis)) {
      throw ('Das Enddatum darf nicht vor dem beginn stattfinden.');
    } else {
      _timeBis = value;
    }
  }

  //Die maximale platzanzahl auf der Website ist 99
  set platze(int value) {
    if (value < 1 || value > 99) {
      throw Exception('Die Platzanzahl ist ungültig.');
    } else {
      _platze = value;
    }
  }

  set terminID(int value) {
    _terminid = ReusableMethods.prufeID(value);
  }

  set veranstaltungsid(int value) {
    _veranstaltungsid = ReusableMethods.prufeID(value);
  }

  set ort(String value) {
    _ort = ReusableMethods.prufeOrt(ReusableMethods.stringPrufung(value));
  }

  set name(String value) {
    _name = ReusableMethods.prufeName(ReusableMethods.stringPrufung(value));
  }

  set beschreibung(String value) {
    _beschreibung =
        ReusableMethods.prufeName(ReusableMethods.stringPrufung(value));
  }

  set zyklus(Zyklus value) {
    if (value == null) {
      throw Exception('Null übergabe.');
    } else {
      _zyklus = value;
    }
  }

  //Es darf Null übergeben werden weil sich auch keiner anmelden kann.
  set teilnehmer(List<User> value) {
    _teilnehmer = value;
  }
}

class AdminTermin extends UserTermin {
  bool _freigeschaltet;

  AdminTermin(int platze, int terminid, int veranstaltungsid, String ort, String name,
      String beschreibung, DateTime anmeldungStart, DateTime anmeldungEnd, DateTime timeVon,
      DateTime timeBis, Zyklus zyklus, List<User> teilnehmer, bool freigeschaltet) : super(platze,
      terminid, veranstaltungsid, ort, name, beschreibung, anmeldungStart, anmeldungEnd, timeVon,
      timeBis, zyklus, teilnehmer) {
    this.freigeschaltet = freigeschaltet;
  }

  ///Setter

  set freigeschaltet(bool value) {
    _freigeschaltet = value;
  }
}

class Zyklus {
  int _zyklusid;
  String _name;

  Zyklus(int zyklusid, String name) {
    this.zyklusID = zyklusid;
    this.name = name;
  }

  ///Setter

  set zyklusID(int value) {
    _zyklusid = ReusableMethods.prufeID(value);
  }

  set name(String value) {
    _name = ReusableMethods.prufeName(ReusableMethods.stringPrufung(value));
  }
}
