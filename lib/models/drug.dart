class Drug {
  int? id;
  String? name;
  String? conterIndications;
  String? secondaryEffects;
  String? comercialBrands;
  String? obs;
  String? presentation;
  String? subcategoryDescription;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Indications>? indications;
  List<Variables>? variables;
  List<Calculations>? calculations;
  bool? isFavourite;

  Drug(
      {this.id,
      this.name,
      this.conterIndications,
      this.secondaryEffects,
      this.comercialBrands,
      this.obs,
      this.presentation,
      this.subcategoryDescription,
      this.createdAt,
      this.updatedAt,
      this.indications,
      this.variables,
      this.calculations,
      this.isFavourite = false});

  Drug.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    conterIndications = json['conterIndications'];
    secondaryEffects = json['secondaryEffects'];
    comercialBrands = json['comercialBrands'];
    obs = json['obs'];
    presentation = json['presentation'];
    subcategoryDescription = json['subcategoryDescription'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['indications'] != null) {
      indications = <Indications>[];
      json['indications'].forEach((v) {
        indications!.add(Indications.fromJson(v));
      });
    }
    if (json['variables'] != null) {
      variables = <Variables>[];
      json['variables'].forEach((v) {
        variables!.add(Variables.fromJson(v));
      });
    }
    if (json['calculations'] != null) {
      calculations = <Calculations>[];
      json['calculations'].forEach((v) {
        calculations!.add(Calculations.fromJson(v));
      });
    }
    isFavourite = json['isFavourite'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['conterIndications'] = conterIndications;
    data['secondaryEffects'] = secondaryEffects;
    data['comercialBrands'] = comercialBrands;
    data['obs'] = obs;
    data['presentation'] = presentation;
    data['subcategoryDescription'] = subcategoryDescription;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (indications != null) {
      data['indications'] = indications!.map((v) => v.toJson()).toList();
    }
    if (variables != null) {
      data['variables'] = variables!.map((v) => v.toJson()).toList();
    }
    if (calculations != null) {
      data['calculations'] = calculations!.map((v) => v.toJson()).toList();
    }
    data['isFavourite'] = isFavourite;
    return data;
  }
}

class Indications {
  int? id;
  int? drugId;
  String? indicationText;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Doses>? doses;

  Indications(
      {this.id,
      this.drugId,
      this.indicationText,
      this.createdAt,
      this.updatedAt,
      this.doses});

  Indications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    drugId = json['drugId'];
    indicationText = json['indicationText'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    if (json['doses'] != null) {
      doses = <Doses>[];
      json['doses'].forEach((v) {
        doses!.add(Doses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['drugId'] = drugId;
    data['indicationText'] = indicationText;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (doses != null) {
      data['doses'] = doses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Doses {
  int? id;
  int? indicationId;
  String? idVia;
  String? pediatricDose;
  String? idUnityPediatricDose;
  String? adultDose;
  String? idUnityAdultDose;
  String? takesPerDay;
  String? maxDosePerDay;
  String? idUnityMaxDosePerDay;
  String? obs;
  DateTime? createdAt;
  DateTime? updatedAt;

  Doses(
      {this.id,
      this.indicationId,
      this.idVia,
      this.pediatricDose,
      this.idUnityPediatricDose,
      this.adultDose,
      this.idUnityAdultDose,
      this.takesPerDay,
      this.maxDosePerDay,
      this.idUnityMaxDosePerDay,
      this.obs,
      this.createdAt,
      this.updatedAt});

  Doses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    indicationId = json['indicationId'];
    idVia = json['idVia'];
    pediatricDose = json['pediatricDose'];
    idUnityPediatricDose = json['idUnityPediatricDose'];
    adultDose = json['adultDose'];
    idUnityAdultDose = json['idUnityAdultDose'];
    takesPerDay = json['takesPerDay'];
    maxDosePerDay = json['maxDosePerDay'];
    idUnityMaxDosePerDay = json['idUnityMaxDosePerDay'];
    obs = json['obs'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['indicationId'] = indicationId;
    data['idVia'] = idVia;
    data['PediatricDose'] = pediatricDose;
    data['idUnityPediatricDose'] = idUnityPediatricDose;
    data['adultDose'] = adultDose;
    data['idUnityAdultDose'] = idUnityAdultDose;
    data['takesPerDay'] = takesPerDay;
    data['maxDosePerDay'] = maxDosePerDay;
    data['idUnityMaxDosePerDay'] = idUnityMaxDosePerDay;
    data['obs'] = obs;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Variables {
  String? id;
  String? description;
  String? idUnit;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  Variables(
      {this.id,
      this.description,
      this.idUnit,
      this.type,
      this.createdAt,
      this.updatedAt});

  Variables.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    idUnit = json['idUnit'];
    type = json['type'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['idUnit'] = idUnit;
    data['type'] = type;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Calculations {
  int? id;
  int? drugId;
  String? type;
  String? function;
  String? resultDescription;
  String? resultIdUnit;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  Calculations(
      {this.id,
      this.drugId,
      this.type,
      this.function,
      this.resultDescription,
      this.resultIdUnit,
      this.description,
      this.createdAt,
      this.updatedAt});

  Calculations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    drugId = json['drugId'];
    type = json['type'];
    function = json['function'];
    resultDescription = json['resultDescription'];
    resultIdUnit = json['resultIdUnit'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['drugId'] = drugId;
    data['type'] = type;
    data['function'] = function;
    data['resultDescription'] = resultDescription;
    data['resultIdUnit'] = resultIdUnit;
    data['description'] = description;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class DoseCalculationResult {
  int? id;
  String? description;
  String? resultDescription;
  String? resultIdUnit;
  double? result;

  DoseCalculationResult(
      {this.id,
      this.description,
      this.resultDescription,
      this.resultIdUnit,
      this.result});

  DoseCalculationResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    resultDescription = json['resultDescription'];
    resultIdUnit = json['resultIdUnit'];
    result = json['result'];
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

class CalculationInput {
  String? variable;
  dynamic value;

  CalculationInput({this.variable, this.value});

  CalculationInput.fromJson(Map<String, dynamic> json) {
    variable = json['variable'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['variable'] = variable;
    data['value'] = value;
    return data;
  }
}
