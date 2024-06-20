import 'package:flutter/material.dart';
import 'package:tf/presentation/widgets/buttons/my_button.widget.dart';
import 'package:tf/presentation/widgets/head/head_widget.dart';
import 'package:tf/presentation/widgets/input/combo_box_input.widget.dart';


class CrearCreditoPage extends StatefulWidget {
  const CrearCreditoPage({super.key});

  @override
  State<CrearCreditoPage> createState() => _CrearCreditoPageState();
}

class _CrearCreditoPageState extends State<CrearCreditoPage> {
  //Cliente
  int idCliente = 0;

  TextEditingController tasaController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //this.idCliente = 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: HeadWidget(
                title: "Crear credito",
                colorT: const Color(0xFF343434),
                onPressed: () {
                  Navigator.pop(context);
                })),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 49.0),
            //child: Text("Texto" + widget.id.toString())
            child: Column(
              children: [
                form()
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget form() {
    Widget form = Column(
      children: [
        /*
        TextInput(
            hintText: "Monto",
            controller: montoController,
            textInputType: TextInputType.number,
          ),
          TextInput(
            hintText: "Dias",
            controller: diasController,
            textInputType: TextInputType.number,
          ),
          
          
          
          
          TextInput(
            hintText: "Porcentaje ex: 10",
            controller: porcentajeController,
            textInputType: TextInputType.number,
          ),
*/
        ComboBoxInput(controller: tasaController),
        MyButton(
          onPressed: () {
            print(tasaController.text);
          },
          texto: "Confirmar",
          camposRellenos: true,
        )
      ],
    );

    return form;
  }
}
