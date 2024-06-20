import 'package:flutter/material.dart';
import 'package:tf/presentation/pages/Principal/crear_credito.page.dart';
//import 'package:provider/provider.dart';
//import 'package:tf/config/AuthState.dart';
import 'package:tf/presentation/pages/Principal/cuenta_tarjeta.page.dart';
import 'package:tf/presentation/pages/Auth/login.page.dart';
import 'package:tf/presentation/pages/Principal/historial.page.dart';
import 'package:tf/presentation/pages/principal_manage.page.dart';
import 'package:tf/presentation/pages/Auth/register.page.dart';
import 'package:tf/presentation/pages/Search/crear.page.dart';
import 'package:tf/presentation/pages/Search/search.page.dart';
import 'package:tf/presentation/pages/Search/solicitar.page.dart';

void main() {
  /*ChangeNotifierProvider(
    create: (context)=>AuthState(),
    child: MyApp()
  );*/
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trabajo Final',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == '/search/crear') {
          // Aquí puedes obtener el ID del settings.arguments si lo necesitas
          //final id = (settings.arguments as String).split('/')[1];
          final args = settings.arguments as Map<String, dynamic>;

          final id = args["id"];
          final isBusiness = args["isBusiness"];
          // Retornar la pantalla que corresponde a '/search/crear'
          return MaterialPageRoute(
            builder: (_) => CrearPage(id: id,isBusiness:isBusiness ,), // Aquí deberías retornar tu widget apropiado
            settings: settings,
          );
        }

        // Si la ruta no está definida aquí, puedes retornar null o una ruta de error
        return null;
      },
      routes: {
        '/': (context) => const PrincipalManagePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/principal': (context) => const PrincipalManagePage(),
        '/principal/cuenta': (context) => const CuentaTarjetaPage(),

        '/search': (context) => const SearchPage(),
        '/search/solicitar' : (context)=> const SolicitarPage(),
        '/historial':(context) => const HistorialPage(),

        'principal/crear-credito':(context) => const CrearCreditoPage()
        //'/search/crear/:id':(context) => CrearPage()
      },
      //initialRoute: '/login',
      //home: PrincipalPage()
      //home: PrincipalManagePage(),
      //initialRoute: '/search/solicitar',
      initialRoute: '/principal',
    );
    //return MySample();
  }
}
