final class BMIInput {

  BMIInput({this.gender, this.birthdate, this.weight, this.length});

  BMIInput.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    birthdate = json['birthdate'];
    weight = json['weight'].toDouble();
    length = json['length'].toDouble();
  }
  String? gender;
  String? birthdate;
  double? weight;
  double? length;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['gender'] = gender;
    data['birthdate'] = birthdate;
    data['weight'] = weight;
    data['length'] = length;
    return data;
  }
}

final class BMIOutput {

  BMIOutput({this.bmi, this.percentile, this.result});

  BMIOutput.fromJson(Map<String, dynamic> json) {
    bmi = json['bmi'].toDouble();
    percentile = json['percentile'].toDouble();
    result = json['result'];
  }
  double? bmi;
  double? percentile;
  String? result;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['bmi'] = bmi;
    data['percentile'] = percentile;
    data['result'] = result;
    return data;
  }
}

final class PercentileInput {

  PercentileInput({this.gender, this.birthdate, this.value});

  PercentileInput.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    birthdate = json['birthdate'];
    value = json['value'].toDouble();
  }
  String? gender;
  String? birthdate;
  double? value;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['gender'] = gender;
    data['birthdate'] = birthdate;
    data['value'] = value;
    return data;
  }
}

final class PercentileOutput {

  PercentileOutput({this.percentile, this.description});

  PercentileOutput.fromJson(Map<String, dynamic> json) {
    percentile = json['percentile'].toDouble();
    description = json['description'];
  }
  double? percentile;
  String? description;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['percentile'] = percentile;
    data['description'] = description;
    return data;
  }
}
