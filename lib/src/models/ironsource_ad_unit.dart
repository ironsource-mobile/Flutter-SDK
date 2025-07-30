/// Ad Unit
@Deprecated("This class will be removed in Flutter 4.0.0 version.")
enum IronSourceAdUnit {
  RewardedVideo,
  Interstitial,
  Banner,
  NativeAd
}

extension ParseToString on IronSourceAdUnit {
  String parse() {
    switch (this) {
      case IronSourceAdUnit.RewardedVideo:
        return "REWARDED_VIDEO";
      case IronSourceAdUnit.Interstitial:
        return "INTERSTITIAL";
      case IronSourceAdUnit.Banner:
        return "BANNER";
      case IronSourceAdUnit.NativeAd:
        return "NATIVE_AD";
    }
  }
}
