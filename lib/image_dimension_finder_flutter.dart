import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_dimension_finder_flutter/bridge_generated.dart';

final ValueNotifier<ImageDimensionFetcherLibImpl?> _dimensionFetcherLibImpl =
    ValueNotifier(null);

class ImageDimensionFinderFlutter {
  static ImageDimensionFinderFlutter? _singleton;

  factory ImageDimensionFinderFlutter() {
    _singleton ??= ImageDimensionFinderFlutter._internal();
    return _singleton!;
  }

  Map<String, Completer<ImageDimension>> queue = {};

  ImageDimensionFinderFlutter._internal() {
    if (_dimensionFetcherLibImpl.value == null) {
      late final DynamicLibrary lib;
      if (Platform.isAndroid) {
        lib = DynamicLibrary.open("libimage_dimension_fetcher_lib.so");
      } else {
        lib = DynamicLibrary.process();
      }
      _dimensionFetcherLibImpl.value = ImageDimensionFetcherLibImpl(lib);
    }
    Timer.run(() async {
      while (true) {
        await Future.delayed(const Duration(milliseconds: 50));
        for (var key in queue.keys) {
          if (queue[key]?.isCompleted == false) {
            try {
              var dim = await _dimensionFetcherLibImpl.value?.getDim(url: key);
              queue[key]?.complete(dim);
            } catch (e) {
              queue[key]?.completeError(e);
            }
          }
        }
      }
    });
  }
  Future<ImageDimension> getDim({required String url}) async {
    if (queue[url] == null) {
      queue[url] = Completer();
    }
    return queue[url]!.future;
  }
}
