import 'dart:math';
import 'package:collection/collection.dart';

import 'input.dart';

void main() {
  final lines = input.split("\n");
  var matches = RegExp(r'\d+').allMatches(lines[0]);
  final durations = matches.map((e) => int.parse(e.group(0)!)).toList();
  matches = RegExp(r'\d+').allMatches(lines[1]);
  final records = matches.map((e) => int.parse(e.group(0)!)).toList();

  final p1 = durations
      .mapIndexed((i, e) => nSolutions(e, records[i]))
      .reduce((value, element) => value * element);
  print(p1);

  final duration = int.parse(durations.map((e) => e.toString()).join());
  final record = int.parse(records.map((e) => e.toString()).join());
  final p2 = nSolutions(duration, record);
  print(p2);
}

int nSolutions(int duration, int record) {
  //holdTime^2 - holdTime * duration + record < 0
  final b = -duration;
  final c = record;
  final root1 = (-b + sqrt(pow(b, 2) - 4 * c)) / 2;
  final root2 = (-b - sqrt(pow(b, 2) - 4 * c)) / 2;

  final nIntSolution = root1.floor() - root2.ceil() + 1;
  return nIntSolution;
}
