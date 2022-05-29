import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_dimension_finder_flutter/bridge_generated.dart';

class ImageDimensionFinderFlutter {
  late ImageDimensionFetcherLibImpl imp;
  ImageDimensionFinderFlutter() {
    late final lib;
    if (Platform.isAndroid) {
      lib = DynamicLibrary.open("libimage_dimension_fetcher_lib.so");
    } else {
      lib = DynamicLibrary.process();
    }
    imp = ImageDimensionFetcherLibImpl(lib);
  }
  Future<ImageDimension> getDim({required String url}) async {
    var dim = await imp.getDim(url: url);
    return dim;
  }
}
