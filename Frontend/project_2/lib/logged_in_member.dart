import 'package:project_2/models/family_member.dart';

class LoggedInMember {
  static final LoggedInMember member = LoggedInMember._internal();

  factory LoggedInMember(){
    return member;
  }

  LoggedInMember._internal();

  FamilyMember? logginInMember;
  int bottomNavIdx = 0;
}