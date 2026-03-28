class Drug {

  Drug(
      {this.id,
      this.name,
      this.conterIndications,
      this.secondaryEffects,
      this.comercialBrands,
      this.obs,
      this.presentation,
      this.subcategoryDescription,
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

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['conterIndications'] = conterIndications;
    data['secondaryEffects'] = secondaryEffects;
    data['comercialBrands'] = comercialBrands;
    data['obs'] = obs;
    data['presentation'] = presentation;
    data['subcategoryDescription'] = subcategoryDescription;

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

  Indications({this.id, this.drugId, this.indicationText, this.doses});

  Indications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    drugId = json['drugId'];
    indicationText = json['indicationText'];

    if (json['doses'] != null) {
      doses = <Doses>[];
      json['doses'].forEach((v) {
        doses!.add(Doses.fromJson(v));
      });
    }
  }
  int? id;
  int? drugId;
  String? indicationText;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Doses>? doses;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['drugId'] = drugId;
    data['indicationText'] = indicationText;

    if (doses != null) {
      data['doses'] = doses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Doses {

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
      this.obs});

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
  }
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

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
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

    return data;
  }
}

class Variables {

  Variables({this.id, this.description, this.idUnit, this.type});

  Variables.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    idUnit = json['idUnit'];
    type = json['type'];
  }
  String? id;
  String? description;
  String? idUnit;
  String? type;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['idUnit'] = idUnit;
    data['type'] = type;

    return data;
  }
}

class Calculations {

  Calculations({
    this.id,
    this.drugId,
    this.type,
    this.function,
    this.resultDescription,
    this.resultIdUnit,
    this.description,
  });

  Calculations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    drugId = json['drugId'];
    type = json['type'];
    function = json['function'];
    resultDescription = json['resultDescription'];
    resultIdUnit = json['resultIdUnit'];
    description = json['description'];
  }
  int? id;
  int? drugId;
  String? type;
  String? function;
  String? resultDescription;
  String? resultIdUnit;
  String? description;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['drugId'] = drugId;
    data['type'] = type;
    data['function'] = function;
    data['resultDescription'] = resultDescription;
    data['resultIdUnit'] = resultIdUnit;
    data['description'] = description;

    return data;
  }
}

class DoseCalculationResult {

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
  int? id;
  String? description;
  String? resultDescription;
  String? resultIdUnit;
  num? result;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['resultDescription'] = resultDescription;
    data['resultIdUnit'] = resultIdUnit;
    data['result'] = result;
    return data;
  }
}

class CalculationInput {

  CalculationInput({this.variable, this.value});

  CalculationInput.fromJson(Map<String, dynamic> json) {
    variable = json['variable'];
    value = json['value'];
  }
  String? variable;
  dynamic value;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['variable'] = variable;
    data['value'] = value;
    return data;
  }
}

class DrugCategory {

  DrugCategory({this.id, this.description});

  DrugCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
  }
  int? id;
  String? description;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    return data;
  }
}

class DrugSubCategory {

  DrugSubCategory({this.id, this.description, this.categoryId});

  DrugSubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    categoryId = json['categoryId'];
  }
  int? id;
  String? description;
  int? categoryId;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['categoryId'] = categoryId;
    return data;
  }
}
