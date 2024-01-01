class Usermodel {
  String? name;
  String? address;
  String? phone;

  Usermodel({
    this.name,
    this.address,
    this.phone,
  });
  factory Usermodel.fromJson(Map<String, dynamic> json) => Usermodel(
        name: json["name"],
        address: json["address"],
        phone: json["phone"],
      );
}
