// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:image_dimension_finder_flutter/image_dimension_finder_flutter.dart';

// void main() {
//   const MethodChannel channel = MethodChannel('image_dimension_finder_flutter');

//   TestWidgetsFlutterBinding.ensureInitialized();

//   setUp(() {
//     channel.setMockMethodCallHandler((MethodCall methodCall) async {
//       return '42';
//     });
//   });

//   tearDown(() {
//     channel.setMockMethodCallHandler(null);
//   });

//   test('getPlatformVersion', () async {
//     expect(await ImageDimensionFinderFlutter.platformVersion, '42');
//   });
// }
