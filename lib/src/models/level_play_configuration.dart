/// Represents the configuration settings for LevelPlay.
class LevelPlayConfiguration {
  final bool isAdQualityEnabled;

  LevelPlayConfiguration({required this.isAdQualityEnabled});

  Map<String, dynamic> toMap() {
    return {
      'isAdQualityEnabled': isAdQualityEnabled,
    };
  }

  factory LevelPlayConfiguration.fromMap(dynamic args) {
    return LevelPlayConfiguration(
      isAdQualityEnabled: args['isAdQualityEnabled'] as bool,
    );
  }

  @override
  String toString() {
    return 'LevelPlayConfiguration{'
        'isAdQualityEnabled=$isAdQualityEnabled'
        '}';
  }

  /// Equality overrides
  @override
  bool operator ==(other) {
    return (other is LevelPlayConfiguration) &&
        other.isAdQualityEnabled == isAdQualityEnabled;
  }

  @override
  int get hashCode =>
      isAdQualityEnabled.hashCode;
}
