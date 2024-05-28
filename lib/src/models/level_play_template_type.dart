
/// Enum class and extension for native ad templates
enum LevelPlayTemplateType {
  SMALL,
  MEDIUM,
}

extension LevelPlayTemplateTypeExtension on LevelPlayTemplateType {
  String get value {
    switch (this) {
      case LevelPlayTemplateType.SMALL:
        return 'SMALL';
      case LevelPlayTemplateType.MEDIUM:
        return 'MEDIUM';
    }
  }

  static LevelPlayTemplateType fromString(String value) {
    switch (value) {
      case 'SMALL':
        return LevelPlayTemplateType.SMALL;
      case 'MEDIUM':
        return LevelPlayTemplateType.MEDIUM;
      default:
        throw ArgumentError('Invalid TemplateType string: $value');
    }
  }
}