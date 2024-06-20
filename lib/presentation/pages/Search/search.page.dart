import 'package:flutter/material.dart';
import 'package:tf/models/business_detail.dart';
import 'package:tf/models/customer_datail.dart';
import 'package:tf/presentation/widgets/building/business_detail.widget.dart';
import 'package:tf/presentation/widgets/building/customer_detail.widget.dart';
import 'package:tf/presentation/widgets/head/head_widget.dart';
import 'package:tf/presentation/widgets/input/search_input.widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();

  List<BusinessDetail> negocios = [];
  List<CustomerDatail> clientes = [];
  bool isBusiness = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isBusiness = true;
    getBody(isBusiness);
  }

  getBody(verify) {
    //service
    //service
    if (verify == true) {
      negocios = [
        BusinessDetail(
            id: 1,
            entity: "Tiendo",
            address: "Av. brazil n° 1213",
            informacion: "Siempre abierto",
            image:
                "https://elblogdeidiomas.es/wp-content/uploads/2018/03/ingles-de-negocios.png"),
        BusinessDetail(
            id: 2,
            entity: "Tiendo",
            address: "Av. brazil n° 1213",
            informacion: "Siempre abierto",
            image:
                "https://elblogdeidiomas.es/wp-content/uploads/2018/03/ingles-de-negocios.png"),
      ];
    } else {
      clientes = [
        CustomerDatail(
            id: 1,
            entity: "Jorge Manuel",
            informacion: "Loquillo SAC",
            image:
                "https://elblogdeidiomas.es/wp-content/uploads/2018/03/ingles-de-negocios.png"),
        CustomerDatail(
            id: 2,
            entity: "Jorge Manuel",
            informacion: "Loquillo SAC",
            image:
                "https://elblogdeidiomas.es/wp-content/uploads/2018/03/ingles-de-negocios.png"),
        CustomerDatail(
            id: 3,
            entity: "Jorge Manuel",
            informacion: "Loquillo SAC",
            image:
                "https://elblogdeidiomas.es/wp-content/uploads/2018/03/ingles-de-negocios.png"),
        CustomerDatail(
            id: 4,
            entity: "Jorge Manuel",
            informacion: "Loquillo SAC",
            image:
                "https://elblogdeidiomas.es/wp-content/uploads/2018/03/ingles-de-negocios.png"),
        CustomerDatail(
            id: 5,
            entity: "Jorge Manuel",
            informacion: "Loquillo SAC",
            image:
                "https://elblogdeidiomas.es/wp-content/uploads/2018/03/ingles-de-negocios.png"),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: HeadWidget(
                  title: "Buscar",
                  colorT: const Color(0xFF343434),
                  onPressed: () {
                    Navigator.pop(context);
                  })),
          SearchInput(
              hintText:
                  isBusiness ? "Buscar establecimiento" : "Buscar clientes",
              controller: searchController,
              function: () {
                //Actualizar el list view
              }),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    Widget items = isBusiness
                        ? BusinessDetailWidget(
                            businessDetail: negocios[index],
                            onPressed: () {
                              //print(negocios[index].id);
                              var id = negocios[index].id;
                              Navigator.pushNamed(context, '/search/crear',
                                  arguments: {"id":id,"isBusiness":isBusiness});
                            },
                          )
                        : CustomerDetailWidget(
                            customerDatail: clientes[index],
                            onPressed: () {
                              //print(clientes[index].id);
                              int id = clientes[index].id;
                              Navigator.pushNamed(context, '/search/crear',
                                  arguments: {"id":id,"isBusiness":isBusiness});
                            },
                          );
                    return items;
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 20.0);
                  },
                  itemCount: isBusiness ? negocios.length : clientes.length),
            ),
          ),
        ]));
  }
}
