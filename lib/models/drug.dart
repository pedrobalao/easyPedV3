// class Drug {
//   int id;
//   String name;
//   String? conterIndications;
//   String? secondaryEfects;
//   String? comercialBrands;
//   String? obs;
//   String? presentation;
//   DateTime? createdAt;
//   DateTime? updatedAt;

//   Drug(
//       {required this.id,
//       required this.name,
//       this.conterIndications,
//       this.secondaryEfects,
//       this.comercialBrands,
//       this.obs,
//       this.presentation,
//       this.createdAt,
//       this.updatedAt});

//   Drug.fromJson(Map<String, dynamic> json)
//       : id = json['Id'],
//         name = json['Name'],
//         conterIndications = json['ConterIndications'],
//         secondaryEfects = json['SecondaryEfects'],
//         comercialBrands = json['ComercialBrands'],
//         obs = json['Obs'],
//         presentation = json['Presentation'],
//         createdAt = json['created_at'],
//         updatedAt = json['updated_at'];

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['Id'] = id;
//     data['Name'] = name;
//     data['ConterIndications'] = conterIndications;
//     data['SecondaryEfects'] = secondaryEfects;
//     data['ComercialBrands'] = comercialBrands;
//     data['Obs'] = obs;
//     data['Presentation'] = presentation;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     return data;
//   }
// }

class Drug {
  int? id;
  String? name;
  String? conterIndications;
  String? secondaryEfects;
  String? comercialBrands;
  String? obs;
  String? presentation;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Indications>? indications;
  List<Variables>? variables;
  List<Calculations>? calculations;

  Drug(
      {this.id,
      this.name,
      this.conterIndications,
      this.secondaryEfects,
      this.comercialBrands,
      this.obs,
      this.presentation,
      this.createdAt,
      this.updatedAt,
      this.indications,
      this.variables,
      this.calculations});

  Drug.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    name = json['Name'];
    conterIndications = json['ConterIndications'];
    secondaryEfects = json['SecondaryEfects'];
    comercialBrands = json['ComercialBrands'];
    obs = json['Obs'];
    presentation = json['Presentation'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['ConterIndications'] = conterIndications;
    data['SecondaryEfects'] = secondaryEfects;
    data['ComercialBrands'] = comercialBrands;
    data['Obs'] = obs;
    data['Presentation'] = presentation;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (indications != null) {
      data['indications'] = indications!.map((v) => v.toJson()).toList();
    }
    if (variables != null) {
      data['variables'] = variables!.map((v) => v.toJson()).toList();
    }
    if (calculations != null) {
      data['calculations'] = calculations!.map((v) => v.toJson()).toList();
    }
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
    id = json['Id'];
    drugId = json['DrugId'];
    indicationText = json['IndicationText'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['doses'] != null) {
      doses = <Doses>[];
      json['doses'].forEach((v) {
        doses!.add(Doses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['DrugId'] = drugId;
    data['IndicationText'] = indicationText;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
    id = json['Id'];
    indicationId = json['IndicationId'];
    idVia = json['IdVia'];
    pediatricDose = json['PediatricDose'];
    idUnityPediatricDose = json['IdUnityPediatricDose'];
    adultDose = json['AdultDose'];
    idUnityAdultDose = json['IdUnityAdultDose'];
    takesPerDay = json['TakesPerDay'];
    maxDosePerDay = json['MaxDosePerDay'];
    idUnityMaxDosePerDay = json['IdUnityMaxDosePerDay'];
    obs = json['obs'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['IndicationId'] = indicationId;
    data['IdVia'] = idVia;
    data['PediatricDose'] = pediatricDose;
    data['IdUnityPediatricDose'] = idUnityPediatricDose;
    data['AdultDose'] = adultDose;
    data['IdUnityAdultDose'] = idUnityAdultDose;
    data['TakesPerDay'] = takesPerDay;
    data['MaxDosePerDay'] = maxDosePerDay;
    data['IdUnityMaxDosePerDay'] = idUnityMaxDosePerDay;
    data['obs'] = obs;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
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
  Pivot? pivot;

  Variables(
      {this.id,
      this.description,
      this.idUnit,
      this.type,
      this.createdAt,
      this.updatedAt,
      this.pivot});

  Variables.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    description = json['Description'];
    idUnit = json['IdUnit'];
    type = json['Type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Description'] = description;
    data['IdUnit'] = idUnit;
    data['Type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  String? variableId;
  int? drugId;

  Pivot({this.variableId, this.drugId});

  Pivot.fromJson(Map<String, dynamic> json) {
    variableId = json['VariableId'];
    drugId = json['DrugId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['VariableId'] = variableId;
    data['DrugId'] = drugId;
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
    id = json['Id'];
    drugId = json['DrugId'];
    type = json['Type'];
    function = json['Function'];
    resultDescription = json['ResultDescription'];
    resultIdUnit = json['ResultIdUnit'];
    description = json['Description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['DrugId'] = drugId;
    data['Type'] = type;
    data['Function'] = function;
    data['ResultDescription'] = resultDescription;
    data['ResultIdUnit'] = resultIdUnit;
    data['Description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
