import 'dart:convert';

FamilyMember familyMemberFromJson(String str) => FamilyMember.fromJson(json.decode(str));

String familyMemberToJson(FamilyMember data) => json.encode(data.toJson());

class FamilyMember {
    int familyMemberId;
    String familyMemberName;
    String familyMemberSurname;
    String familyMemberEmail;
    String familyMemberPassword;
    int familyMemberRole;
    String familyGroupId;

    FamilyMember({
        required this.familyMemberId,
        required this.familyMemberName,
        required this.familyMemberSurname,
        required this.familyMemberEmail,
        required this.familyMemberPassword,
        required this.familyMemberRole,
        required this.familyGroupId,
    });

    factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
        familyMemberId: json["familyMemberId"],
        familyMemberName: json["familyMemberName"],
        familyMemberSurname: json["familyMemberSurname"],
        familyMemberEmail: json["familyMemberEmail"],
        familyMemberPassword: json["familyMemberPassword"],
        familyMemberRole: json["familyMemberRole"],
        familyGroupId: json["familyGroupId"],
    );

    Map<String, dynamic> toJson() => {
        "familyMemberId": familyMemberId,
        "familyMemberName": familyMemberName,
        "familyMemberSurname": familyMemberSurname,
        "familyMemberEmail": familyMemberEmail,
        "familyMemberPassword": familyMemberPassword,
        "familyMemberRole": familyMemberRole,
        "familyGroupId": familyGroupId,
    };
}
