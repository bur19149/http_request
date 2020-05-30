/// Prüft auf NULL, leeren String und liefert den String ohne
/// nachfolgende und führende leerzeichen zurück.
String stringPrufung(String value) {
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
String prufeName(String value) {
  var a = RegExp(r'^[A-Za-z0-9öÖäÄüÜßàéëïáêèíîôóúûŠšŽžÅÕõÇÊÎŞÛçşĂÂŢăâţĳÆØæøåÔŴŶÁÉÍÏŵŷÓÚẂÝÀÈÌÒÙẀỲËẄŸẃýì'
      r'òùẁỳẅÿĈĜĤĴŜŬĉĝĥĵŝŭĞİğıÐÞðþŐŰőűŒœãÑñÃẼĨŨỸẽĩũỹĄĘĮŁŃąęįłńǪāēīōǫǭūŲųżćśźůŻČĆĐĎĚŇŘŤŮď'
      r'ěňřťĽĹŔľĺŕĀĒĢĪĶĻŅŌŖŪģķļņŗĖėẢẠẰẲẴẮẶẦẨẪẤẬẺẸỀỂỄẾỆỈỊỎỌỒỔỖỐỘƠỜỞỠỚỢỦỤƯỪỬỮỨỰỶỴđảạằẳẵắặầ'
      r'ẩẫấậẻẹềểễếệỉịỏọồổỗốơờởỡớợủụưừửữứựỷỵꞗĕŏ᷄() ]+$');
  if (a.hasMatch(value)) {
    return value;
  } else {
    throw ('Ungültiger Name.');
  }
}

/// 9007199254740992 ist der grosste Integer in Javascript (API in JS) *throws up*
int prufeID(int value) {
  if (value < 0 || value > 9007199254740992) {
    throw Exception('Die ID ist ungültig $value.');
  } else {
    return value;
  }
}

String prufeOrt(String value) {
  RegExp a = RegExp(r'^[ a-zA-ZöÖäÄüÜ]+$');
  if (a.hasMatch(value)) {
    return value;
  } else {
    throw ('Ungüliger Ort.');
  }
}
