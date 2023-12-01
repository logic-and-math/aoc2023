import 'input.dart';

main() {
  final lines = input.split("\n");

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

  int lineValue(String line, {required bool onlyNumbers}) {
    final toMatch = nameToDigit.values.map((e) => e.toString()).toList();
    if (!onlyNumbers) {
      toMatch.addAll(nameToDigit.keys.toList());
    }

    final firstMatch = toMatch.where((e) => line.indexOf(e) != -1).reduce(
          (value, element) =>
              line.indexOf(value) < line.indexOf(element) ? value : element,
        );

    final lastMatch = toMatch.where((e) => line.lastIndexOf(e) != -1).reduce(
          (value, element) =>
              line.lastIndexOf(value) > line.lastIndexOf(element)
                  ? value
                  : element,
        );

    final first = nameToDigit[firstMatch] ?? firstMatch;
    final last = nameToDigit[lastMatch] ?? lastMatch;
    return int.parse("$first$last");
  }

  //part1
  print(lines
      .map((e) => lineValue(e, onlyNumbers: true))
      .reduce((value, element) => value + element));

  //part2
  print(lines
      .map((e) => lineValue(e, onlyNumbers: false))
      .reduce((value, element) => value + element));
}
