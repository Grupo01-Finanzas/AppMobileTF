import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/config/app_route.dart';
import 'package:tf/cubits/account_summary_cubit.dart';
import 'package:tf/cubits/auth_cubit.dart';
import 'package:tf/cubits/change_password_cubit.dart';
import 'package:tf/cubits/client_cubit.dart';
import 'package:tf/cubits/establishment_cubit.dart';
import 'package:tf/cubits/installment_cubit.dart';
import 'package:tf/cubits/pay_debt_cubit.dart';
import 'package:tf/cubits/purchase_cubit.dart';
import 'package:tf/cubits/transaction_cubit.dart';
import 'package:tf/repository/account_summary_repository.dart';
import 'package:tf/repository/auth_repository.dart';
import 'package:tf/repository/client_repository.dart';
import 'package:tf/repository/establishment_repository.dart';
import 'package:tf/repository/installment_repository.dart';
import 'package:tf/repository/purchase_repository.dart';
import 'package:tf/repository/transaction_repository.dart';
import 'package:tf/services/api/credit_account_service.dart';
import 'package:tf/services/api/establishment_service.dart';
import 'package:tf/services/api/product_service.dart';
import 'package:tf/services/api/user_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if a user is logged in
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');

  return runApp(
    MultiBlocProvider(providers: [
      Provider<AuthRepository>(
        create: (context) => AuthRepository(),
      ),
      Provider<EstablishmentRepository>(
        create: (context) => EstablishmentRepository(),
      ),
      Provider<CreditAccountService>(
          create: (context) => CreditAccountService()),
      Provider<UserService>(
        create: (context) => UserService(),
      ),
      Provider<EstablishmentService>(
          create: (context) => EstablishmentService()),
      Provider<ProductService>(create: (context) => ProductService()),
      Provider(create: (context) => AccountSummaryRepository()),
      Provider(create: (context) => ClientRepository()),
      Provider(create: (context) => InstallmentRepository()),
      Provider(create: (context) => TransactionRepository()),
      Provider(create: (context) => PurchaseRepository()),
      BlocProvider(
        create: (context) => AuthCubit(
          authRepository: context.read<AuthRepository>(),
        ),
      ),
      BlocProvider(
          create: (context) => EstablishmentCubit(
                establishmentRepository:
                    context.read<EstablishmentRepository>(),
              )),
      BlocProvider(create: (context) => AccountSummaryCubit(accountSummaryRepository: context.read<AccountSummaryRepository>())),

      BlocProvider(create: (context) => ClientCubit(clientRepository: context.read<ClientRepository>())),

      BlocProvider(create: (context) => InstallmentCubit(installmentRepository: context.read<InstallmentRepository>())),

      BlocProvider(create: (context) => PayDebtCubit(transactionRepository: context.read<TransactionRepository>())),

      BlocProvider(create: (context) => PurchaseCubit(purchaseRepository: context.read<PurchaseRepository>())),

      BlocProvider(create: (context) => TransactionCubit(transactionRepository: context.read<TransactionRepository>())),

      BlocProvider(
          create: (context) =>
              ChangePasswordCubit(userService: context.read<UserService>())),
    ], child: MyApp(
      initialLocation: accessToken != null ? '/home' : '/',
    )),
  );
}

class MyApp extends StatelessWidget {
  final String initialLocation;
  const MyApp({super.key, required this.initialLocation});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Trabajo Final',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}
