import 'package:flutter_test/flutter_test.dart';
import 'package:shared/base_app.dart';

void main() {
  test('identifies handset based on width', () {
    expect(DeviceType.isHandset(601), false);
    expect(DeviceType.isHandset(600), false);
    expect(DeviceType.isHandset(599), true);
  });
}
