// lib/Components/user_loan_card.dart

import 'package:flutter/material.dart';
import '../models/user_loan.dart';

class UserLoanCard extends StatelessWidget {
  final UserLoan userLoan;

  const UserLoanCard({Key? key, required this.userLoan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          userLoan.name,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userLoan.email),
            Text('Status: ${userLoan.statusUserEnum}'),
            Text('Tipo: ${userLoan.typeUserLoanEnum}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                // Lógica de edição
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.grey),
              onPressed: () {
                // Lógica de exclusão
              },
            ),
          ],
        ),
      ),
    );
  }
}
