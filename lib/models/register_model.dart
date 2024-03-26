class Register {
  final int id;
  final String name;
  final String email;
  final String password;
  final String vehicle;
  final String devices;

  Register({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.vehicle,
    required this.devices,
  });

  factory Register.fromSqliteDatabase(Map<String, dynamic> data) {
    return Register(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      password: data['password'],
      vehicle: data['vehicle'],
      devices: data['devices'],
    );
  }
}

