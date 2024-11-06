class LevelPlayInitError {
  final int errorCode;
  final String errorMessage;

  LevelPlayInitError(
      {required this.errorCode,
      required this.errorMessage});

  Map<String, dynamic> toMap() {
    return {
      'errorCode': errorCode,
      'errorMessage': errorMessage,
    };
  }

  factory LevelPlayInitError.fromMap(dynamic args) {
    return LevelPlayInitError(
      errorCode: args['errorCode'] as int,
      errorMessage: args['errorMessage'] as String,
    );
  }

  @override
  String toString() {
    return 'LevelPlayInitError{'
        'errorCode=$errorCode'
        ', errorMessage=$errorMessage'
        '}';
  }

  @override
  bool operator ==(other) {
    return (other is LevelPlayInitError) &&
        other.errorCode == errorCode &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode =>
      errorCode.hashCode ^
      errorMessage.hashCode;
}
