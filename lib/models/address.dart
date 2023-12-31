class Address
{
  String? name;
  String? phoneNumber;
  String? chowk;
  String? city;
  String? state;

  String? country;
  String? fullAddress;
  double? lat;
  double? lng;

  Address({
   this.name,
    this.chowk,
    this.city,
    this.state,
    this.fullAddress,
    this.lat,
    this.lng,
    this.phoneNumber,
    this.country,
});
  Address.fromJson(Map<String, dynamic>json)
  {
    name = json['name'];
    phoneNumber= json['phoneNumber'];
    chowk= json['chowk'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    fullAddress = json['fullAddress'];
    lat = json['lat'];
    lng = json['lng'];

  }
  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data["phoneNumber"] = phoneNumber;
    data["chowk"] = chowk;
    data["city"] = city;
    data["state"] = state;
    data["country"] = country;
    data["fullAddress"] = fullAddress;
    data["lat"] = lat;
    data["lng"]= lng;
 return data;

  }


}