import 'package:flutter/material.dart';
import 'package:tf/models/detalle_historial.dart';
import 'package:tf/presentation/widgets/head/head_widget.dart';
import 'package:tf/presentation/widgets/building/Details.widget.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({super.key});

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  List<DetalleHistorial> historial = [
    DetalleHistorial(
        id: 1,
        month: "September",
        status: "Unsuccessfully",
        amount: 480,
        date: DateTime(2023)),
    DetalleHistorial(
        id: 2,
        month: "September",
        status: "Successfully",
        amount: 480,
        date: DateTime(2023)),
    DetalleHistorial(
        id: 3,
        month: "September",
        status: "Unsuccessfully",
        amount: 480,
        date: DateTime(2023)),
    DetalleHistorial(
        id: 1,
        month: "September",
        status: "Unsuccessfully",
        amount: 480,
        date: DateTime(2023)),
    DetalleHistorial(
        id: 1,
        month: "September",
        status: "Unsuccessfully",
        amount: 480,
        date: DateTime(2023)),
    DetalleHistorial(
        id: 1,
        month: "September",
        status: "Unsuccessfully",
        amount: 480,
        date: DateTime(2023))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: HeadWidget(
                  title: "Historial de pagos",
                  colorT: const Color(0xFF343434),
                  onPressed: () {
                    Navigator.pop(context);
                  })),
            //Container(height: 88.0, child: DetailsWidget(detalleHistorial: historial[1],))
            
            Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
              //height: double.maxFinite,
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return DetailsWidget(detalleHistorial: historial[index]);
                    },
                    separatorBuilder: (context, index) {
                      //if (index == 0 || index == historial.length - 1) {
                       // return SizedBox.shrink();
                      //} else {
                        return const SizedBox(
                            height: 20.0); // Retorna el separador regular
                      //}
                    },
                    itemCount: historial.length),
            ),
          ),
          
        ]));
  }
}
