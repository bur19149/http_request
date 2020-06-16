// @formatter:off
Exception exceptionHandler(int statusCode, {String c400, String c401, String c403,
                                            String c404, String c405, String c409,
                                            String c410, String c422, String c423,
                                            String c429, String c500, String c501, String c503}) {
  Exception exception;
  switch (statusCode) {
    case 400: exception = Exception400(c400); break;
    case 401: exception = Exception401(c401); break;
    case 403: exception = Exception403(c403); break;
    case 404: exception = Exception404(c404); break;
    case 405: exception = Exception405(c405); break;
    case 409: exception = Exception409(c409); break;
    case 410: exception = Exception410(c410); break;
    case 422: exception = Exception422(c422); break;
    case 423: exception = Exception423(c423); break;
    case 429: exception = Exception429(c429); break;
    case 500: exception = Exception500(c500); break;
    case 501: exception = Exception501(c501); break;
    case 503: exception = Exception503(c503); break;
    default: exception = Exception('Unerwarteter Fehler: $statusCode');
  }
  return exception;
} // @formatter:on

class Exception400 implements Exception {
  final String message;

  Exception400([this.message]);

  @override
  String toString() {
    if (message == null) {
      return 'Exception (400): Bad Request / Allgemeiner Fehler in der Anfrage';
    }
    return 'Exception (400): $message';
  }
}

class Exception401 implements Exception {
  final String message;

  Exception401([this.message]);

  @override
  String toString() {
    if (message == null) {
      return 'Exception (401): Kein Token mitgeschickt oder Token existiert nicht';
    }
    return 'Exception (401): $message';
  }
}

class Exception403 implements Exception {
  final String message;

  Exception403([this.message]);

  @override
  String toString() {
    if (message == null) return 'Exception (403): Keine Berechtigung';
    return 'Exception (403): $message';
  }
}

class Exception404 implements Exception {
  final String message;

  Exception404([this.message]);

  @override
  String toString() {
    if (message == null) return 'Exception (404): Anfrage existiert nicht';
    return 'Exception (404): $message';
  }
}

class Exception405 implements Exception {
  final String message;

  Exception405([this.message]);

  @override
  String toString() {
    if (message == null) {
      return 'Exception (405): Falsche Request Methode verwendet';
    }
    return 'Exception (405): $message';
  }
}

class Exception409 implements Exception {
  final String message;

  Exception409([this.message]);

  @override
  String toString() {
    if (message == null) {
      return 'Exception (409): Die Anfrage wurde unter falschen Annahmen gestellt';
    }
    return 'Exception (409): $message';
  }
}

class Exception410 implements Exception {
  final String message;

  Exception410([this.message]);

  @override
  String toString() {
    if (message == null) return 'Exception (410): Die Ressource wurde entfernt';
    return 'Exception (410): $message';
  }
}

class Exception422 implements Exception {
  final String message;

  Exception422([this.message]);

  @override
  String toString() {
    if (message == null) return 'Exception (422): Semantisch falsche Anfrage';
    return 'Exception (422): $message';
  }
}

class Exception423 implements Exception {
  final String message;

  Exception423([this.message]);

  @override
  String toString() {
    if (message == null) {
      return 'Exception (423): Die Ressource ist noch nicht zugänglich';
    }
    return 'Exception (423): $message';
  }
}

class Exception429 implements Exception {
  final String message;

  Exception429([this.message]);

  @override
  String toString() {
    if (message == null) {
      return 'Exception (429): Es wurden zu viele Anfragen gestellt';
    }
    return 'Exception (429): $message';
  }
}

class Exception500 implements Exception {
  final String message;

  Exception500([this.message]);

  @override
  String toString() {
    if (message == null) return 'Exception (500): Allgemeiner Server Fehler';
    return 'Exception (500): $message';
  }
}

class Exception501 implements Exception {
  final String message;

  Exception501([this.message]);

  @override
  String toString() {
    if (message == null) {
      return 'Exception (501): Anfrage wurde noch nicht implementiert';
    }
    return 'Exception (501): $message';
  }
}

class Exception503 implements Exception {
  final String message;

  Exception503([this.message]);

  @override
  String toString() {
    if (message == null) return 'Exception (503): API ist im Wartungsmodus';
    return 'Exception (503): $message';
  }
}
