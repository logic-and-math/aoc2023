import 'input.dart';
import 'package:dart_numerics/dart_numerics.dart';

void main() {
  final lines = input.split(("\n"));
  final instructions = lines[0].split("");

  final nodes = <String, ({String left, String right})>{};
  for (var line in lines.skip(2)) {
    final node = line.split(" = ")[0];
    final parts =
        line.split(" = ")[1].replaceAll("(", "").replaceAll(")", "").split(",");
    nodes[node] = (left: parts[0].trim(), right: parts[1].trim());
  }

  int p1(String start, bool Function(String) isFinal) {
    var current = start;
    var instructionIndex = 0;
    var i = 0;
    while (!isFinal(current)) {
      final instruction = instructions[instructionIndex];

      if (instruction == "L") {
        current = nodes[current]!.left;
      } else {
        current = nodes[current]!.right;
      }

      instructionIndex = instructionIndex == (instructions.length - 1)
          ? 0
          : instructionIndex + 1;

      i += 1;
    }

    return i;
  }

  //part 1
  print(p1("AAA", (node) => node == "ZZZ"));

  //part 2
  final startNodes = nodes.keys.where((e) => e.endsWith("A"));
  final steps = startNodes
      .map((start) => p1(start, (node) => node.endsWith("Z")))
      .toList();
  print(leastCommonMultipleOfMany(steps));
}
