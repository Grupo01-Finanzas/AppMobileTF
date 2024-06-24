import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tf/cubits/auth_cubit.dart';
import 'package:tf/cubits/establishment_cubit.dart';
import 'package:tf/models/api/credit_account.dart';
import 'package:tf/models/api/establishment.dart';
import 'package:tf/presentation/pages/Admin/add_client_page.dart';
import 'package:tf/presentation/pages/Admin/add_product_page.dart';
import 'package:tf/presentation/pages/Admin/admin_clients_page.dart';
import 'package:tf/presentation/pages/Admin/admin_products_page.dart';
import 'package:tf/presentation/pages/Admin/edit_admin_profile.dart';
import 'package:tf/presentation/pages/Admin/establishment_screen.dart';
import 'package:tf/presentation/pages/Admin/establishment_settings_page.dart';
import 'package:tf/presentation/pages/Admin/interest_rate_settings_page.dart';
import 'package:tf/presentation/pages/Admin/manage_clients.dart';
import 'package:tf/presentation/pages/Admin/manage_transactions.dart';
import 'package:tf/presentation/pages/Admin/product_detail_page.dart';
import 'package:tf/presentation/pages/Admin/product_edit_page.dart';
import 'package:tf/presentation/pages/Auth/login_screen.dart';
import 'package:tf/presentation/pages/Auth/register_screen.dart';
import 'package:tf/presentation/pages/Client/client_pay_debt_screen.dart';
import 'package:tf/presentation/pages/Home/home_screen.dart';
import 'package:tf/presentation/pages/admin/admin_credit_accounts_screen.dart';
import 'package:tf/presentation/pages/admin/admin_debt_summary_page.dart';
import 'package:tf/presentation/pages/admin/admin_home_screen.dart';
import 'package:tf/presentation/pages/admin/admin_settings_page.dart';
import 'package:tf/presentation/pages/admin/edit_establishment_page.dart';
import 'package:tf/presentation/pages/client/change_password_screen.dart';
import 'package:tf/presentation/pages/client/client_account_summary_screen.dart';
import 'package:tf/presentation/pages/client/client_home_screen.dart';
import 'package:tf/presentation/pages/client/client_installments_screen.dart';
import 'package:tf/presentation/pages/client/client_transactions_history_screen.dart';
import 'package:tf/repository/auth_repository.dart';
import 'package:tf/repository/establishment_repository.dart';
import 'package:tf/services/api/establishment_service.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) {
        return const RegisterScreen();
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        final token = state.extra as Map<String, dynamic>?;
        if (token != null) {
          return BlocProvider(
            create: (context) => AuthCubit(
              authRepository: context.read<AuthRepository>(),
            ),
            child: HomeScreen(token: token),
          );
        } else {
          return const LoginScreen();
        }
      },
    ),
    GoRoute(
      path: '/establishments/:id',
      builder: (context, state) {
        final establishmentId = int.tryParse(state.pathParameters['id']!) ?? 0;
        return BlocProvider(
          create: (context) => EstablishmentCubit(
            establishmentRepository: context.read<EstablishmentRepository>(),
          ),
          child: EstablishmentScreen(establishmentId: establishmentId),
        );
      },
      routes: [
        GoRoute(
          path: 'admin', // Note: No leading slash for nested routes
          builder: (context, state) {
            final establishmentId =
                int.tryParse(state.pathParameters['id']!) ?? 0;
            return BlocProvider(
              create: (context) => AuthCubit(
                authRepository: context.read<AuthRepository>(),
              ),
              child: AdminHomeScreen(establishmentId: establishmentId),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) {
        return BlocProvider(
          create: (context) => AuthCubit(
            authRepository: context.read<AuthRepository>(),
          ),
          child: const AdminProductsPage(),
        );
      },
    ),
    GoRoute(
      path: '/add-product',
      builder: (context, state) {
        return FutureBuilder<Establishment?>(
          future: _fetchEstablishmentData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator()); // Show loading indicator
            } else if (snapshot.hasError) {
              return Center(
                  child:
                      Text('Error: ${snapshot.error}')); // Show error message
            } else if (snapshot.hasData && snapshot.data != null) {
              return AddProductPage(establishment: snapshot.data!);
            } else {
              return const Text('Error: No establishment data found');
            }
          },
        );
      },
    ),
    GoRoute(
      path: '/client',
      builder: (context, state) {
        final token = state.extra as Map<String, dynamic>?;
        return BlocProvider(
          create: (context) =>
              AuthCubit(authRepository: context.read<AuthRepository>()),
          child: ClientHomeScreen(token: token!),
        );
      },
    ),
    GoRoute(
      path: '/manageTransactions',
      builder: (context, state) => const ManageTransactionsPage(),
    ),
    GoRoute(
      path: '/manageClients',
      builder: (context, state) => const ManageClientsPage(),
      routes: [
        GoRoute(
          path: 'add',
          builder: (context, state) => const AddClientPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/interestRateSettings',
      builder: (context, state) {
        // Retrieve the creditAccount from the extra argument
        final creditAccount = state.extra as CreditAccount;
        return InterestRateSettingsPage(creditAccount: creditAccount);
      },
    ),
    GoRoute(
      path: '/establishmentSettings',
      builder: (context, state) => const EstablishmentSettingsPage(),
    ),
    GoRoute(
      path: '/admin/products',
      builder: (context, state) {
        return const AdminProductsPage();
      },
    ),
    GoRoute(
      path: '/admin/clients',
      builder: (context, state) {
        return const AdminClientsPage();
      },
    ),
    GoRoute(
      path: '/admin/credit-accounts',
      builder: (context, state) {
        return const AdminCreditAccountsScreen();
      },
    ),
    GoRoute(
      path: '/admin/debt-summary',
      builder: (context, state) {
        return const AdminDebtSummaryPage();
      },
    ),
    GoRoute(
      path: '/admin/settings',
      builder: (context, state) {
        return const AdminSettingsPage();
      },
    ),
    GoRoute(
      path: '/admin/edit-establishment',
      builder: (context, state) {
        final establishment = state.extra as Establishment?;
        if (establishment != null) {
          return EditEstablishmentPage(establishment: establishment);
        } else {
          return const Text('Error: No establishment data found');
        }
      },
    ),
    GoRoute(
        path: '/products/:id/detail',
        builder: (context, state) {
          final productId = int.tryParse(state.pathParameters['id']!) ?? 0;
          return ProductDetailPage(productId: productId);
        }),
    GoRoute(
      path: '/product/:id/edit',
      builder: (context, state) {
        final productId = int.tryParse(state.pathParameters['id']!) ?? 0;
        return ProductEditPage(productId: productId);
      },
    ),
    GoRoute(
      path: '/client/transactions',
      builder: (context, state) {
        return const ClientTransactionsHistoryScreen();
      },
    ),
    GoRoute(
      path: '/client/installments',
      builder: (context, state) {
        return const ClientInstallmentsScreen();
      },
    ),
    GoRoute(
      path: '/client/account-summary',
      builder: (context, state) {
        return const ClientAccountSummaryScreen();
      },
    ),
    GoRoute(
      path: '/changePassword',
      builder: (context, state) {
        return const ChangePasswordScreen();
      },
    ),
    GoRoute(path: '/editAdminProfile', builder: (context, state) {
      return const EditAdminProfilePage();
    }),
    GoRoute(
      path: '/clientTransactions',
      builder: (context, state) {
        return const ClientTransactionsHistoryScreen();
      },
    ),
    GoRoute(
      path: '/clientInstallments',
      builder: (context, state) {
        return const ClientInstallmentsScreen();
      },
    ),
    GoRoute(
      path: '/clientAccountSummary',
      builder: (context, state) {
        return const ClientAccountSummaryScreen();
      },
    ),
    GoRoute(
      path: '/clientPayDebt',
      builder: (context, state) {
        return const ClientPayDebtScreen();
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(
      title: const Text('Error'),
    ),
    body: Center(
      child: Text(state.error.toString()),
    ),
  ),
);

// Helper function to fetch establishment data asynchronously
Future<Establishment?> _fetchEstablishmentData() async {
  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  final adminId = prefs.getInt('userId');

  if (accessToken != null && adminId != null) {
    return await EstablishmentService()
        .getEstablishmentByAdminId(adminId, accessToken);
  } else {
    return null;
  }
}
