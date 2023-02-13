class News {
  int? id;
  String? title;
  String? description;
  String? url;
  String? expiringDate;
  String? owner;
  String? status;
  String? coverUrl;
  String? email;

  News(
      {this.id,
      this.title,
      this.description,
      this.url,
      this.expiringDate,
      this.owner,
      this.status,
      this.coverUrl,
      this.email});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    expiringDate = json['expiringDate'];
    owner = json['owner'];
    status = json['status'];
    coverUrl = json['coverUrl'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['url'] = url;
    data['expiringDate'] = expiringDate;
    data['owner'] = owner;
    data['status'] = status;
    data['coverUrl'] = coverUrl;
    data['email'] = email;
    return data;
  }
}
