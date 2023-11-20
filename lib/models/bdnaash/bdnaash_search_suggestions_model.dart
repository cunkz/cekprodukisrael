
class BdnaashSearchSuggestionsModel {
  BdnaashSearchSuggestionsModel({
    this.status,
    this.msg,
    this.html,
  });

  bool? status;
  String? msg;
  String? html;

  factory BdnaashSearchSuggestionsModel.fromJson(Map<String, dynamic> json) => BdnaashSearchSuggestionsModel(
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