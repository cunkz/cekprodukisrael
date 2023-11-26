class BdnaashSearchModel {
  BdnaashSearchModel({
    this.status,
    this.msg,
    required this.data,
    this.html,
  });

  bool? status;
  String? msg;
  BdnaashSearchDataModel data;
  String? html;

  factory BdnaashSearchModel.fromJson(Map<String, dynamic> json) =>
      BdnaashSearchModel(
        status: json["status"],
        msg: json["msg"],
        data: BdnaashSearchDataModel.fromJson(json["data"]),
        html: json["html"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data,
        "html": html,
      };
}

class BdnaashSearchDataModel {
  BdnaashSearchDataModel({
    // this.id,
    this.title,
    this.isProIsrael,
  });

  // int? id;
  String? title;
  String? isProIsrael;

  factory BdnaashSearchDataModel.fromJson(Map<String, dynamic> json) =>
      BdnaashSearchDataModel(
        // id: int.parse(json["id"]),
        title: json["title"],
        isProIsrael: json["is_pro_israel"].toString(),
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "title": title,
        "isProIsrael": isProIsrael,
      };
}
