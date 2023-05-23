import '../ironsource_error.dart';
import '../ironsource_offerwall_credit_info.dart';
import '../ironsource_ow_credit_info.dart';

abstract class IronSourceOfferwallListener {
  /// Invoked when there is a change in the Offerwall availability status.
  /// - [isAvailable] reflects the availability of Offerwall.
  /// - You can show the Offerwall by calling [showOfferwall] when [isAvailable] is true.
  /// - [isAvailable] would be false when Offerwall is not available.
  ///
  /// Native SDK Reference
  /// - Android: onOfferwallAvailabilityChanged
  /// -     iOS: offerwallHasChangedAvailability
  void onOfferwallAvailabilityChanged(bool isAvailable);

  /// Invoked when the Offerwall successfully loads for the user,
  /// after calling the [showOfferwall] function.
  ///
  /// Native SDK Reference
  /// - Android: onOfferwallOpened
  /// -     iOS: offerwallDidShow
  void onOfferwallOpened();

  /// Invoked when [showOfferWall] was called and the OfferWall failed to load.
  /// - [error] represents the reason for the [showOfferwall] failure.
  ///
  /// Native SDK Reference
  /// - Android: onOfferwallShowFailed
  /// -     iOS: offerwallDidFailToShowWithError
  void onOfferwallShowFailed(IronSourceError error);

  /// Invoked each time the user completes an offer or as a result of [getOfferwallCredits].
  /// - Award the user with the credit amount based on the [creditInfo].
  ///
  /// [creditInfo] is an instance of [IronSourceOWCreditInfo] with following fields:
  /// - [credits] represents the number of credits the user has earned.
  /// - [totalCredits] is the total number of credits ever earned by the user.
  /// - [totalCreditsFlag] becomes true in cases where we are not able to provide the exact amount
  ///  of credits since the last event (specifically after the user clears the app data).
  ///  In such case, [credits] will be equal to [totalCredits].
  ///
  /// Native SDK Reference
  /// - Android: onOfferwallAdCredited
  /// -     iOS: didReceiveOfferwallCredits
  void onOfferwallAdCredited(IronSourceOfferWallCreditInfo creditInfo);

  /// Invoked when [getOfferWallCredits] fails to retrieve the user's credit balance info.
  /// - [error] represents the reason of [getOfferwallCredits] failure.
  ///
  /// Native SDK Reference
  /// - Android: onGetOfferwallCreditsFailed
  /// -     iOS: didFailToReceiveOfferwallCreditsWithError
  void onGetOfferwallCreditsFailed(IronSourceError error);

  /// Invoked when the user is about to return to the application after closing the Offerwall.
  ///
  /// Native SDK Reference
  /// - Android: onOfferwallClosed
  /// -     iOS: offerwallDidClose
  void onOfferwallClosed();
}
