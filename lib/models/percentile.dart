class BMIInput {
  String? gender;
  String? birthdate;
  double? weight;
  double? length;

  BMIInput({this.gender, this.birthdate, this.weight, this.length});

  BMIInput.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    birthdate = json['birthdate'];
    weight = json['weight'];
    length = json['length'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gender'] = gender;
    data['birthdate'] = birthdate;
    data['weight'] = weight;
    data['length'] = length;
    return data;
  }
}

class BMIOutput {
  double? bmi;
  double? percentile;
  String? result;

  BMIOutput({this.bmi, this.percentile, this.result});

  BMIOutput.fromJson(Map<String, dynamic> json) {
    bmi = json['bmi'];
    percentile = json['percentile'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bmi'] = bmi;
    data['percentile'] = percentile;
    data['result'] = result;
    return data;
  }
}

class PercentileInput {
  String? gender;
  String? birthdate;
  double? value;

  PercentileInput({this.gender, this.birthdate, this.value});

  PercentileInput.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    birthdate = json['birthdate'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gender'] = gender;
    data['birthdate'] = birthdate;
    data['value'] = value;
    return data;
  }
}

class PercentileOutput {
  double? percentile;
  String? description;

  PercentileOutput({this.percentile, this.description});

  PercentileOutput.fromJson(Map<String, dynamic> json) {
    percentile = json['percentile'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['percentile'] = percentile;
    data['description'] = description;
    return data;
  }
}
