/// Banner Position
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
