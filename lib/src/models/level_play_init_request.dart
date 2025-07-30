import './ad_format.dart';

/// Represents a request for init, defining its appKey, userId and legacyAdFormats.
class LevelPlayInitRequest {
  final String appKey;
  final String? userId;
  @Deprecated("This variable will be removed in 4.0.0 version.")
  final List<AdFormat> legacyAdFormats;

  LevelPlayInitRequest({required this.appKey, this.userId = '', required this.legacyAdFormats});

  Map<String, dynamic> toMap() {
    return {
      'appKey': appKey,
      'userId': userId,
      'adFormats': legacyAdFormats.map((unit) => unit.value).toList()
    };
  }

  static LevelPlayInitRequestBuilder builder(String appKey) {
    return LevelPlayInitRequestBuilder(appKey: appKey);
  }

  @override
  String toString() {
    return 'LevelPlayInitRequest{'
        'appKey=$appKey, '
        'userId=$userId, '
        'legacyAdFormats=$legacyAdFormats'
        '}';
  }
}

class LevelPlayInitRequestBuilder {
  String appKey;
  String userId = '';
  List<AdFormat> legacyAdFormats = [];

  LevelPlayInitRequestBuilder({required this.appKey});

  LevelPlayInitRequestBuilder withUserId(String userId) {
    this.userId = userId;
    return this;
  }

  @Deprecated("This method will be removed in 4.0.0 version.")
  LevelPlayInitRequestBuilder withLegacyAdFormats(List<AdFormat> legacyAdFormats) {
    this.legacyAdFormats = legacyAdFormats;
    return this;
  }

  LevelPlayInitRequest build() {
    return LevelPlayInitRequest(appKey: appKey, userId: userId, legacyAdFormats: legacyAdFormats);
  }
}