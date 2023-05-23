import 'package:ironsource_mediation/ironsource_mediation.dart';

/// Offerwall credit info wrapper
@Deprecated(
    "This class has been deprecated as of SDK 7.3.0. Please use IronSourceOfferWallCreditInfo instead.")
class IronSourceOWCreditInfo {
  final int credits;
  final int totalCredits;

  /// In some cases, we won’t be able to provide the exact amount of credits earned
  ///   since the previous OW credited event (specifically when the user clears the app data).
  /// In such cases 'credits' will also represent 'totalCredits', and this will be 'true'.
  final bool totalCreditsFlag;

  IronSourceOWCreditInfo({
    required this.credits,
    required this.totalCredits,
    required this.totalCreditsFlag,
  });

  @override
  String toString() {
    return 'IronSourceOfferWallCreditInfo{'
        'credits: $credits,'
        ' totalCredits:$totalCredits,'
        ' totalCreditsFlag:$totalCreditsFlag'
        '}';
  }

  /// Equality overrides
  @override
  bool operator ==(other) {
    return (other is IronSourceOWCreditInfo) &&
        other.credits == credits &&
        other.totalCredits == totalCredits &&
        other.totalCreditsFlag == totalCreditsFlag;
  }

  @override
  int get hashCode =>
      credits.hashCode ^ totalCredits.hashCode ^ totalCreditsFlag.hashCode;
}
