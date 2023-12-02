import 'input.dart';

main() {
  final lines = input.split("\n");

  final nameToDigit = {
    "zero": "0",
    "one": "1",
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5",
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9",
  };

  int lineValue(String line, {required bool onlyNumbers}) {
    final toMatch = nameToDigit.values.toList();
    if (!onlyNumbers) {
      toMatch.addAll(nameToDigit.keys);
    }

    final matches = [
      for (var match in toMatch)
        (
          match: match,
          first: line.indexOf(match),
          last: line.lastIndexOf(match),
        ),
    ];

    final firstMatch =
        matches.where((e) => e.first != -1).min((e) => e.first).match;

    final lastMatch = matches.max((e) => e.last).match;

    final first = nameToDigit[firstMatch] ?? firstMatch;
    final last = nameToDigit[lastMatch] ?? lastMatch;
    return int.parse("$first$last");
  }

  //part1
  print(lines
      .map((e) => lineValue(e, onlyNumbers: true))
      .reduce((value, element) => value + element));

  //part2
  print(lines.map((e) => lineValue(e, onlyNumbers: false)).sum());
}

extension IterableExtensions<T> on Iterable<T> {
  T max(Comparable Function(T) selector) {
    return reduce((value, element) =>
        selector(value).compareTo(selector(element)) > 0 ? value : element);
  }

  T min(Comparable Function(T) selector) {
    return reduce((value, element) =>
        selector(value).compareTo(selector(element)) < 0 ? value : element);
  }

  T sum({T Function(T, T)? selector = null}) {
    if (selector == null || T is num) {
      return reduce((value, element) => (value as num) + (element as num) as T);
    } else {
      return reduce((value, element) => selector(value, element));
    }
  }
}
