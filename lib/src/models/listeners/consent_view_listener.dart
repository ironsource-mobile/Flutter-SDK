import '../ironsource_error.dart';

/// iOS Consent View
@Deprecated("This class will be removed in Flutter 4.0.0 version.")
abstract class IronSourceConsentViewListener {
  /// Reference
  /// - iOS: consentViewDidLoadSuccess
  @Deprecated("This class will be removed in Flutter 4.0.0 version.")
  void consentViewDidLoadSuccess(String consentViewType);

  /// Reference
  /// - iOS: consentViewDidFailToLoadWithError
  @Deprecated("This class will be removed in Flutter 4.0.0 version.")
  void consentViewDidFailToLoad(IronSourceConsentViewError error);

  /// Reference
  /// - iOS: consentViewDidShowSuccess
  @Deprecated("This class will be removed in Flutter 4.0.0 version.")
  void consentViewDidShowSuccess(String consentViewType);

  /// Reference
  /// - iOS: consentViewDidFailToShowWithError
  @Deprecated("This class will be removed in Flutter 4.0.0 version.")
  void consentViewDidFailToShow(IronSourceConsentViewError error);

  /// Reference
  /// - iOS: consentViewDidAccept
  @Deprecated("This class will be removed in Flutter 4.0.0 version.")
  void consentViewDidAccept(String consentViewType);
}
