import 'package:collection/collection.dart';

import 'input.dart';

void main() {
  final sequences = input
      .split("\n")
      .map((e) => e.split(" "))
      .map((e) => [for (var s in e) int.parse(s)])
      .toList();

  final result = sequences.map((e) => solveSequence(e)).sum;
  print(result);
}

int solveSequence(List<int> sequence) {
  if (sequence.every((e) => e == 0)) {
    return 0;
  }

  final differences = [
    for (int i = 0; i < sequence.length - 1; i++) sequence[i + 1] - sequence[i]
  ];

  final below = solveSequence(differences);
  //part 1
  // return sequence.last + below;
  //part 2
  return sequence.first - below;
}
