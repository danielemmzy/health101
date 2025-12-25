import 'package:flutter/material.dart';
import '../Widgets/shedule_card.dart';

class shedule_tab1 extends StatelessWidget {
  const shedule_tab1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        SizedBox(
          height: 30,
        ),
        shedule_card(
          confirmation: "Confirmed",
          mainText: "Dr. Marcus Horizon",
          subText: "Chardiologist",
          date: "26/06/2022",
          time: "10:30 AM",
          image: "assets/images/male-doctor.png",
        ),
        SizedBox(
          height: 20,
        ),
        shedule_card(
          confirmation: "Confirmed",
          mainText: "Dr. Marcus Horizon",
          subText: "Chardiologist",
          date: "26/06/2022",
          time: "2:00 PM",
          image: "assets/images/female-doctor2.png",
        )
      ]),
    );
  }
}
