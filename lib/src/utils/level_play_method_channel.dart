import 'package:flutter/services.dart';

import './ironsource_constants.dart';
import './ironsource_method_call_handler.dart';

/// A singleton to access the general plugin method channel
class LevelPlayMethodChannel {
  static final LevelPlayMethodChannel _instance = LevelPlayMethodChannel._internal();
  final MethodChannel _channel = const MethodChannel(IronConst.METHOD_CHANNEL)..setMethodCallHandler(IronSourceMethodCallHandler.handleMethodCall);

  LevelPlayMethodChannel._internal();

  factory LevelPlayMethodChannel() {
    return _instance;
  }

  MethodChannel get channel => _channel;
}