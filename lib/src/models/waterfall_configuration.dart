
/// Represents a configuration for a waterfall, defining its floor and ceiling.
class WaterfallConfiguration {
  /// Represents the lowest point of the waterfall.
  final double floor;

  /// Represents the highest point of the waterfall.
  final double ceiling;

  /// Constructor to create a WaterfallConfiguration instance with specified floor and ceiling values.
  WaterfallConfiguration({ required this.floor, required this.ceiling });

  /// Static method to obtain a builder instance for WaterfallConfiguration.
  static WaterfallConfigurationBuilder builder() {
    return WaterfallConfigurationBuilder();
  }

  /// Static method to create an empty WaterfallConfiguration instance with default floor and ceiling values.
  static WaterfallConfiguration empty() {
    return WaterfallConfiguration(floor: 0.0, ceiling: 0.0);
  }
}

/// Builder class for WaterfallConfiguration.
class WaterfallConfigurationBuilder {
  /// Represents the floor value being built by the builder.
  double _floor = 0.0;

  /// Represents the ceiling value being built by the builder.
  double _ceiling = 0.0;

  /// Method to set the floor value for the WaterfallConfiguration being built.
  /// Returns the builder instance to allow method chaining.
  WaterfallConfigurationBuilder setFloor(double floor) {
    _floor = floor;
    return this;
  }

  /// Method to set the ceiling value for the WaterfallConfiguration being built.
  /// Returns the builder instance to allow method chaining.
  WaterfallConfigurationBuilder setCeiling(double ceiling) {
    _ceiling = ceiling;
    return this;
  }

  /// Method to build the WaterfallConfiguration instance using the configured values.
  WaterfallConfiguration build() {
    return WaterfallConfiguration(
      floor: _floor,
      ceiling: _ceiling,
    );
  }
}