/// Ad Unit
enum IronSourceAdUnit {
  RewardedVideo,
  Interstitial,
  Offerwall,
  Banner,
}

extension ParseToString on IronSourceAdUnit {
  String parse() {
    switch (this) {
      case IronSourceAdUnit.RewardedVideo:
        return "REWARDED_VIDEO";
      case IronSourceAdUnit.Interstitial:
        return "INTERSTITIAL";
      case IronSourceAdUnit.Offerwall:
        return "OFFERWALL";
      case IronSourceAdUnit.Banner:
        return "BANNER";
    }
  }
}
