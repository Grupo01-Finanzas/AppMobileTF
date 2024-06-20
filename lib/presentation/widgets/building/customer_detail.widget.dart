import 'package:flutter/material.dart';
import 'package:tf/config/config.dart';
import 'package:tf/models/customer_datail.dart';
import 'package:tf/presentation/widgets/Photo/Photo_Circle.widget.dart';

class CustomerDetailWidget extends StatelessWidget {
  final CustomerDatail customerDatail;
  final Function onPressed;
  const CustomerDetailWidget(
      {super.key, required this.customerDatail, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    String titulo = customerDatail.entity;
    String informacion = customerDatail.informacion;
    String image = customerDatail.image;

    return Container(
        height: 110.0,
        width: 327.0,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                      color: Config.subTitleColor,
                      fontFamily: Config.poppingSemiBold,
                      fontSize: 16.0),
                ),
                Text(informacion,
                    style: const TextStyle(
                      color: Config.textColorIconButton,
                      fontFamily: Config.poppingMedium,
                      fontSize: 12.0,
                    )),
              ],
            ),
            IconButton(
                onPressed: () {
                  onPressed();
                },
                icon: PhotoCircle(
                  height: 86.0,
                  width: 86.0,
                  image: Image.network(
                    image,
                    fit: BoxFit.cover,
                  ),
                )),
          ],
        ));
  }
}
