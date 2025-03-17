class CSVLineHandler {
  static List<String> parse(String csvLine) {
    List<String> parsed = [];
    String buffer = '';
    bool isQuoted = false;
    bool isEscaped = false;
    for (int i = 0; i < csvLine.length; i++) {
      if (isEscaped) {
        buffer += csvLine[i];
        isEscaped = false;
        continue;
      }
      if (csvLine[i] == '\\') {
        isEscaped = true;
        continue;
      }
      if (csvLine[i] == '"') {
        isQuoted = !isQuoted;
        continue;
      }
      if (csvLine[i] == ',' && !isQuoted) {
        parsed.add(buffer);
        buffer = '';
        continue;
      }
      buffer += csvLine[i];
    }
    parsed.add(buffer);
    return parsed;
  }

  // replace " into \" and add " to the beginning and end of each string
  static String encode(List<dynamic> csvLine) {
    List<String> encoded = [];
    for (final cell in csvLine) {
      if (cell is String) {
        encoded.add('''"${cell.replaceAll('"', '\\"')}"''');
      } else if (cell is int || cell is double || cell is bool) {
        encoded.add(cell.toString());
      } else {
        throw UnimplementedError('not supported type: $cell');
      }
    }
    return encoded.join(',');
  }
}
