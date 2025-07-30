/// LevelPlaySegment model represents a segment in LevelPlay.
class LevelPlaySegment {
  String? segmentName;
  bool? isPaying;
  int? level;
  int? userCreationDate;
  double? iapTotal;
  Map<String, String> customParameters = {};

  /// Sets custom parameters for the Segment.
  void setCustom({required String key, required String value}) {
    customParameters[key] = value;
  }

  Map<String, dynamic> toMap() {
    return {
      'segmentName': segmentName,
      'isPaying': isPaying,
      'level': level,
      'userCreationDate': userCreationDate,
      'iapTotal': iapTotal,
      'customParameters': customParameters,
    };
  }
}
