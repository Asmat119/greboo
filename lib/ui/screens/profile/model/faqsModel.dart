class FaqsModel {
  FaqsModel({
    required this.code,
    required this.message,
    required this.faqsData,
    required this.format,
    required this.timestamp,
  });

  int code;
  String message;
  FaqsData faqsData;
  String format;
  String timestamp;

  factory FaqsModel.fromJson(Map<String, dynamic> json) {
    return FaqsModel(
      code: json["code"] ?? 0,
      message: json["message"] ?? "",
      faqsData: FaqsData.fromJson(json["data"]),
      format: json["format"],
      timestamp: json["timestamp"],
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "FaqsData": faqsData.toJson(),
        "format": format,
        "timestamp": timestamp,
      };
}

class FaqsData {
  FaqsData({
    required this.list,
    required this.total,
    required this.page,
    required this.limit,
    required this.size,
    required this.hasMore,
  });

  List<ListElement> list;
  int total;
  int page;
  int limit;
  int size;
  bool hasMore;

  factory FaqsData.fromJson(Map<String, dynamic> json) => FaqsData(
        list: List<ListElement>.from(
            (json["list"] ?? []).map((x) => ListElement.fromJson(x))),
        total: json["total"],
        page: json["page"],
        limit: json["limit"],
        size: json["size"],
        hasMore: json["hasMore"],
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
        "total": total,
        "page": page,
        "limit": limit,
        "size": size,
        "hasMore": hasMore,
      };
}

class ListElement {
  ListElement({
    required this.deleted,
    required this.id,
    required this.question,
    required this.answer,
    required this.createdOn,
    required this.updatedOn,
    this.isSelected = false,
  });

  bool deleted;
  String id;
  String question;
  String answer;
  bool isSelected;
  DateTime createdOn;
  DateTime updatedOn;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        deleted: json["deleted"] ?? false,
        id: json["_id"] ?? "",
        question: json["question"] ?? "",
        answer: json["answer"] ?? "",
        createdOn: DateTime.parse(
            json["createdOn"] ?? DateTime.now().toIso8601String()),
        updatedOn: DateTime.parse(
            json["updatedOn"] ?? DateTime.now().toIso8601String()),
      );

  Map<String, dynamic> toJson() => {
        "deleted": deleted,
        "_id": id,
        "question": question,
        "answer": answer,
        "createdOn": createdOn.toIso8601String(),
        "updatedOn": updatedOn.toIso8601String(),
      };
}
