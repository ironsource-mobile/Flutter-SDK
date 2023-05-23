/// Offerwall credit info wrapper
import 'ironsource_ow_credit_info.dart';

class IronSourceOfferWallCreditInfo implements IronSourceOWCreditInfo {
  final int credits;
  final int totalCredits;

  /// In some cases, we won’t be able to provide the exact amount of credits earned
  ///   since the previous OW credited event (specifically when the user clears the app data).
  /// In such cases 'credits' will also represent 'totalCredits', and this will be 'true'.
  final bool totalCreditsFlag;

  IronSourceOfferWallCreditInfo({
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
    return (other is IronSourceOfferWallCreditInfo) &&
        other.credits == credits &&
        other.totalCredits == totalCredits &&
        other.totalCreditsFlag == totalCreditsFlag;
  }

  @override
  int get hashCode =>
      credits.hashCode ^ totalCredits.hashCode ^ totalCreditsFlag.hashCode;
}
