import 'requests/variables.dart' as variables;
//import 'package:path_provider/path_provider.dart';
import 'pruefungen.dart' as pruefungen;
import 'package:http/http.dart' as http;
import 'dart:io';

class User {
  // -------------------------------- Variablen -------------------------------

  // @formatter:off
  int        _userID;       // einzigartige ID
  String     _jugendgruppe;
  String     _nachname;
  String     _vorname;
  String     _email;
  String     _plz;
  String     _ort;
  User       parent;        // (optional) zugeordneter Elternaccount wenn Kind
  UserTyp    _typ;
  List<User> _children;     // (optional) zugeordnete Kinder wenn Elternaccount
  bool       registered;    // Zweck des Parameters wird in API-Doku nicht erklärt
  // @formatter:on

  // ----------------------------- Konstruktoren ------------------------------

  // @formatter:off
  ///Constructor
  User(int userID, String vorname, String nachname, String email, String plz, String ort,
      UserTyp typ, String jugendgruppe, User parent, List<User> children, bool registered) {
    this.userID       = userID;
    this.vorname      = vorname;
    this.nachname     = nachname;
    this.email        = email;
    this.plz          = plz;
    this.ort          = ort;
    this.typ          = typ;
    this.jugendgruppe = jugendgruppe;
    this.parent       = parent;
    this.children     = children;
    this.registered   = registered;
  } // @formatter:on

  // --------------------------------- Setter ---------------------------------

  set userID(int value) {
    _userID = pruefungen.prufeID(value);
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

  set plz(String value) {//wann man "value" auf int setzt schreit der DUMME kompiler.
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
      throw Exception('Null übergabe.');
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

  // --------------------------------- Getter ---------------------------------

  // @formatter:off
  int        get userID       => _userID;
  String     get vorname      => _vorname;
  String     get nachname     => _nachname;
  String     get jugendgruppe => _jugendgruppe;
  String     get plz          => _plz;
  String     get ort          => _ort;
  String     get email        => _email;
  UserTyp    get typ          => _typ;
  List<User> get children     => _children;
  // @formatter:on

  // -------------------------------- toString --------------------------------

  @override
  String toString() {
    String str = 'Name:         $_vorname $_nachname ($_userID)\nWohnort:      '
        '$_ort ($_plz)\nE-Mail:       $_email\nJugendgruppe: $_jugendgruppe\nRegistriert:  '
        '$registered\n${_typ.toString()}';
    if (parent != null) {
      str += 'Elternteil:   ${parent.vorname} ${parent.nachname} (${parent.userID})';
    }
    if (_children != null && _children.isNotEmpty) {
      str += '\nKinder:\n---------------\n';
      for (User child in _children) {
        str += '${child.vorname} ${child.nachname} (${child.userID})\n';
      }
      str += '---------------\n';
    }
    return str;
  }
}

class Admin extends User {
  // -------------------------------- Variablen -------------------------------

  String dsgvo;
  String portal;
  String anmeldung;

  // ----------------------------- Konstruktoren ------------------------------

  // @formatter:off
  ///Constructor
  Admin(int userID, String vorname, String nachname, String email, String plz, String ort,
      UserTyp typ, String jugendgruppe, User parent, List<User> children, bool registered,
      String dsgvo, String portal, String anmeldung)
    :super(userID, vorname, nachname, email, plz, ort, typ, jugendgruppe, parent, children, registered) {
    this.dsgvo     = dsgvo;
    this.portal    = portal;
    this.anmeldung = anmeldung;
  } // @formatter:on

  // -------------------------------- toString --------------------------------

  // @formatter:off
  @override
  String toString() {
    return super.toString() +
        (dsgvo     != null && dsgvo.isNotEmpty     ? 'DSGVO:        $dsgvo\n'     : '') +
        (anmeldung != null && anmeldung.isNotEmpty ? 'Anmeldung:    $anmeldung\n' : '') +
        (portal    != null && portal.isNotEmpty    ? 'Portal:       $portal'      : '');
  } // @formatter:on
}

class UserTyp {
  // -------------------------------- Variablen -------------------------------

  // @formatter:off
  int              _typID;       // ID des Typs
  String           _name;        // Bezeichnung des Usertyps z. B. Admin
  List<Permission> _permissions; // Liste der Berechtigungen
  // @formatter:on

  // ----------------------------- Konstruktoren ------------------------------

  // @formatter:off
  UserTyp(int typID, String name, List<Permission> permission) {
    this.typID       = typID;
    this.name        = name;
    this.permissions = permission;
  } // @formatter:on

  // --------------------------------- Setter ---------------------------------

  set typID(int value) {
    _typID = pruefungen.prufeID(value);
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

  // --------------------------------- Getter ---------------------------------

  // @formatter:off
  int              get typID       => _typID;
  String           get name        => _name;
  List<Permission> get permissions => _permissions;
  // @formatter:on

  // -------------------------------- toString --------------------------------

  @override
  String toString() {
    String str = 'User-Typ:     $_name ($_typID)\nBerechtigungen:\n---------------\n';
    for (Permission p in _permissions) {
      str += p.toString() + '\n---------------\n';
    }
    return str;
  }
}

class Permission {
  // -------------------------------- Variablen -------------------------------

  // @formatter:off
  int    _permissionID; // einzigartige ID
  String description;   // Beschreibung der Berechtigung
  String name;
  String _code;         // Berechtigungscode z. B. termin.bearbeiten
  // @formatter:on

  // ----------------------------- Konstruktoren ------------------------------

  // @formatter:off
  Permission(int permissionID, String name, String description, String code) {
    this.permissionID = permissionID;
    this.name         = name;
    this.description  = description;
    this.code         = code;
  } // @formatter:on

  // --------------------------------- Setter ---------------------------------

  set permissionID(int value) {
    _permissionID = pruefungen.prufeID(value);
  }

  set code(String value) {
    _code = pruefungen.stringPrufung(value);
  }

  // --------------------------------- Getter ---------------------------------

  // @formatter:off
  int    get permissionID => _permissionID;
  String get code         => _code;
  // @formatter:on

  // -------------------------------- toString --------------------------------

  @override
  String toString() {
    return 'Berechtigung: $name ($_permissionID)\nBeschreibung: $description\nCode:         $_code';
  }
}

class UserTermin {

  // -------------------------------- Variablen -------------------------------

  // @formatter:off
  int        _plaetze;
  int        _terminID;
  int        _veranstaltungsID;
  String     _ort;
  String     _name;
  String     _beschreibung;
  DateTime   _anmeldungStart;
  DateTime   _anmeldungEnde;
  DateTime   _timeVon;
  DateTime   _timeBis;
  Zyklus     _zyklus;
  List<User> teilnehmer;
  // @formatter:on

  // ----------------------------- Konstruktoren ------------------------------

  // @formatter:off
  /// Konstruktor
  UserTermin(int plaetze, int terminID, int veranstaltungsID, String ort, String name,
      String beschreibung, DateTime anmeldungStart, DateTime anmeldungEnd, DateTime timeVon,
      DateTime timeBis, Zyklus zyklus, List<User> teilnehmer) {
    this.plaetze           = plaetze;
    this.terminID         = terminID;
    this.veranstaltungsID = veranstaltungsID;
    this.ort              = ort;
    this.name             = name;
    this.beschreibung     = beschreibung;
    this.anmeldungStart   = anmeldungStart;
    this.anmeldungEnde    = anmeldungEnd;
    this.timeVon          = timeVon;
    this.timeBis          = timeBis;
    this.zyklus           = zyklus;
    this.teilnehmer       = teilnehmer;
  } //formatter:on

  // --------------------------------- Setter ---------------------------------

  set anmeldungStart(DateTime value) {
    if (value == null) {
      throw ('Error: Das Datum ist Null.');
    } else if (_timeVon != null && value.isAfter(_timeBis)) {
      throw ('Error: Das Datum ist nach dem Ende.');
    } else if (value.isBefore(DateTime.now())) {
      throw ('Der Termin darf nicht in der Verganganheit stattfinden.');
    } else {
      _anmeldungStart = value;
    }
  }

  set anmeldungEnde(DateTime value) {
    if (value == null) {
      throw ('Error: Das Datum ist Null.');
    } else if (_timeVon != null && value.isBefore(_timeVon)) {
      throw ('Das Enddatum darf nicht vor dem beginn stattfinden.');
    } else {
      _anmeldungEnde = value;
    }
  }

  set timeVon(DateTime value) {
    if (value == null) {
      throw ('Error: Das Datum ist Null.');
    } else if (_timeVon != null && value.isAfter(_timeBis)) {
      throw ('Error: Das Datum ist nach dem Ende.');
    } else if (value.isBefore(DateTime.now())) {
      throw ('Der Termin darf nicht in der Verganganheit stattfinden.');
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

  /// Die maximale platzanzahl auf der Website ist 99
  set plaetze(int value) {
    if (value < 1 || value > 99) {
      throw Exception('Die Platzanzahl ist ungültig.');
    } else {
      _plaetze = value;
    }
  }

  set terminID(int value) {
    _terminID = pruefungen.prufeID(value);
  }

  set veranstaltungsID(int value) {
    _veranstaltungsID = pruefungen.prufeID(value);
  }

  set ort(String value) {
    _ort = pruefungen.prufeOrt(pruefungen.stringPrufung(value));
  }

  set name(String value) {
    _name = pruefungen.prufeName(pruefungen.stringPrufung(value));
  }

  set beschreibung(String value) {
    _beschreibung = pruefungen.prufeName(pruefungen.stringPrufung(value));
  }

  set zyklus(Zyklus value) {
    if (value == null) {
      throw Exception('Null übergabe.');
    } else {
      _zyklus = value;
    }
  }

  // --------------------------------- Getter ---------------------------------

  // @formatter:off
  int      get plaetze          => _plaetze;
  int      get terminID         => _terminID;
  int      get veranstaltungsID => _veranstaltungsID;
  String   get ort              => _ort;
  String   get name             => _name;
  String   get beschreibung     => _beschreibung;
  DateTime get anmeldungStart   => _anmeldungStart;
  DateTime get anmeldungEnde    => _anmeldungEnde;
  DateTime get timeVon          => _timeVon;
  DateTime get timeBis          => _timeBis;
  Zyklus   get zyklus           => _zyklus;
  // @formatter:on

  // -------------------------------- toString --------------------------------

  @override
  String toString() {
    String str = 'Termin: $_name ($_terminID)\nAnzahl Plätze: $_plaetze\nOrt: $ort\nBeschreibung: '
        '$_beschreibung\nVeranstaltungs-ID: $_veranstaltungsID\nAnmeldestart: '
        '$_anmeldungStart\nAnmeldeschluss: $_anmeldungEnde\nUhrzeit: $_timeVon - '
        '$_timeBis\n{$_zyklus}';
    if (teilnehmer.isNotEmpty) {
      str += '\nTeilnehmer:\n---------------\n';
      for (User user in teilnehmer) {
        str += '${user.vorname} ${user.nachname} (${user.userID})\n';
      }
      str += '\n---------------\n';
    }
    return str;
  }
}

class AdminTermin extends UserTermin {

  // -------------------------------- Variablen -------------------------------

  bool freigeschaltet;

  // ----------------------------- Konstruktoren ------------------------------

  // @formatter:off
  /// Konstructor
  AdminTermin(int platze, int terminid, int veranstaltungsid, String ort, String name,
      String beschreibung, DateTime anmeldungStart, DateTime anmeldungEnd, DateTime timeVon,
      DateTime timeBis, Zyklus zyklus, List<User> teilnehmer, bool freigeschaltet)
      : super(platze, terminid, veranstaltungsid, ort, name, beschreibung, anmeldungStart,
      anmeldungEnd, timeVon, timeBis, zyklus, teilnehmer) {
    this.freigeschaltet = freigeschaltet;
  } // @formatter:on

  // -------------------------------- toString --------------------------------

  @override
  String toString() {
    return super.toString() + 'freigeschaltet: $freigeschaltet';
  }
}

class Zyklus {

  // -------------------------------- Variablen -------------------------------

  // @formatter:off
  int   _zyklusID;
  String _name;
  // @formatter:on

  // ----------------------------- Konstruktoren ------------------------------

  // @formatter:off
  /// Konstruktor
  Zyklus(int zyklusID, String name) {
    this.zyklusID = zyklusID;
    this.name     = name;
  } // @formatter:on

  // --------------------------------- Setter ---------------------------------

  set zyklusID(int value) {
    _zyklusID = pruefungen.prufeID(value);
  }

  set name(String value) {
    _name = pruefungen.prufeName(pruefungen.stringPrufung(value));
  }

  // --------------------------------- Getter ---------------------------------

  // @formatter:off
  int    get zyklusID => _zyklusID;
  String get name     => _name;
  // @formatter:on

  // -------------------------------- toString --------------------------------

  @override
  String toString() {
    return 'Zyklus: $_name ($_zyklusID)';
  }
}

class Antwort {

  // -------------------------------- Variablen -------------------------------

  // @formatter:off
  int    _id;
  String _name;
  // @formatter:on

  // ----------------------------- Konstruktoren ------------------------------

  // @formatter:off
  /// Konstruktor
  Antwort(int id, String name){
    this.id = id;
    this.name = name;
  } // @formatter:on

  // --------------------------------- Setter ---------------------------------

  set id(int id) {
    _id = id;
  }

  set name(String name) {
    _name = name;
  }

  // --------------------------------- Getter ---------------------------------

  // @formatter:off
  int    get id   => _id;
  String get name => _name;
  // @formatter:on

  // -------------------------------- toString --------------------------------

  @override
  String toString() {
    return 'Antwort: $_name ($_id)';
  }
}

class TerminAntwort {

  // -------------------------------- Variablen -------------------------------

  // @formatter:off
  User    _user;
  Antwort _antwort;
  String  kommentar;
  // @formatter:on

  // ----------------------------- Konstruktoren ------------------------------

  // @formatter:off
  /// Konstruktor
  TerminAntwort(User user, Antwort antwort, String kommentar) {
    this.user      = user;
    this.antwort   = antwort;
    this.kommentar = kommentar;
  } // @formatter:on

  // --------------------------------- Setter ---------------------------------

  set user(User user) {
    _user = user;
  }

  set antwort(Antwort antwort) {
    _antwort = antwort;
  }

  // --------------------------------- Getter ---------------------------------

  // @formatter:off
  User    get user    => _user;
  Antwort get antwort => _antwort;
  // @formatter:on

  // -------------------------------- toString --------------------------------

  @override
  String toString() {
    return 'Termin-Antwort: ${_user.vorname} ${_user.nachname} (${_user
        .userID})\n${_antwort}';
  }
}