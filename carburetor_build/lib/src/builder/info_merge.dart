import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:carburetor_build/src/model/json.dart';
import 'package:carburetor_build/src/model/provide.dart';
import 'package:glob/glob.dart';

/// Reads all `.carburetor-info.json` files produced by [InfoExtractorBuilder]
/// and merges them into a single `carburetor.merged.json` file.
class InfoMergeBuilder extends Builder {
  InfoMergeBuilder();

  @override
  final Map<String, List<String>> buildExtensions = const {
    r'$lib$': ['src/carburetor.merged.json'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final merged = <ProvideInfo>[];

    final infoFiles = buildStep.findAssets(Glob('**.carburetor-info.json'));

    await for (final assetId in infoFiles) {
      final content = await buildStep.readAsString(assetId);
      final decoded = jsonDecode(content);
      if (decoded is! List) {
        throw Exception('Expected a list in ${assetId.path}, but got ${decoded.runtimeType}.');
      }
      for (final item in decoded) {
        if (item is! Json) {
          throw Exception('Expected a JSON object in ${assetId.path}, but got ${item.runtimeType}.');
        }
        merged.add(ProvideInfo.fromJson(item));
      }
    }

    final outputId = buildStep.allowedOutputs.first;
    await buildStep.writeAsString(outputId, jsonEncode(merged));
  }
}
