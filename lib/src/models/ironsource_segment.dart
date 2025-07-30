/// Interface for "female" & "male" string values
@Deprecated("This class will be removed in Flutter 4.0.0 version.")
enum IronSourceUserGender { Female, Male }

/// Segment
/// - Default values are all null except custom params 
/// and only non null values will be passed to native segments.
/// - No restriction other than basic types,
/// validations happen on the native level except for the Gender type.
@Deprecated("This class will be removed in Flutter 4.0.0 version.")
class IronSourceSegment {
  // initial values
  String? segmentName;
  int? age;
  IronSourceUserGender? gender;
  int? level;
  bool? isPaying;
  int? userCreationDateInMillis;
  double? iapTotal;
  Map<String, String> customParameters = {};

  /// Sets custom parameters for the Segment.
  /// - Successfully set a custom param: returns true
  /// - Already has 5 custom params or the [key] is one of the default segment params: returns false
  bool setCustom({required String key, required String value}) {
    if (customParameters.length == 5) {
      return false;
    }
    if (['segmentName', 'age', 'gender', 'level', 'isPlaying', 'userCreationDate', 'iapTotal'].contains(key)) {
      return false;
    }
    customParameters[key] = value;
    return true;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {...customParameters};
    if (segmentName != null) map['segmentName'] = segmentName;
    if (age != null) map['age'] = age;
    if (gender != null) map['gender'] = gender!.name.toLowerCase();
    if (level != null) map['level'] = level;
    if (isPaying != null) map['isPaying'] = isPaying;
    if (userCreationDateInMillis != null) map['userCreationDate'] = userCreationDateInMillis;
    if (iapTotal != null) map['iapTotal'] = iapTotal;
    return map;
  }
}
