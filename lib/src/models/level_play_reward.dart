/// Represents an reward for watching a rewarded video.
class LevelPlayReward {
  final String name;
  final int amount;

  LevelPlayReward({required this.name, required this.amount});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'amount': amount
    };
  }

  factory LevelPlayReward.fromMap(dynamic args) {
    return LevelPlayReward(
      name: args['name'] as String,
      amount: args['amount'] as int
    );
  }

  @override
  String toString() {
    return 'LevelPlayReward{'
        'name=$name'
        ', amount=$amount'
        '}';
  }
}