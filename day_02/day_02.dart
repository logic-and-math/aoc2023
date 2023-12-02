import 'package:collection/collection.dart';

import 'input.dart';

main() {
  final lines = input.split('\n');
  final games = lines
      .map((e) => RegExp(r'\d+ [a-z]+').allMatches(e))
      .map((e) => e.map((e) => e.group(0)!.split(" ")).map(
            (e) => (count: int.parse(e[0]), color: e[1]),
          ));

  final testMoves = [
    (count: 12, color: "red"),
    (count: 14, color: "blue"),
    (count: 13, color: "green")
  ];

  final colorToCount = {for (var move in testMoves) move.color: move.count};

  //part 1
  var sum = 0;
  for (var (i, game) in games.indexed) {
    final gameValid = game
        .where((move) => colorToCount[move.color] != null)
        .every((move) => move.count <= colorToCount[move.color]!);
    if (gameValid) {
      sum += i + 1;
    }
  }
  print(sum);

  //part 2
  final result = games
      .map(
        (e) => e.groupFoldBy<String, int>(
          (move) => move.color,
          (previous, element) => (previous != null && previous > element.count)
              ? previous
              : element.count,
        ),
      )
      .map((e) => e.values.reduce((value, element) => value * element))
      .reduce((value, element) => value + element);

  print(result);
}
