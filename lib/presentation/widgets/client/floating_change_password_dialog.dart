import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tf/cubits/change_password_cubit.dart';
import 'package:tf/presentation/widgets/custom_button.dart';
import 'package:tf/presentation/widgets/custom_text_form_field.dart';
import 'package:tf/services/api/user_service.dart';


class FloatingChangePasswordDialog extends StatefulWidget {
  final VoidCallback onPasswordUpdated;

  const FloatingChangePasswordDialog({super.key, required this.onPasswordUpdated});

  @override
  State<FloatingChangePasswordDialog> createState() =>
      _FloatingChangePasswordDialogState();
}

class _FloatingChangePasswordDialogState
    extends State<FloatingChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordCubit(
        userService: context.read<UserService>(), // Inject UserService
      ),
      child: AlertDialog(
        title: const Text('Actualizar Contraseña'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: _newPasswordController,
                hintText: 'Nueva contraseña',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su nueva contraseña';
                  }
                  if (value.length < 8) {
                    return 'La contraseña debe tener al menos 8 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirmar contraseña',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor confirme su nueva contraseña';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
                listener: (context, state) {
                  if (state is ChangePasswordSuccess) {
                    // Dismiss the dialog after successful update
                    Navigator.of(context).pop();
                    widget.onPasswordUpdated();
                  } else if (state is ChangePasswordFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ChangePasswordLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return CustomButton(
                    text: 'Actualizar',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<ChangePasswordCubit>().updatePassword(
                            newPassword: _newPasswordController.text);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}