import 'package:flutter/material.dart';
import 'package:flutter_application_4/payment_section.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Adress {
  final String adress;

  Adress(this.adress);
}

class AdressSee extends StatefulWidget {
  const AdressSee({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdressSeeState createState() => _AdressSeeState();
}

class _AdressSeeState extends State<AdressSee> {
  bool changeValue = false;
  List<Adress> adress = [
    Adress('Azərbaycan, Bakı, Codelandia'),
    Adress('Azərbaycan, Bakı, Rabitəbank'),
    Adress('Azərbaycan, Bakı, Nəriman Nərimanov M.S.'),
    Adress('Azərbaycan, Sumqayıt'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: Colors.white,
            )),
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: adress.map((adres) {
            return ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.locationArrow,
                color: Colors.blue,
              ),
              title: Text(adres.adress),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentMethodSelectionPage(
                      adress: adres,
                      address: adres,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
