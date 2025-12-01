import 'package:flutter/services.dart';

import './levelplay_constants.dart';
import '../levelplay.dart';

/// A singleton to access the general plugin method channel
class LevelPlayMethodChannel {
  static final LevelPlayMethodChannel _instance = LevelPlayMethodChannel._internal();
  final MethodChannel _channel = const MethodChannel(LevelPlayConstants.METHOD_CHANNEL)..setMethodCallHandler(LevelPlay.handleMethodCall);

  LevelPlayMethodChannel._internal();

  factory LevelPlayMethodChannel() {
    return _instance;
  }

  MethodChannel get channel => _channel;
}