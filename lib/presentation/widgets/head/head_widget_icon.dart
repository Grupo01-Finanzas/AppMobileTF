import 'package:flutter/material.dart';
import 'package:tf/config/config.dart';



class HeadWidgetIcon extends StatelessWidget {
  final Function onPressed;
  final String title;
  final String image;
  final int notificationsCount;
  const HeadWidgetIcon(
      {super.key,
      required this.title,
      required this.onPressed,
      required this.image,
      required this.notificationsCount});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100.0,
        padding: const EdgeInsets.only(top: 25.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      onPressed();
                    },
                    icon: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: Image.network(
                        "https://www.upc.edu.pe/static/img/logo_upc_red.png",
                        fit: BoxFit.cover,
                        height: 50.0,
                        width: 50.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18.0,),
                  Text(
                    title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: Config.poppingMedium),
                  ),
                ],
              ),
            ),
            notificationBell(notificationsCount)
          ],
        ));
  }

  Widget notificationBell(int notificationsCount) {
    String value = (notificationsCount > 9) ? "+" : notificationsCount.toString();
    double fontSize = (notificationsCount > 9) ? 15 : 10;

    return SizedBox(
      height: 50.0,
      width: 50.0,
      child: Stack(
        children: [
          IconButton(
            iconSize: 30,
            icon: Stack(
              children: [
                const Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child:(notificationsCount == 0)
                        ? const SizedBox()
                        :  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child:  Center(
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: fontSize,
                                  fontFamily: Config.poppingMedium),
                            ),
                          )
                          
                    
                  ),
                  
                ),
              ],
            ),
            onPressed: () {
              // notificaciones action
              // notificaciones action
              // notificaciones action
              // notificaciones action
              // notificaciones action
            },
          ),
        ],
      ),
    );
  }
}
