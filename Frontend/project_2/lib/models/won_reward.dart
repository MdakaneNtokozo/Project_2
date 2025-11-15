import 'dart:convert';

WonReward wonRewardFromJson(String str) => WonReward.fromJson(json.decode(str));

String wonRewardToJson(WonReward data) => json.encode(data.toJson());

class WonReward {
    int rewardId;
    int familyMemberId;
    DateTime dateRewarded;

    WonReward({
        required this.rewardId,
        required this.familyMemberId,
        required this.dateRewarded,
    });

    factory WonReward.fromJson(Map<String, dynamic> json) => WonReward(
        rewardId: json["rewardId"],
        familyMemberId: json["familyMemberId"],
        dateRewarded: DateTime.parse(json["dateRewarded"]),
    );

    Map<String, dynamic> toJson() => {
        "rewardId": rewardId,
        "familyMemberId": familyMemberId,
        "dateRewarded": dateRewarded.toIso8601String(),
    };
}
