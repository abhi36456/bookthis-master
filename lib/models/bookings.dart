import 'package:bookthis/models/amenity.dart';

class Bookings {
  Bookings({
    this.status,
    this.message,
    this.bookings,
  });

  bool status;
  String message;
  List<Data> bookings;

  factory Bookings.fromJson(Map<String, dynamic> json) => Bookings(
        status: json["status"],
        message: json["message"],
        bookings: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
      );
}

class Data {
  Data({
    this.id,
    this.userId,
    this.buildingId,
    this.type,
    this.deskType,
    this.fromTime,
    this.toTime,
    this.isAllDay,
    this.amneties,
    this.date,
    this.floorId,
    this.sectionId,
    this.createdAt,
    this.updatedAt,
    this.buildingName,
    this.address,
    this.floorName,
    this.sectionName,
  });

  String id;
  String userId;
  String buildingId;
  String type;
  String deskType;
  String fromTime;
  String toTime;
  String isAllDay;
  List<Amenity> amneties;
  DateTime date;
  String floorId;
  String sectionId;
  String createdAt;
  String updatedAt;
  String buildingName;
  String address;
  String floorName;
  String sectionName;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        userId: json["user_id"],
        buildingId: json["building_id"],
        type: json["type"],
        deskType: json["desk_type"],
        fromTime: json["from_time"],
        toTime: json["to_time"],
        isAllDay: json["is_all_day"],
        amneties: List<Amenity>.from(
            json["amneties"].map((x) => Amenity.fromJson(x))),
        date: DateTime.parse(json["date"]),
        floorId: json["floor_id"] == null ? null : json["floor_id"],
        sectionId: json["section_id"] == null ? null : json["section_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        buildingName: json["building_name"],
        address: json["address"],
        floorName: json["floor_name"],
        sectionName: json["section_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "building_id": buildingId,
        "type": type,
        "desk_type": deskType,
        "from_time": fromTime,
        "to_time": toTime,
        "is_all_day": isAllDay,
        "amneties": List<dynamic>.from(amneties.map((x) => x.toJson())),
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "floor_id": floorId == null ? null : floorId,
        "section_id": sectionId == null ? null : sectionId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "building_name": buildingName,
        "address": address,
        "floor_name": floorName,
        "section_name": sectionName,
      };
}
