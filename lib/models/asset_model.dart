class AssetModel {
  String id;
  String name;
  String type;
  String imagePath;
  DateTime createdAt;
  DateTime updatedAt;

  AssetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.imagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssetModel.fromJson(Map<String, dynamic> json) => AssetModel(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        imagePath: json["image_path"],
        createdAt: DateTime.parse(json["created_at"]).toLocal(),
        updatedAt: DateTime.parse(json["updated_at"]).toLocal(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "image_path": imagePath,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
