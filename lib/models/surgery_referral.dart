class SurgeryReferral {
  String? scope;
  List<String>? referral;
  List<String>? observations;

  SurgeryReferral({this.scope, this.referral, this.observations});

  SurgeryReferral.fromJson(Map<String, dynamic> json) {
    scope = json['scope'];
    referral = json['referral'].cast<String>();
    observations = json['observations'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['scope'] = scope;
    data['referral'] = referral;
    data['observations'] = observations;
    return data;
  }
}
