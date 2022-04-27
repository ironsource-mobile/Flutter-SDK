import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import '../ironsource_constants.dart';

/// based on ATTrackingManager.AuthorizationStatus
/// https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanager/authorizationstatus
enum ATTStatus { NotDetermined, Restricted, Denied, Authorized, Not14 }

/// The numbers are aligned with ATTrackingManager.AuthorizationStatus int values
/// -1 would be passed for iOS version < 14
extension ATTStatusParser on int {
  ATTStatus toATTStatus() {
    switch (this) {
      case 0:
        return ATTStatus.NotDetermined;
      case 1:
        return ATTStatus.Restricted;
      case 2:
        return ATTStatus.Denied;
      case 3:
        return ATTStatus.Authorized;
      default:
        return ATTStatus.Not14;
    }
  }
}

class ATTrackingManager {
  static const _METHOD_CHANNEL = '${IronConst.METHOD_CHANNEL}/att';
  static const MethodChannel _channel = MethodChannel(_METHOD_CHANNEL);

  static Future<ATTStatus> getTrackingAuthorizationStatus() async {
    if (!Platform.isIOS) {
      throw UnsupportedError("Unsupported Platform: This is an iOS specific API.");
    }
    int statusInt = await _channel.invokeMethod('getTrackingAuthorizationStatus');
    return statusInt.toATTStatus();
  }

  static Future<ATTStatus> requestTrackingAuthorization() async {
    if (!Platform.isIOS) {
      throw UnsupportedError("Unsupported Platform: This is an iOS specific API.");
    }
    int statusInt = await _channel.invokeMethod('requestTrackingAuthorization');
    return statusInt.toATTStatus();
  }
}
