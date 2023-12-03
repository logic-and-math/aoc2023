import 'input.dart';

typedef pos = ({int x, int y});
typedef posRange = ({int xStart, int xEnd, int y});

main() {
  final Map<posRange, int> numbers = {};
  final Map<pos, String> symbols = {};

  for (var (y, line) in input.split("\n").indexed) {
    final numberMatches = RegExp(r'\d+').allMatches(line);
    for (var m in numberMatches) {
      final number = int.parse(m.group(0)!);
      numbers[(xStart: m.start, xEnd: m.end, y: y)] = number;
    }

    final symbolMatches = RegExp(r'[^0-9.]').allMatches(line);
    for (var m in symbolMatches) {
      final symbol = m.group(0)!;
      symbols[(x: m.start, y: y)] = symbol;
    }
  }

  List<pos> getAdjacentPositions(posRange posR) {
    return [
      for (var x = posR.xStart; x < posR.xEnd; x++)
        for (var i = -1; i <= 1; i++)
          for (var j = -1; j <= 1; j++) (x: x + i, y: posR.y + j)
    ];
  }

  //better name would be numberPosRToAdjSymbolsPos
  final numberPosRToAdjSymbols = {};
  for (var posR in numbers.keys) {
    final adj = getAdjacentPositions(posR);
    final adjSymbols =
        [for (var p in adj) p].where((p) => symbols.containsKey(p)).toList();
    if (adjSymbols.isNotEmpty) numberPosRToAdjSymbols[posR] = adjSymbols;
  }

  final p1 = numbers.keys
      .where((posR) => numberPosRToAdjSymbols.containsKey(posR))
      .map((e) => numbers[e]!)
      .reduce((value, element) => value + element);

  print(p1);

  adjacentNumbers(pos p) {
    return numberPosRToAdjSymbols.keys
        .where((posR) => numberPosRToAdjSymbols[posR]!.contains(p))
        .map((posR) => numbers[posR]!);
  }

  final p2 = symbols.keys
      .where((p) => symbols[p] == '*')
      .where((p) => adjacentNumbers(p).length == 2)
      .map((p) => adjacentNumbers(p).first * adjacentNumbers(p).last)
      .reduce((value, element) => value + element);
  print(p2);
}
