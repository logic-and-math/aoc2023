import 'input.dart';
import 'dart:math';
import 'package:collection/collection.dart';

typedef Ticket = ({List<int> numbers, List<int> winningNumbers});
void main() {
  final List<Ticket> tickets = [];

  for (var line in input.split("\n")) {
    final semicolon = line.indexOf(":");

    final parts = line.substring(semicolon + 1).split("|");
    var matches = RegExp(r'\d+').allMatches(parts[0]);
    final numbers = matches.map((e) => int.parse(e.group(0)!)).toList();
    matches = RegExp(r'\d+').allMatches(parts[1]);
    final winningNumbers = matches.map((e) => int.parse(e.group(0)!)).toList();
    tickets.add((numbers: numbers, winningNumbers: winningNumbers));
  }

  //part 1
  final p1 = tickets.map((e) {
    final nMatches =
        Set.from(e.winningNumbers).intersection(Set.from(e.numbers)).length;
    return nMatches == 0 ? 0 : pow(2, (nMatches - 1));
  }).sum;
  print(p1);

  //part 2
  final ticketNumbers = tickets.map((e) => 1).toList();
  for (var (i, ticket) in tickets.indexed) {
    final nMatches = Set.from(ticket.winningNumbers)
        .intersection(Set.from(ticket.numbers))
        .length;
    //how many original + copies of this ticket we have
    final n = ticketNumbers[i];
    for (var j = i + 1; j < min(i + 1 + nMatches, ticketNumbers.length); j++) {
      ticketNumbers[j] += n;
    }
  }

  print(ticketNumbers.sum);
}
