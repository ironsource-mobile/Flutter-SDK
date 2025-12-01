/// A wrapper class for ironSource SDK Errors.
/// - ErrorCodes: https://developers.ironsrc.com/ironsource-mobile/android/advanced-settings/#step-4
class IronSourceError {
  final int errorCode;
  final String? message;

  IronSourceError({required this.errorCode, this.message});

  factory IronSourceError.fromMap(dynamic args) {
    return IronSourceError(
      errorCode: args['errorCode'] as int,
      message: args['message'] as String?,
    );
  }

  @override
  String toString() {
    return 'errorCode: $errorCode, message:$message';
  }

  /// Equality overrides
  @override
  bool operator ==(other) {
    return (other is IronSourceError) && other.errorCode == errorCode && other.message == message;
  }

  @override
  int get hashCode => errorCode.hashCode ^ message.hashCode;
}
