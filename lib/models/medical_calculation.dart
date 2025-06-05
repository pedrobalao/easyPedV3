class MedicalCalculation {
  int? id;
  String? description;
  String? resultUnitId;
  String? observation;
  String? resultType;
  int? precision;
  List<Variable>? variables;

  MedicalCalculation(
      {this.id,
      this.description,
      this.resultUnitId,
      this.observation,
      this.resultType,
      this.precision,
      this.variables});

  MedicalCalculation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    resultUnitId = json['resultUnitId'];
    observation = json['observation'];
    resultType = json['resultType'];
    precision = json['precision'];
    if (json['variables'] != null) {
      variables = <Variable>[];
      json['variables'].forEach((v) {
        variables!.add(Variable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['resultUnitId'] = resultUnitId;
    data['observation'] = observation;
    data['resultType'] = resultType;
    data['precision'] = precision;
    if (variables != null) {
      data['variables'] = variables!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Variable {
  int? id;
  String? variableId;
  int? medicalCalculationId;
  int? optional;
  String? description;
  String? idUnit;
  String? type;
  List<String>? values;

  Variable(
      {this.id,
      this.variableId,
      this.medicalCalculationId,
      this.optional,
      this.description,
      this.idUnit,
      this.type,
      this.values});

  Variable.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    variableId = json['variableId'];
    medicalCalculationId = json['medicalCalculationId'];
    optional = json['optional'];
    description = json['description'];
    idUnit = json['idUnit'];
    type = json['type'];
    values = json.containsKey('values')
        ? (json['values'] as List).map((item) => item as String).toList()
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['variableId'] = variableId;
    data['medicalCalculationId'] = medicalCalculationId;
    data['optional'] = optional;
    data['description'] = description;
    data['idUnit'] = idUnit;
    data['type'] = type;
    data['values'] = values;
    return data;
  }
}

class CalculationOutput {
  int? id;
  String? description;
  String? resultDescription;
  String? resultIdUnit;
  String? result;

  CalculationOutput(
      {this.id,
      this.description,
      this.resultDescription,
      this.resultIdUnit,
      this.result});

  CalculationOutput.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    resultDescription = json['resultDescription'];
    resultIdUnit = json['resultIdUnit'];
    final rawResult = json['result'];
    result = rawResult?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['resultDescription'] = resultDescription;
    data['resultIdUnit'] = resultIdUnit;
    data['result'] = result;
    return data;
  }
}
