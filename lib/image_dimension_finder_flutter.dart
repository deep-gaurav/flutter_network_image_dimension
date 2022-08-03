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
  var error;

  ImageDimensionFinderFlutter._internal() {
    if (_dimensionFetcherLibImpl.value == null) {
      try {
        late final DynamicLibrary lib;
        if (Platform.isAndroid) {
          lib = DynamicLibrary.open("libimage_dimension_fetcher_lib.so");
        } else {
          lib = DynamicLibrary.process();
        }
        _dimensionFetcherLibImpl.value = ImageDimensionFetcherLibImpl(lib);
      } catch (e) {
        error = e;
      }
    }
  }

  Future<ImageDimension> getDim(
      {required String url,
      Duration timeout = const Duration(seconds: 2)}) async {
    if (queue[url] == null) {
      queue[url] = Completer();
      if (_dimensionFetcherLibImpl.value == null && error != null) {
        queue[url]?.completeError(error);
      } else {
        try {
          _dimensionFetcherLibImpl.value
              ?.getDim(url: url)
              .then((dim) => queue[url]?.complete(dim))
              .catchError((error) {
            queue[url]?.completeError(error);
          });
        } catch (e) {
          queue[url]?.completeError(e);
        }
      }
    }
    var future = queue[url]!.future;
    future = future.timeout(timeout);
    return future;
  }
}
