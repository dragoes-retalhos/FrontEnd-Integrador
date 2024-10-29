class UserLoan {
  final int id;
  final String name;
  final String email;
  final String rna;
  final String enterprise;
  final String identification;
  final String phone;
  final String statusUserEnum;
  final String typeUserLoanEnum;

  UserLoan({
    required this.id,
    required this.name,
    required this.email,
    required this.rna,
    required this.enterprise,
    required this.identification,
    required this.phone,
    required this.statusUserEnum,
    required this.typeUserLoanEnum,
  });

  factory UserLoan.fromJson(Map<String, dynamic> json) {
    return UserLoan(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      rna: json['rna'],
      enterprise: json['enterprise'],
      identification: json['identification'],
      phone: json['phone'],
      statusUserEnum: json['statusUserEnum'],
      typeUserLoanEnum: json['typeUserLoanEnum'],
    );
  }
}
