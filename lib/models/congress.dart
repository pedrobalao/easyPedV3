class Congress {
  int? id;
  String? title;
  String? description;
  String? congressType;
  String? url;
  String? expiringDate;
  String? organizer;
  DateTime? beginDate;
  DateTime? endDate;
  String? city;
  String? country;
  String? coverUrl;

  Congress(
      {this.id,
      this.title,
      this.description,
      this.congressType,
      this.url,
      this.expiringDate,
      this.organizer,
      this.beginDate,
      this.endDate,
      this.city,
      this.country,
      this.coverUrl});

  Congress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    congressType = json['congress_type'];
    url = json['url'];
    expiringDate = json['expiringDate'];
    organizer = json['organizer'];
    beginDate = DateTime.parse(json['beginDate']);
    endDate = DateTime.parse(json['endDate']);
    city = json['city'];
    country = json['country'];
    coverUrl = json['coverUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['congress_type'] = congressType;
    data['url'] = url;
    data['expiringDate'] = expiringDate;
    data['organizer'] = organizer;
    data['beginDate'] = beginDate?.toIso8601String();
    data['endDate'] = endDate?.toIso8601String();
    data['city'] = city;
    data['country'] = country;
    data['coverUrl'] = coverUrl;
    return data;
  }
}
