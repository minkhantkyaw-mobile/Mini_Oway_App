class OwayHasPlace {
  final String id;
  final String driver_name;
  final String driver_image;
  final String phone;
  final String address;
  final double rating;
  bool isLoved;

  OwayHasPlace({
    required this.id,
    required this.driver_name,
    required this.driver_image,
    required this.phone,
    required this.address,
    required this.rating,
    this.isLoved = false,
  });

  factory OwayHasPlace.fromDriverDoc(String id, Map<String, dynamic> data) {
    return OwayHasPlace(
      id: id,
      driver_name: data['name'] ?? '',
      driver_image: data['driver_image'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
    );
  }



  /// For loading from local storage
  factory OwayHasPlace.fromJson(Map<String, dynamic> json) {
    return OwayHasPlace(
      id: json['id'],
      driver_name: json['driver_name'],
      driver_image: json['driver_image'],
      phone: json['phone'],
      address: json['address'],
      rating: (json['rating'] ?? 0).toDouble(),
      isLoved: json['isLoved'] ?? false,
    );
  }

  /// For saving to local storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'driver_name': driver_name,
    'driver_image': driver_image,
    'phone': phone,
    'address': address,
    'rating': rating,
    'isLoved': isLoved,
  };

}
