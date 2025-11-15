import 'dart:convert';

Reward rewardFromJson(String str) => Reward.fromJson(json.decode(str));

String rewardToJson(Reward data) => json.encode(data.toJson());

class Reward {
    int rewardId;
    String rewardName;
    String rewardDesc;
    String rewardImg;

    Reward({
        required this.rewardId,
        required this.rewardName,
        required this.rewardDesc,
        required this.rewardImg,
    });

    factory Reward.fromJson(Map<String, dynamic> json) => Reward(
        rewardId: json["rewardId"],
        rewardName: json["rewardName"],
        rewardDesc: json["rewardDesc"],
        rewardImg: json["rewardImg"],
    );

    Map<String, dynamic> toJson() => {
        "rewardId": rewardId,
        "rewardName": rewardName,
        "rewardDesc": rewardDesc,
        "rewardImg": rewardImg,
    };
}
