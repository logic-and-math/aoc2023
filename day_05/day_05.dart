import 'dart:math';

import 'package:collection/collection.dart';

import 'input.dart';

typedef MapName = ({String source, String dest});
typedef MapRange = ({int sStart, int sEnd, int dStart, int dEnd});
typedef Range = ({int start, int end});

void main() {
  late final List<int> seeds;
  final Map<MapName, List<MapRange>> maps = {};

  var currentMapName = (source: "", dest: "");
  for (var line in input.split("\n")) {
    if (line.contains("seeds")) {
      seeds = line
          .split(":")[1]
          .trim()
          .split(" ")
          .map((e) => int.parse(e))
          .toList();
    } else if (line.contains("-")) {
      final parts = line.replaceAll(" map:", "").split("-");
      currentMapName = (source: parts[0], dest: parts[2]);
      maps[currentMapName] = [];
    } else if (line.isNotEmpty) {
      final numbers = line.split(" ").map((e) => int.parse(e)).toList();
      final range = (
        sStart: numbers[1],
        sEnd: numbers[1] + numbers[2],
        dStart: numbers[0],
        dEnd: numbers[0] + numbers[2]
      );
      maps[currentMapName]!.add(range);
    }
  }
  //part 1
  final locations = [];
  for (var seed in seeds) {
    var name = 'seed';
    var value = seed;

    while (name != 'location') {
      final mapKey = maps.keys.firstWhere((mapName) => mapName.source == name);
      final ranges = maps[mapKey]!;
      final range =
          ranges.firstWhereOrNull((r) => r.sStart <= value && r.sEnd >= value);

      if (range != null) {
        final distanceSinceStart = value - range.sStart;
        value = range.dStart + distanceSinceStart;
      }
      name = mapKey.dest;
    }

    locations.add(value);
  }

  print(
      locations.reduce((value, element) => value < element ? value : element));

  //part 2
  final seedRanges = <Range>[
    for (var i = 0; i < seeds.length; i += 2)
      (start: seeds[i], end: seeds[i] + seeds[i + 1] - 1)
  ];
  final locationsP2 = <int>[];

  for (var seedRange in seedRanges) {
    var ranges = [seedRange];
    var name = 'seed';

    while (name != 'location') {
      final mapKey = maps.keys.firstWhere((mapName) => mapName.source == name);

      final mappedRanges = <Range>[];
      final mappedRangesSources = <Range>[];
      final unmappedRanges = <Range>[];

      for (var range in ranges) {
        //find the ranges which overlap
        final mapRanges = maps[mapKey]!.where((mapRange) {
          final hasOverlap = mapRange.sStart >= range.start &&
                  mapRange.sStart <= range.end ||
              range.start >= mapRange.sStart && range.start <= mapRange.sEnd;
          return hasOverlap;
        });

        if (mapRanges.isEmpty) {
          mappedRanges.add(range);
          mappedRangesSources.add(range);
          continue;
        }

        for (var mapRange in mapRanges) {
          final overlapStart = max(mapRange.sStart, range.start);
          final overlapEnd = min(mapRange.sEnd, range.end);

          final distanceSinceStart = overlapStart - mapRange.sStart;
          final destinationStart = mapRange.dStart + distanceSinceStart;
          final destinationEnd = destinationStart + overlapEnd - overlapStart;

          mappedRanges.add((start: destinationStart, end: destinationEnd));
          mappedRangesSources.add((start: overlapStart, end: overlapEnd));
        }
      }

      mappedRangesSources.sort((a, b) => a.start - b.start);

      var unmappedLimits = <int>[];
      for (var mappedRange in mappedRangesSources) {
        final start = mappedRange.start - 1;
        final end = mappedRange.end + 1;
        if (start <= end) {
          unmappedLimits.addAll([start, end]);
        }
      }

      final rangesBetweenMappedRanges = <Range>[
        for (int i = 0; i < unmappedLimits.length; i += 2)
          (start: unmappedLimits[i], end: unmappedLimits[i + 1])
      ];

      for (var range in ranges) {
        for (var rangeBetween in rangesBetweenMappedRanges) {
          final overlapStart = max(rangeBetween.start, range.start);
          final overlapEnd = min(rangeBetween.end, range.end);

          if (overlapStart <= overlapEnd) {
            unmappedRanges.add((start: overlapStart, end: overlapEnd));
          }
        }
      }
      print(mappedRanges.length);
      print("################################");

      ranges = mappedRanges;
      name = mapKey.dest;
    }

    locationsP2.addAll(ranges.map((e) => e.start));
  }

  print(locationsP2
      .reduce((value, element) => value < element ? value : element));
  return;
}
