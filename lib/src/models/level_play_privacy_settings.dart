import '../utils/level_play_method_channel.dart';

/// This class provides privacy APIs for the LevelPlay SDK.
///
/// It allows you to configure GDPR, CCPA, and COPPA privacy settings
/// to comply with various privacy regulations.
///
/// Native SDK Reference
/// - Android: LevelPlayPrivacySettings
/// -     iOS: LPMPrivacySettings
class LevelPlayPrivacySettings {
  static final _channel = LevelPlayMethodChannel().channel;

  /// Sets the consent per network for GDPR compliance.
  ///
  /// This method allows you to specify which ad networks have been granted
  /// user consent to collect and share data.
  ///
  /// [networkConsents] A map where keys are network identifiers (e.g., "Facebook", "AdMob")
  /// and values indicate consent status (true if the user has granted consent, false otherwise).
  ///
  /// Example:
  /// ```dart
  /// LevelPlayPrivacySettings.setGDPRConsents({
  ///   'Facebook': true,
  ///   'AdMob': false,
  ///   'Unity': true,
  /// });
  /// ```
  ///
  /// Native SDK Reference
  /// - Android: setGDPRConsents
  /// -     iOS: setGDPRConsents
  static Future<void> setGDPRConsents(Map<String, bool> networkConsents) async {
    return _channel.invokeMethod('setGDPRConsents', {'networkConsents': networkConsents});
  }

  /// Sets the CCPA (California Consumer Privacy Act) flag.
  ///
  /// This flag indicates whether the user has opted out of the sale of
  /// their personal information under CCPA regulations.
  ///
  /// [value] true if the user has opted out of the sale of their personal
  /// information, false otherwise.
  ///
  /// Example:
  /// ```dart
  /// LevelPlayPrivacySettings.setCCPA(true);
  /// ```
  ///
  /// Native SDK Reference
  /// - Android: setCCPA
  /// -     iOS: setCCPA
  static Future<void> setCCPA(bool value) async {
    return _channel.invokeMethod('setCCPA', {'value': value});
  }

  /// Sets the COPPA (Children's Online Privacy Protection Act) flag.
  ///
  /// This flag indicates whether the user is a child under the age of 13
  /// (or under 16 in some regions). This will apply COPPA settings to all
  /// supported network adapters.
  ///
  /// [value] true if the user is a child and COPPA compliance is required,
  /// false otherwise.
  ///
  /// Example:
  /// ```dart
  /// LevelPlayPrivacySettings.setCOPPA(true);
  /// ```
  ///
  /// Native SDK Reference
  /// - Android: setCOPPA
  /// -     iOS: setCOPPA
  static Future<void> setCOPPA(bool value) async {
    return _channel.invokeMethod('setCOPPA', {'value': value});
  }
}
