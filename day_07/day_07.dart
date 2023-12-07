import 'package:collection/collection.dart';

import 'input.dart';

enum Type { highCard, pair, twoPair, three, fullHouse, four, five }

final cards = ["2", "3", "4", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"];
final cardsP2 = [
  "J",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "T",
  "Q",
  "K",
  "A"
];

void main() {
  final lines = input.split("\n");
  final handToBid = {
    for (var line in lines) line.split(" ")[0]: int.parse(line.split(" ")[1])
  };
  final hands = handToBid.keys.toList();

  Type handToType(String startHand, {bool includeJokers = false}) {
    final hands = [startHand];
    if (includeJokers) {
      final otherCards =
          startHand.split("").where((e) => e != "J").toSet().toList();
      final jokerIndexes = startHand
          .split("")
          .mapIndexed((i, c) => c == "J" ? i : -1)
          .where((i) => i != -1)
          .toList();

      final List<List<String>> jokerCombinations = [];
      final combination = List.generate(jokerIndexes.length, (index) => "");
      getCombinations(
        0,
        combination,
        jokerCombinations,
        otherCards,
        jokerIndexes.length,
      );

      for (var comb in jokerCombinations) {
        var newHand = startHand;
        for (int i = 0; i < comb.length; i++) {
          final jokerIndex = jokerIndexes[i];
          newHand = newHand.replaceRange(jokerIndex, jokerIndex + 1, comb[i]);
        }
        hands.add(newHand);
      }
    }

    var bestResult = Type.highCard;
    for (var hand in hands) {
      final cardToCount = <String, int>{};

      for (var card in hand.split("")) {
        cardToCount[card] = (cardToCount[card] ?? 0) + 1;
      }

      //better to use a list
      final counts = <int, int>{};
      for (var count in cardToCount.values) {
        counts[count] = (counts[count] ?? 0) + 1;
      }

      late final Type type;
      if (counts[5] == 1) {
        type = Type.five;
      } else if (counts[4] == 1) {
        type = Type.four;
      } else if (counts[3] == 1 && counts[2] == 1) {
        type = Type.fullHouse;
      } else if (counts[3] == 1) {
        type = Type.three;
      } else if (counts[2] == 2) {
        type = Type.twoPair;
      } else if (counts[2] == 1) {
        type = Type.pair;
      } else {
        type = Type.highCard;
      }

      if (type.index > bestResult.index) {
        bestResult = type;
      }
    }

    return bestResult;
  }

  void runPart({required List<String> cards, required bool includeJoker}) {
    hands.sort(
      (h1, h2) {
        final t1 = handToType(h1, includeJokers: includeJoker);
        final t2 = handToType(h2, includeJokers: includeJoker);
        if (t1.index > t2.index) return 1;
        if (t1.index < t2.index) return -1;

        for (int i = 0; i < h1.length; i++) {
          final c1Value = cards.indexOf(h1[i]);
          final c2Value = cards.indexOf(h2[i]);
          if (c1Value > c2Value) return 1;
          if (c2Value > c1Value) return -1;
        }

        return 0;
      },
    );

    final res = hands.mapIndexed((i, h) => handToBid[h]! * (i + 1)).sum;
    print(res);
  }

  //p1
  runPart(cards: cards, includeJoker: false);

  //p2
  runPart(cards: cardsP2, includeJoker: true);
}

void getCombinations(
  int i, //current character index
  List<String> combination, //must be of size n
  List<List<String>> combinations, //we store all combinations here
  List<String> possibleValues,
  int n,
) {
  //tc
  if (i == n) {
    combinations.add([...combination]);
    return;
  }

  for (var s in possibleValues) {
    combination[i] = s;
    getCombinations(i + 1, combination, combinations, possibleValues, n);
  }
}
