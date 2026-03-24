import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'Dashboard_screen.dart';
import 'Homepage.dart';
import '../Widgets/article.dart';
//import '../Widgets/doctorList.dart';
//import '../Widgets/listIcons.dart';
//import '../Login-Signup/login_signup.dart';
import 'package:page_transition/page_transition.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: camel_case_types
class articlePage extends StatelessWidget {
  const articlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Articles",
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: const Color.fromARGB(255, 100, 98, 98),
          ),
        ),
        centerTitle: true,
        toolbarHeight: 80,
        elevation: 0,
        leading: IconButton(
          icon: SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.06,
              child: Image.asset("assets/images/back2.png")),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.fade, child: const Homepage()));
          },
        ),
        actions: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.06,
              child: Image.asset("assets/images/more.png")),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: const BoxDecoration(),
              child: TextField(
                textAlign: TextAlign.start,
                textInputAction: TextInputAction.none,
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  focusColor: Colors.black26,
                  fillColor: const Color.fromARGB(255, 247, 247, 247),
                  filled: true,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                      width: MediaQuery.of(context).size.width * 0.01,
                      child: Image.asset(
                        "assets/images/search.png",
                        filterQuality: FilterQuality.high,
                      ),
                    ),
                  ),
                  prefixIconColor: const Color(0xFF339CFF),
                  label: const Text("Search doctor, drugs, articles..."),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  "Popular Articles",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * 3,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    Container(
                      height: 20,
                      width: 120,
                      decoration: const BoxDecoration(
                        color: Color(0xFF339CFF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "Covid-19",
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1),
                      )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 20,
                      width: 120,
                      decoration: const BoxDecoration(
                        color: Color(0xFF339CFF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "Diet",
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1),
                      )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 20,
                      width: 120,
                      decoration: const BoxDecoration(
                        color: Color(0xFF339CFF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "Fitness",
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1),
                      )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 20,
                      width: 120,
                      decoration: const BoxDecoration(
                        color: Color(0xFF339CFF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "Medicines",
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1),
                      )),
                    ),
                  ]),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          //TRENDING ARTICLE START FROM HERE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  "Trending Article",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2500,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ListView(scrollDirection: Axis.horizontal, children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2500,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          border: Border.all(color: Colors.black12)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1000,
                                width:
                                    MediaQuery.of(context).size.width * 0.3500,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: const DecorationImage(
                                        image: AssetImage(
                                          "images/article1.png",
                                        ),
                                        filterQuality: FilterQuality.high,
                                        fit: BoxFit.cover)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Container(
                                height: MediaQuery.of(context).size.height *
                                    0.01800,
                                width:
                                    MediaQuery.of(context).size.width * 0.1200,
                                color: const Color.fromARGB(255, 233, 231, 231),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Covid",
                                        style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(255, 2, 62, 118)),
                                      ),
                                    ]),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Comparing the AstraZeneca and Sinovac COVID-19 Vaccines",
                                style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromARGB(255, 0, 0, 0)),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Text(
                                    "Jun 10, 2021 ",
                                    style: GoogleFonts.poppins(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "5min Read",
                                    style: GoogleFonts.poppins(
                                        fontSize: 11.sp,
                                        color: const Color.fromARGB(255, 4, 61, 114),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2500,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          border: Border.all(color: Colors.black12)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1000,
                                width:
                                    MediaQuery.of(context).size.width * 0.3500,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: const DecorationImage(
                                        image: AssetImage(
                                          "images/capsules.png",
                                        ),
                                        filterQuality: FilterQuality.high,
                                        fit: BoxFit.cover)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Container(
                                height: MediaQuery.of(context).size.height *
                                    0.01800,
                                width:
                                    MediaQuery.of(context).size.width * 0.1200,
                                color: const Color.fromARGB(255, 233, 231, 231),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Covid",
                                        style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(255, 6, 77, 144)),
                                      ),
                                    ]),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Comparing the AstraZeneca and Sinovac COVID-19 Vaccines",
                                style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromARGB(255, 0, 0, 0)),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Text(
                                    "Jun 10, 2021 ",
                                    style: GoogleFonts.poppins(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "5min Read",
                                    style: GoogleFonts.poppins(
                                        fontSize: 11.sp,
                                        color: const Color(0xFF339CFF),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2500,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          border: Border.all(color: Colors.black12)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1000,
                                width:
                                    MediaQuery.of(context).size.width * 0.3500,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: const DecorationImage(
                                        image: AssetImage(
                                          "images/capsules2.png",
                                        ),
                                        filterQuality: FilterQuality.high,
                                        fit: BoxFit.cover)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Container(
                                height: MediaQuery.of(context).size.height *
                                    0.01800,
                                width:
                                    MediaQuery.of(context).size.width * 0.1200,
                                color: const Color.fromARGB(255, 233, 231, 231),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Covid",
                                        style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(255, 5, 78, 146)),
                                      ),
                                    ]),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "Comparing the AstraZeneca and Sinovac COVID-19 Vaccines",
                                style: GoogleFonts.inter(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromARGB(255, 0, 0, 0)),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Text(
                                    "Jun 10, 2021 ",
                                    style: GoogleFonts.poppins(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "5min Read",
                                    style: GoogleFonts.poppins(
                                        fontSize: 11.sp,
                                        color: const Color(0xFF339CFF),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ]),
                ),
              ),
            ],
          ),
          //Container End Here
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  "Related Article",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          //Import this from widget
          const article(
              image: "images/article1.png",
              dateText: "2 min Read",
              duration: "2 min read",
              mainText: "Main text"),
        ]),
      ),
    );
  }
}
