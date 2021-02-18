class Building {
  String id;
  String buildingName;

  Building({this.id, this.buildingName});
  factory Building.fromJson(Map<String, dynamic> json) =>
      Building(id: json["id"], buildingName: json["building_name"]);
}
