import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_static_maps_controller/google_static_maps_controller.dart';
//import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? name;
  String? email;
  String? nickname;
  int? lastPoints;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> fetchData() async {}

  Future<void> getData() async {
    if (userId != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      final points = await FirebaseFirestore.instance
          .collection('points')
          .doc(userId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final lastQuizPoints = points.data();
        setState(() {
          name = data?['name'].toString().toUpperCase();
          email = data?['email'].toString();
          nickname = data?['nickname'].toString();
          lastPoints = lastQuizPoints?['points'] as int;
        });
      }
    }
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition fshmnLocaion = CameraPosition(
    target: LatLng(42.65552893313327, 21.161281365462514),
    zoom: 19.4746,
  );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    //double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? 0 : 10),
      decoration: const BoxDecoration(
          gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 5,
              colors: [Colors.lime, Colors.white])),
      child: Center(
        child: AspectRatio(
          aspectRatio: kIsWeb ? 10 / 9 : 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: height * 0.1,
              ),
              Container(
                  alignment: Alignment.topCenter,
                  height: height * 0.2,
                  // color: Colors.white30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Pershendetje, jeni i kyqur si:',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        //color: Colors.red,

                        child: Text(
                          'EMRI: $name',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Raleway', fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        //color: Colors.red,

                        child: Text(
                          'EMAIL: $email',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Raleway', fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        //color: Colors.red,

                        child: Text(
                          'NOFKA: $nickname',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Raleway', fontSize: 15),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          'POINTS: $lastPoints',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'Raleway', fontSize: 15),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: height * 0.1,
              ),
              SizedBox(
                height: height * 0.5,
                child: GoogleMap(
                  mapType: MapType.satellite,
                  initialCameraPosition: fshmnLocaion,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: {
                    const Marker(
                      infoWindow: InfoWindow(title: 'F.SH.M.N'),
                      position: LatLng(42.65552893313327, 21.161281365462514),
                      markerId: MarkerId('m1'),
                    ),
                    const Marker(
                      infoWindow: InfoWindow(
                          title:
                              'Biblioteka Kombëtare Universitare e Kosovës "Pjetër Bogdani"'),
                      position: LatLng(42.65758287053318, 21.16201164722532),
                      markerId: MarkerId('m2'),
                    ),
                    const Marker(
                      infoWindow:
                          InfoWindow(title: 'Biblioteka "Hivzi Sylejmani"'),
                      position: LatLng(42.65266473506615, 21.1553045983063),
                      markerId: MarkerId('m3'),
                    ),
                    const Marker(
                      infoWindow:
                          InfoWindow(title: 'Libraria Universitare "Artini"'),
                      position: LatLng(42.65558557216763, 21.162063488221072),
                      markerId: MarkerId('m4'),
                    ),
                    const Marker(
                      infoWindow: InfoWindow(title: 'Libraria "Dukagjini"'),
                      position: LatLng(42.662726115485306, 21.16286220532721),
                      markerId: MarkerId('m5'),
                    )
                  },
                ),
              ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
