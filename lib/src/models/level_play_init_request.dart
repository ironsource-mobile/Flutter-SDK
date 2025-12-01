/// Represents a request for init, defining its appKey and userId.
class LevelPlayInitRequest {
  final String appKey;
  final String? userId;

  LevelPlayInitRequest({required this.appKey, this.userId = ''});

  Map<String, dynamic> toMap() {
    return {
      'appKey': appKey,
      'userId': userId,
    };
  }

  static LevelPlayInitRequestBuilder builder(String appKey) {
    return LevelPlayInitRequestBuilder(appKey: appKey);
  }

  @override
  String toString() {
    return 'LevelPlayInitRequest{'
        'appKey=$appKey, '
        'userId=$userId'
        '}';
  }
}

class LevelPlayInitRequestBuilder {
  String appKey;
  String userId = '';

  LevelPlayInitRequestBuilder({required this.appKey});

  LevelPlayInitRequestBuilder withUserId(String userId) {
    this.userId = userId;
    return this;
  }

  LevelPlayInitRequest build() {
    return LevelPlayInitRequest(appKey: appKey, userId: userId);
  }
}