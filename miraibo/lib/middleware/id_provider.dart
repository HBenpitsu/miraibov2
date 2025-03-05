import 'dart:io' show pid;

class IdProvider {
  static IdProvider? _instance;

  int _variant = 0;
  static const int _variantLength = 10;
  static const int _maxVariant = 1 << _variantLength;
  static const int _variantMask = _maxVariant - 1;
  late final int _processSignature;
  IdProvider._() {
    final processId = pid;
    _processSignature = processId << 52;
    // 2**52 microseconds nearly equals to 142 years
  }
  factory IdProvider() {
    return _instance ??= IdProvider._();
  }
  int get() {
    final variant = _variant;
    _variant = (_variant + 1) & _variantMask;
    final id = DateTime.now().microsecondsSinceEpoch * _maxVariant +
        variant +
        _processSignature;
    return id;
  }
}
