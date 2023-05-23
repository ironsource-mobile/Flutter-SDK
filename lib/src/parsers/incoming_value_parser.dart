import '../models/models.dart';
import '../ironsource_constants.dart';

typedef ValueGetter<O, T> = T Function(O obj);

/// To parse values passed from the native to Flutter side via [MethodChannel]
class IncomingValueParser {
  /// [arguments] to [bool]
  /// For [IronConstKey.IS_AVAILABLE]
  static bool getAvailabilityBool(dynamic arguments) {
    return getValueForKey(IronConstKey.IS_AVAILABLE, arguments);
  }

  /// [arguments] to [IronSourceRVPlacement]
  /// - Throws [ArgumentError] if [arguments] is null.
  static IronSourceRewardedVideoPlacement getRewardedVideoPlacement(
      dynamic arguments) {
    final placementName =
        getValueForKey<String>(IronConstKey.PLACEMENT_NAME, arguments);
    final rewardName =
        getValueForKey<String>(IronConstKey.REWARD_NAME, arguments);
    final rewardAmount =
        getValueForKey<int>(IronConstKey.REWARD_AMOUNT, arguments);
    return IronSourceRewardedVideoPlacement(
        placementName: placementName,
        rewardName: rewardName,
        rewardAmount: rewardAmount);
  }

  /// [arguments] to [IronSourceError]
  /// - [arguments] should not be null as [IronSourceError] object should be passed.
  /// - [errorCode] is int, so it cannot be null.
  static IronSourceError getIronSourceError(dynamic arguments) {
    final errorCode = getValueForKey<int>(IronConstKey.ERROR_CODE, arguments);
    final message = getValueForKey<String?>(IronConstKey.MESSAGE, arguments);
    return IronSourceError(errorCode: errorCode, message: message);
  }

  /// [arguments] to [IronSourceOWCreditInfo]
  static IronSourceOfferWallCreditInfo getOfferWallCreditInfo(
      dynamic arguments) {
    final credits = getValueForKey<int>(IronConstKey.CREDITS, arguments);
    final totalCredits =
        getValueForKey<int>(IronConstKey.TOTAL_CREDITS, arguments);
    final totalCreditsFlag =
        getValueForKey<bool>(IronConstKey.TOTAL_CREDITS_FLAG, arguments);
    return IronSourceOfferWallCreditInfo(
        credits: credits,
        totalCredits: totalCredits,
        totalCreditsFlag: totalCreditsFlag);
  }

  /// [arguments] to [IronSourceAdInfo]
  static IronSourceAdInfo getAdInfo(dynamic arguments) {
    final String? auctionId =
        getValueForKey<String?>(IronConstKey.AUCTION_ID, arguments);
    final String? adUnit =
        getValueForKey<String?>(IronConstKey.AD_UNIT, arguments);
    final String? adNetwork =
        getValueForKey<String?>(IronConstKey.AD_NETWORK, arguments);
    final String? ab = getValueForKey<String?>(IronConstKey.AB, arguments);
    final String? country =
        getValueForKey<String?>(IronConstKey.COUNTRY, arguments);
    final String? instanceId =
        getValueForKey<String?>(IronConstKey.INSTANCE_ID, arguments);
    final String? instanceName =
        getValueForKey<String?>(IronConstKey.INSTANCE_NAME, arguments);
    final String? segmentName =
        getValueForKey<String?>(IronConstKey.SEGMENT_NAME, arguments);
    final double? revenue =
        getValueForKey<double?>(IronConstKey.REVENUE, arguments);
    final String? precision =
        getValueForKey<String?>(IronConstKey.PRECISION, arguments);
    final String? encryptedCPM =
        getValueForKey<String?>(IronConstKey.ENCRYPTED_CPM, arguments);

    return IronSourceAdInfo(
        auctionId: auctionId,
        adUnit: adUnit,
        adNetwork: adNetwork,
        ab: ab,
        country: country,
        instanceId: instanceId,
        instanceName: instanceName,
        segmentName: segmentName,
        revenue: revenue,
        precision: precision,
        encryptedCPM: encryptedCPM);
  }

  // For [IronSourceConsentViewListener] ///////////////////////////////////////////////////////////

  /// [arguments] to [String]
  static String getConsentViewTypeString(dynamic arguments) {
    return getValueForKey<String?>(IronConstKey.CONSENT_VIEW_TYPE, arguments) ??
        "";
  }

  /// [arguments] to [IronSourceConsentViewError]
  static IronSourceConsentViewError getConsentViewError(dynamic arguments) {
    final error = getIronSourceError(arguments);
    final consentViewType = getConsentViewTypeString(arguments);
    return IronSourceConsentViewError(
        errorCode: error.errorCode,
        message: error.message,
        consentViewType: consentViewType);
  }

  /// [arguments] to [IronSourceImpressionData] if not null
  /// - To be deprecated soon
  static IronSourceImpressionData? getImpressionData(dynamic arguments) {
    if (arguments == null) {
      return null;
    }
    final String? auctionId =
        getValueForKey<String?>(IronConstKey.AUCTION_ID, arguments);
    final String? adUnit =
        getValueForKey<String?>(IronConstKey.AD_UNIT, arguments);
    final String? country =
        getValueForKey<String?>(IronConstKey.COUNTRY, arguments);
    final String? ab = getValueForKey<String?>(IronConstKey.AB, arguments);
    final String? segmentName =
        getValueForKey<String?>(IronConstKey.SEGMENT_NAME, arguments);
    final String? placement =
        getValueForKey<String?>(IronConstKey.PLACEMENT, arguments);
    final String? adNetwork =
        getValueForKey<String?>(IronConstKey.AD_NETWORK, arguments);
    final String? instanceName =
        getValueForKey<String?>(IronConstKey.INSTANCE_NAME, arguments);
    final String? instanceId =
        getValueForKey<String?>(IronConstKey.INSTANCE_ID, arguments);
    final double? revenue =
        getValueForKey<double?>(IronConstKey.REVENUE, arguments);
    final String? precision =
        getValueForKey<String?>(IronConstKey.PRECISION, arguments);
    final double? lifetimeRevenue =
        getValueForKey<double?>(IronConstKey.LIFETIME_REVENUE, arguments);
    final String? encryptedCPM =
        getValueForKey<String?>(IronConstKey.ENCRYPTED_CPM, arguments);
    return IronSourceImpressionData(
      auctionId: auctionId,
      adUnit: adUnit,
      country: country,
      ab: ab,
      segmentName: segmentName,
      placement: placement,
      adNetwork: adNetwork,
      instanceName: instanceName,
      instanceId: instanceId,
      revenue: revenue,
      precision: precision,
      lifetimeRevenue: lifetimeRevenue,
      encryptedCPM: encryptedCPM,
    );
  }

  // Utils /////////////////////////////////////////////////////////////////////////////////////////

  /// Get value from [arguments] for the [key]
  /// - Throws [ArgumentError].
  static T getValueForKey<T>(String key, dynamic arguments) {
    if (arguments == null) {
      throw ArgumentError('arguments is null');
    }
    if (!isNullable<T>() && arguments[key] == null) {
      throw ArgumentError('key: $key does not exist');
    }
    if (arguments[key] is! T) {
      throw ArgumentError('Value retrieved is not a type of ${T.toString()}');
    }
    return arguments[key] as T;
  }

  /// Null checker
  static bool isNullable<T>() => null is T;

  /// Returns the [ValueGetter]'s return value [T] if [obj] is not null
  static T? nullOrValue<O, T>(O? obj, ValueGetter<O, T> f) =>
      obj != null ? f(obj) : null;
}
