/// Banner Position
@Deprecated("This class will be removed in future versions. Please use LevelPlayBannerAdView instead.")
enum IronSourceBannerPosition {
  Top,
  Center,
  Bottom,
}

extension ParseToInt on IronSourceBannerPosition {
  int toInt() {
    switch (this) {
      case IronSourceBannerPosition.Top:
        return 0;
      case IronSourceBannerPosition.Center:
        return 1;
      case IronSourceBannerPosition.Bottom:
        return 2;
    }
  }
}
