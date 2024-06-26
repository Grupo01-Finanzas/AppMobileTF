import 'package:debit_credit_card_widget/debit_credit_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:tf/config/svg_state.dart';
//import 'package:provider/provider.dart';
//import 'package:tf/config/AuthState.dart';
import 'package:tf/config/config.dart';
import 'package:tf/presentation/widgets/card_debit.widget.dart';
import 'package:tf/presentation/widgets/head/head_widget_icon.dart';
import 'package:en_card_swiper/en_card_swiper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({super.key});

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  //final auth = Provider.of(AuthState)(context,listen:false);
  //final auth = Provider.of<AuthState>(context, listen: false);
  //auth.setUserRole(rolDelUsuarioDesdeElBackend);
  //auth.setAuthToken(tokenDeAutenticacionDesdeElBackend);

  //Importante para service
  //Servie
  //Service

  final List<CardDebitWidget> tarjetas = [
    CardDebitWidget(
      cardBrandD: CardBrand.mastercard,
    ),
    CardDebitWidget(
      cardBrandD: CardBrand.custom,
    ),
    CardDebitWidget(
      cardBrandD: CardBrand.mastercard,
    ),
  ];

  String user = "Usuario";

  /*Widget DebitTarjet(){
    return 
  }*/

  Widget cards() {
    return Center(
      child: SizedBox(
        height: 221,
        child: ENSwiper(
          axisDirection: AxisDirection.left,
          pagination: const ENSwiperPagination(
            margin: EdgeInsets.all(10.0),
          ),
          itemCount: tarjetas.length,
          itemWidth: 327.0,
          autoplay: true,
          duration: 500,
          layout: SwiperLayout.STACK,
          itemBuilder: (context, index) {
            return Container(
              //padding: const EdgeInsets.only(bottom: 20.0),
              //margin: const EdgeInsets.only(bottom: 20.0),
              child: tarjetas[index],
            );
          },
        ),
      ),
    );
  }

  Widget option(String svgData, String text, Function onPressed) {
    return SizedBox(
      height: 100.0,
      width: 100.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () {
                onPressed();
              },
              icon: SvgPicture.string(
                svgData,
                width: 28.00,
                height: 28.00,
              )),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Config.textColorIconButton,
                fontFamily: Config.poppingMedium,
                fontSize: 12.0),
          )
        ],
      ),
    );
  }

  Widget options() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 63.0),
        child: SizedBox(
          height: 253,
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 53.0,
            crossAxisSpacing: 49.0,
            children: [
              option(SvgState.svgUno, "Cuenta y tarjeta", () {
                Navigator.pushNamed(context, '/principal/cuenta');
              }),
              option(SvgState.svgDos, "Historial de pagos", () {
                Navigator.pushNamed(context, '/historial');
              }),
              option(SvgState.svgTres, "Pagar Servicios", () {
                Navigator.pushNamed(context, 'principal/crear-credito');
              }),
              option(SvgState.svgCuatro, "Transaccion", () {}),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.titleColor,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: HeadWidgetIcon(
                  title: "Hola, $user",
                  notificationsCount: 3,
                  image: "https://www.upc.edu.pe/static/img/logo_upc_red.png",
                  onPressed: () {
                    Navigator.pushNamed(context, 'principal/cuenta');
                    //Navigator.pop(context);
                  }),
            ),
            Expanded(
                //expaded modificar si es
                //necesario para el bototm
                //app bar
                child: Container(
                    //margin: EdgeInsets.only(bottom: 91.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0)),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 24.0, left: 24.0, top: 24.0, bottom: 63),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          cards(),
                          options(),
                          const SizedBox(
                            height: 91.0,
                          )

                          //Option(svgUno, "Cuenta y tarjeta", (){})
                        ],
                      ),
                    )))
          ]
          //bottomNavigationBar: BottomNavBarFb2(),
          //
          //bottomNavigationBar:
          ),
    );
  }
}

////
///
///

//- - - - - - - - - Instructions - - - - - - - - - - - - - - - - - -
//
// Default Widget call (instantiation):
//  - CreditCard(onTopRightButtonClicked: () {}, cardIcon: Image.network("https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/mastercard.png?alt=media&token=1ae51e14-5a60-4dbf-8a42-47cb9c3c1dfe",  width: 50,))
//
// Coming Soon:
//  - integration into a a card stack
//
//- - - - - - - - - - - - - - -  - - - - - - - - - - - - - - - - - -
