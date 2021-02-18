class Floor {
  Floor({
    this.id,
    this.buildingId,
    this.floorName,
  });

  String id;
  String buildingId;
  String floorName;

  factory Floor.fromJson(Map<String, dynamic> json) => Floor(
        id: json["id"],
        buildingId: json["building_id"],
        floorName: json["floor_name"],
      );
}
