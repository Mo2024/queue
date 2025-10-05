class Customer {
  String name;
  String mobile1;
  String? mobile2;
  int numberOfPeople;

  Customer({
    required this.name,
    required this.mobile1,
    this.mobile2,
    required this.numberOfPeople,
  });

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      name: map['name'] ?? '',
      mobile1: map['mobile1'] ?? '',
      mobile2: map['mobile2'],
      numberOfPeople: map['numberOfPeople'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'mobile1': mobile1,
      'mobile2': mobile2,
      'numberOfPeople': numberOfPeople,
    };
  }
}
