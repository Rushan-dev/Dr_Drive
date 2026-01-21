import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserListTile extends StatelessWidget {
  final UserModel user;
  final Function(UserRole) onRoleChanged;

  const UserListTile({
    super.key,
    required this.user,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(user.name ?? user.email),
        subtitle: Text(user.email),
        trailing: DropdownButton<UserRole>(
          value: user.role,
          items: UserRole.values.map((role) {
            return DropdownMenuItem(
              value: role,
              child: Text(
                role.toString().split('.').last,
                style: TextStyle(
                  color: role == UserRole.admin
                      ? Colors.red
                      : role == UserRole.mod
                      ? Colors.blue
                      : Colors.green,
                ),
              ),
            );
          }).toList(),
          onChanged: (UserRole? newRole) {
            if (newRole != null) {
              onRoleChanged(newRole);
            }
          },
        ),
      ),
    );
  }
}
