import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tf/cubits/auth_cubit.dart';
import 'package:tf/presentation/pages/Auth/login_screen.dart';
import 'package:tf/presentation/widgets/custom_button.dart';
import 'package:tf/presentation/widgets/custom_text_form_field.dart';
import 'package:tf/repository/auth_repository.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dniController = TextEditingController();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _establishmentRucController = TextEditingController();
  final _establishmentNameController = TextEditingController();
  final _establishmentPhoneController = TextEditingController();
  final _establishmentAddressController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _dniController.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _establishmentRucController.dispose();
    _establishmentNameController.dispose();
    _establishmentPhoneController.dispose();
    _establishmentAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrarse'),
      ),
      body: BlocProvider(
        create: (context) => AuthCubit(authRepository: context.read<AuthRepository>()),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Personal Information
                  const SizedBox(height: 20),
                  const Text(
                    'Información Personal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _dniController,
                    hintText: 'DNI',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su DNI';
                      }
                      if (value.length != 8) {
                        return 'El DNI debe tener 8 dígitos';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _nameController,
                    hintText: 'Nombre',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _emailController,
                    hintText: 'Correo electrónico',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su correo electrónico';
                      }
                      if (!value.contains('@')) {
                        return 'Por favor ingrese un correo electrónico válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _passwordController,
                    hintText: 'Contraseña',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su contraseña';
                      }
                      if (value.length < 8) {
                        return 'La contraseña debe tener al menos 8 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _addressController,
                    hintText: 'Dirección',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su dirección';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _phoneController,
                    hintText: 'Teléfono',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su teléfono';
                      }
                      if (value.length != 9) {
                        return 'El número de teléfono debe tener 9 dígitos';
                      }
                      return null;
                    },
                  ),

                  // Establishment Information
                  const SizedBox(height: 20),
                  const Text(
                    'Información del Establecimiento',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _establishmentRucController,
                    hintText: 'RUC',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el RUC del establecimiento';
                      }
                      if (value.length != 11) {
                        return 'El RUC debe tener 11 dígitos';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _establishmentNameController,
                    hintText: 'Nombre del Establecimiento',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el nombre del establecimiento';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _establishmentPhoneController,
                    hintText: 'Teléfono del Establecimiento',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese el teléfono del establecimiento';
                      }
                      if (value.length != 9) {
                        return 'El número de teléfono debe tener 9 dígitos';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: _establishmentAddressController,
                    hintText: 'Dirección del Establecimiento',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese la dirección del establecimiento';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthRegisterSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Registro exitoso')),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      } else if (state is AuthRegisterFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.error)),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthRegisterLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return CustomButton(
                        text: 'Registrarse',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().registerAdmin(
                              dni: _dniController.text,
                              email: _emailController.text,
                              password: _passwordController.text,
                              name: _nameController.text,
                              address: _addressController.text,
                              phone: _phoneController.text,
                              establishmentRuc: _establishmentRucController.text,
                              establishmentName: _establishmentNameController.text,
                              establishmentPhone: _establishmentPhoneController.text,
                              establishmentAddress: _establishmentAddressController.text,
                            );
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}