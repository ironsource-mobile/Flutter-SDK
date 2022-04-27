/// A wrapper class for ironSource SDK Errors.
/// - ErrorCodes: https://developers.ironsrc.com/ironsource-mobile/android/advanced-settings/#step-4
class IronSourceError {
  final int errorCode;
  final String? message;

  IronSourceError({required this.errorCode, this.message});

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

class IronSourceConsentViewError extends IronSourceError {
  final String consentViewType;
  IronSourceConsentViewError({errorCode, message, required this.consentViewType})
      : super(errorCode: errorCode, message: message);

  @override
  String toString() {
    return "${super.toString()}, consentViewType: $consentViewType";
  }

  /// Equality overrides
  @override
  bool operator ==(other) {
    return (other is IronSourceConsentViewError) &&
        other.errorCode == errorCode &&
        other.message == message &&
        other.consentViewType == consentViewType;
  }

  @override
  int get hashCode => super.hashCode ^ consentViewType.hashCode;
}
