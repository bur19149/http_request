//import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'requests/variables.dart' as variables;
import 'pruefungen.dart' as pruefungen;

abstract class Verwaltung {
  var orgAppConfig = File('OrgAppConfig.txt');
  List<UserTermin> eigeneTermine;
  List<AdminTermin> adminTermine;
  List<Zyklus> listeZyklusse;

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
  //formatter:off
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
  } //formatter:on

  ///Setter

  set userint(int value) {
    _userid = pruefungen.prufeID(value);
  }

  set vorname(String value) {
    _vorname = pruefungen.prufeName(pruefungen.stringPrufung(value));
  }

  set nachname(String value) {
    _nachname = pruefungen.prufeName(pruefungen.stringPrufung(value));
  }

  set jugendgruppe(String value) {
    _jugendgruppe = pruefungen.stringPrufung(value);
  }

  set plz(String value) {
    //wann man "value" auf int setzt schreit der DUMME kompiler.
    var megaGay = int.parse(pruefungen.stringPrufung(value)); //workaround
    if (megaGay < 1010 || megaGay > 9992) {
      throw ('Die Postleitzahl ist ungültig.');
    } else {
      _plz = megaGay.toString();
    }
  }

  set ort(String value) {
    _ort = pruefungen.prufeOrt(pruefungen.stringPrufung(value));
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
    value = pruefungen.stringPrufung(value);
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

  Admin(
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
      bool registered,
      String dsgvo,
      String portal,
      String anmeldung)
      : super(userint, vorname, nachname, email, plz, ort, typ, jugendgruppe,
            parent, children, registered) {
    this.dsgvo = dsgvo;
    this.portal = portal;
    this.anmeldung = anmeldung;
  }

  ///Setter

  set dsgvo(String value) {
    _dsgvo = pruefungen.prufeName(pruefungen.stringPrufung(value));
  }

  set anmeldung(String value) {
    _anmeldung =
        pruefungen.prufeName(pruefungen.stringPrufung(value));
  }

  set portal(String value) {
    _portal = pruefungen.prufeName(pruefungen.stringPrufung(value));
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
    _typid = pruefungen.prufeID(value);
  }

  set name(String value) {
    _name = pruefungen.prufeName(pruefungen.stringPrufung(value));
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
    _permissionid = pruefungen.prufeID(value);
  }

  set code(String value) {
    //TODO ka ob code auch Zahlen enthaten kann oder zahlen sind
    _code = pruefungen.stringPrufung(value);
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
  //formatter:off
  UserTermin(
      int platze,
      int terminid,
      int veranstaltungsid,
      String ort,
      String name,
      String beschreibung,
      DateTime anmeldungStart,
      DateTime anmeldungEnd,
      DateTime timeVon,
      DateTime timeBis,
      Zyklus zyklus,
      List<User> teilnehmer) {
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
  } //formatter:on

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

  ///Die maximale platzanzahl auf der Website ist 99
  set platze(int value) {
    if (value < 1 || value > 99) {
      throw Exception('Die Platzanzahl ist ungültig.');
    } else {
      _platze = value;
    }
  }

  set terminID(int value) {
    _terminid = pruefungen.prufeID(value);
  }

  set veranstaltungsid(int value) {
    _veranstaltungsid = pruefungen.prufeID(value);
  }

  set ort(String value) {
    _ort = pruefungen.prufeOrt(pruefungen.stringPrufung(value));
  }

  set name(String value) {
    _name = pruefungen.prufeName(pruefungen.stringPrufung(value));
  }

  set beschreibung(String value) {
    _beschreibung =
        pruefungen.prufeName(pruefungen.stringPrufung(value));
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

  ///Constructor
  //formatter:off
  AdminTermin(
      int platze,
      int terminid,
      int veranstaltungsid,
      String ort,
      String name,
      String beschreibung,
      DateTime anmeldungStart,
      DateTime anmeldungEnd,
      DateTime timeVon,
      DateTime timeBis,
      Zyklus zyklus,
      List<User> teilnehmer,
      bool freigeschaltet)
      : super(
            platze,
            terminid,
            veranstaltungsid,
            ort,
            name,
            beschreibung,
            anmeldungStart,
            anmeldungEnd,
            timeVon,
            timeBis,
            zyklus,
            teilnehmer) {
    this.freigeschaltet = freigeschaltet;
  } //formatter:on

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
    _zyklusid = pruefungen.prufeID(value);
  }

  set name(String value) {
    _name = pruefungen.prufeName(pruefungen.stringPrufung(value));
  }
}
