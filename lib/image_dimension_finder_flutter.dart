import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_dimension_finder_flutter/bridge_generated.dart';

final ValueNotifier<ImageDimensionFetcherLibImpl?> _dimensionFetcherLibImpl =
    ValueNotifier(null);

class ImageDimensionFinderFlutter {
  static final ImageDimensionFinderFlutter _singleton =
      ImageDimensionFinderFlutter._internal();

  factory ImageDimensionFinderFlutter() {
    return _singleton;
  }

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
  }
  Future<ImageDimension> getDim({required String url}) async {
    var dim = await _dimensionFetcherLibImpl.value!.getDim(url: url);
    return dim;
  }
}
