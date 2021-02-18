class Section {
  Section({
    this.id,
    this.buildingId,
    this.floorId,
    this.sectionName,
  });

  String id;
  String buildingId;
  String floorId;
  String sectionName;

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        id: json["id"],
        buildingId: json["building_id"],
        floorId: json["floor_id"],
        sectionName: json["section_name"],
      );
}
