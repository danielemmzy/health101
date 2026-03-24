// lib/utils/assets_preloader.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class AssetsPreloader {
  static Future<void> preloadAll(BuildContext context) async {
    try {
      // Read pubspec.yaml to get all declared assets
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Filter only image assets (png, jpg, jpeg, gif, svg, etc.)
      final imageAssets = manifestMap.keys.where((String key) {
        return key.startsWith('assets/') &&
            (key.endsWith('.png') ||
                key.endsWith('.jpg') ||
                key.endsWith('.jpeg') ||
                key.endsWith('.gif') ||
                key.endsWith('.svg'));
      }).toList();

      debugPrint("Preloading ${imageAssets.length} image assets...");

      for (String asset in imageAssets) {
        try {
          await precacheImage(AssetImage(asset), context);
        } catch (e) {
          debugPrint("Failed to precache: $asset");
        }
      }

      debugPrint("All images preloaded!");
    } catch (e) {
      debugPrint("Asset preload failed: $e");
    }
  }
}