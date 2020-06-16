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

// @formatter:off
class Exception400 extends _HttpException { Exception400([String message]) : super(400, 'Bad Request / Allgemeiner Fehler in der Anfrage',    message); }
class Exception401 extends _HttpException { Exception401([String message]) : super(401, 'Kein Token mitgeschickt oder Token existiert nicht', message); }
class Exception403 extends _HttpException { Exception403([String message]) : super(403, 'Keine Berechtigung',                                 message); }
class Exception404 extends _HttpException { Exception404([String message]) : super(404, 'Anfrage existiert nicht',                            message); }
class Exception405 extends _HttpException { Exception405([String message]) : super(405, 'Falsche Request Methode verwendet',                  message); }
class Exception409 extends _HttpException { Exception409([String message]) : super(409, 'Die Anfrage wurde unter falschen Annahmen gestellt', message); }
class Exception410 extends _HttpException { Exception410([String message]) : super(410, 'Die Ressource wurde entfernt',                       message); }
class Exception422 extends _HttpException { Exception422([String message]) : super(422, 'Semantisch falsche Anfrage',                         message); }
class Exception423 extends _HttpException { Exception423([String message]) : super(423, 'Die Ressource ist noch nicht zugänglich',            message); }
class Exception429 extends _HttpException { Exception429([String message]) : super(429, 'Es wurden zu viele Anfragen gestellt',               message); }
class Exception500 extends _HttpException { Exception500([String message]) : super(500, 'Allgemeiner Server Fehler',                          message); }
class Exception501 extends _HttpException { Exception501([String message]) : super(501, 'Anfrage wurde noch nicht implementiert',             message); }
class Exception503 extends _HttpException { Exception503([String message]) : super(503, 'API ist im Wartungsmodus',                           message); }
// @formatter:on

class _HttpException implements Exception { // @formatter:off

  final int    code;
  final String standardMessage;
  final String message;

  _HttpException(this.code, this.standardMessage, [this.message]);

  @override
  String toString() {
    if (message == null) {
      return 'Exception ($code): $standardMessage';
    }
    return 'Exception ($code): $message';
  }
} // @formatter:on
