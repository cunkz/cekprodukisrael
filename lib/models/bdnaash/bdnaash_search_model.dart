
class BdnaashSearchModel {
  BdnaashSearchModel({
    this.status,
    this.msg,
    this.html,
  });

  bool? status;
  String? msg;
  String? html;

  factory BdnaashSearchModel.fromJson(Map<String, dynamic> json) => BdnaashSearchModel(
        status: json["status"],
        msg: json["msg"],
        html: json["html"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "html": html,
      };
}