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
  final List<dynamic> loans;

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
    required this.loans,
  });

  factory UserLoan.fromJson(Map<String, dynamic> json) {
    return UserLoan(
      id: json['id'], // Valor padrão para id
      name: json['name'], // Valor padrão para nome
      email: json['email'], // Valor padrão para email
      rna: json['rna'] ?? 'RNA não informado', // Valor padrão para RNA
      enterprise: json['enterprise'] ?? 'Empresa não informada', // Valor padrão para empresa
      identification: json['identification'] ?? 'Identificação não informada', // Valor padrão para identificação
      phone: json['phone'] ?? 'Telefone não informado', // Valor padrão para telefone
      statusUserEnum: json['statusUserEnum'] ?? '0', // Valor padrão para status
      typeUserLoanEnum: json['typeUserLoanEnum'] ?? '0', // Valor padrão para tipo
      loans: json['loans'] ?? [], // Lista padrão vazia se loans for null
    );
  }
}
