import 'input.dart';

main() {
  final lines = input.split("\n");

  //part 1
  var digits = lines
      .map((line) => line.replaceAll(RegExp(r"[^0-9]"), ''))
      .map((e) => e.isEmpty ? "00" : e)
      .map((e) => e.length == 1 ? "$e$e" : e)
      .map((e) => "${e[0]}${e[e.length - 1]}")
      .map((e) => int.parse(e));
  print(digits.reduce((value, element) => value + element));

  //part 2
  final nameToDigit = {
    "zero": 0,
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "seven": 7,
    "eight": 8,
    "nine": 9,
  };

  String replaceDigitsInLine(String line) {
    var newLine = line;

    while (true) {
      final matches = <({int start, int end, String match})>[];

      for (var digitName in nameToDigit.keys) {
        var i = 0;
        while (i < newLine.length) {
          final startIndex = newLine.indexOf(digitName, i);
          if (startIndex == -1) {
            break;
          }

          final endIndex = startIndex + digitName.length;
          matches.add((start: startIndex, end: endIndex, match: digitName));
          i = startIndex + 1;
        }
      }

      matches.sort((a, b) => a.start.compareTo(b.start));

      if (matches.isEmpty) {
        break;
      }

      final match = matches.first;

      final overlappingMatch = matches
          .where((e) => e.start > match.start && e.start < match.end)
          .firstOrNull;

      final digitAsString = nameToDigit[match.match].toString();
      newLine = newLine.replaceRange(
        match.start,
        overlappingMatch?.start ?? match.end,
        digitAsString,
      );
    }

    return newLine;
  }

  digits = lines
      .map((line) => replaceDigitsInLine(line))
      .map((line) => line.replaceAll(RegExp(r"[^0-9]"), ''))
      .map((e) => e.isEmpty ? "00" : e)
      .map((e) => e.length == 1 ? "$e$e" : e)
      .map((e) => "${e[0]}${e[e.length - 1]}")
      .map((e) => int.parse(e));
  print(digits.reduce((value, element) => value + element));
}
