/// Represents the configuration settings for LevelPlay.
class LevelPlayConfiguration {
  final bool isAdQualityEnabled;
  final String? ab;

  LevelPlayConfiguration({required this.isAdQualityEnabled, this.ab});

  Map<String, dynamic> toMap() {
    return {
      'isAdQualityEnabled': isAdQualityEnabled,
      'ab': ab,
    };
  }

  factory LevelPlayConfiguration.fromMap(dynamic args) {
    return LevelPlayConfiguration(
      isAdQualityEnabled: args['isAdQualityEnabled'] as bool,
      ab: args['ab'] as String?,
    );
  }

  @override
  String toString() {
    return 'LevelPlayConfiguration{'
        'isAdQualityEnabled=$isAdQualityEnabled, '
        'ab=$ab'
        '}';
  }

  /// Equality overrides
  @override
  bool operator ==(other) {
    return (other is LevelPlayConfiguration) &&
        other.isAdQualityEnabled == isAdQualityEnabled &&
        other.ab == ab;
  }

  @override
  int get hashCode =>
      isAdQualityEnabled.hashCode ^ ab.hashCode;
}
