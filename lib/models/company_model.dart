class CompanyData {
  String logoUrl;
  String companyName;
  String description;
  String email;
  String phone;
  String department;
  String city;
  String address;
  String productType;
  String capacity;
  String createdAt;

  CompanyData({
    required this.logoUrl,
    required this.companyName,
    required this.description,
    required this.email,
    required this.phone,
    required this.department,
    required this.city,
    required this.address,
    required this.productType,
    required this.capacity,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'logoUrl': logoUrl,
      'companyName': companyName,
      'description': description,
      'email': email,
      'phone': phone,
      'department': department,
      'city': city,
      'address': address,
      'productType': productType,
      'capacity': capacity,
      'createdAt': createdAt,
    };
  }
}
