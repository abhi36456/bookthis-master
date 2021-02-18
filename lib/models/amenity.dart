class Amenity {
  Amenity({
    this.id,
    this.buildingId,
    this.amneties,
  });

  String id;
  String buildingId;
  String amneties;

  factory Amenity.fromJson(Map<String, dynamic> json) => Amenity(
        id: json["id"],
        buildingId: json["building_id"],
        amneties: json["amneties"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "building_id": buildingId,
        "amneties": amneties,
      };
}
