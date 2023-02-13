class Disease {
  int? id;
  String? description;
  String? author;
  String? indication;
  String? followup;
  String? example;
  String? bibliography;
  String? observation;
  String? createdAt;
  String? updatedAt;
  String? status;
  String? generalMeasures;
  Treatment? treatment;

  Disease(
      {this.id,
      this.description,
      this.author,
      this.indication,
      this.followup,
      this.example,
      this.bibliography,
      this.observation,
      this.createdAt,
      this.updatedAt,
      this.status,
      this.generalMeasures,
      this.treatment});

  Disease.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    author = json['author'];
    indication = json['indication'];
    followup = json['followup'];
    example = json['example'];
    bibliography = json['bibliography'];
    observation = json['observation'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    generalMeasures = json['general_measures'];
    treatment = json['treatment'] != null
        ? Treatment.fromJson(json['treatment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['author'] = author;
    data['indication'] = indication;
    data['followup'] = followup;
    data['example'] = example;
    data['bibliography'] = bibliography;
    data['observation'] = observation;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['status'] = status;
    data['general_measures'] = generalMeasures;
    if (treatment != null) {
      data['treatment'] = treatment!.toJson();
    }
    return data;
  }
}

class Treatment {
  List<Conditions>? conditions;
  String? initialEvaluation;

  Treatment({this.conditions, this.initialEvaluation});

  Treatment.fromJson(Map<String, dynamic> json) {
    if (json['conditions'] != null) {
      conditions = <Conditions>[];
      json['conditions'].forEach((v) {
        conditions!.add(Conditions.fromJson(v));
      });
    }
    initialEvaluation = json['initial_evaluation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (conditions != null) {
      data['conditions'] = conditions!.map((v) => v.toJson()).toList();
    }
    data['initial_evaluation'] = initialEvaluation;
    return data;
  }
}

class Conditions {
  int? id;
  String? condition;
  String? firstline;
  String? thirdline;
  String? secondline;

  Conditions(
      {this.id,
      this.condition,
      this.firstline,
      this.thirdline,
      this.secondline});

  Conditions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    condition = json['condition'];
    firstline = json['firstline'];
    thirdline = json['thirdline'];
    secondline = json['secondline'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['condition'] = condition;
    data['firstline'] = firstline;
    data['thirdline'] = thirdline;
    data['secondline'] = secondline;
    return data;
  }
}
