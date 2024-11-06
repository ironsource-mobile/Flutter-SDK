/// Represents an error related to the LevelPlay ad operations.
class LevelPlayAdError {
  final String errorMessage;
  final int errorCode;
  final String? adUnitId;

  LevelPlayAdError({required this.errorMessage, required this.errorCode, required this.adUnitId});

  Map<String, dynamic> toMap() {
    return {
      'errorMessage': errorMessage,
      'errorCode': errorCode,
      'adUnitId': adUnitId,
    };
  }

  factory LevelPlayAdError.fromMap(dynamic args) {
    return LevelPlayAdError(
      errorMessage: args['errorMessage'] as String,
      errorCode: args['errorCode'] as int,
      adUnitId: args['adUnitId'] as String?,
    );
  }

  @override
  String toString() {
    return 'LevelPlayAdError{'
        'adUnitId=$adUnitId'
        ', errorCode=$errorCode'
        ', errorMessage=$errorMessage'
        '}';
  }
}