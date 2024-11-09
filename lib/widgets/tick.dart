import 'dart:async';

import 'package:flutter/material.dart';
import 'package:toolkit/models/player.dart';

class Tick extends StatefulWidget { // todo modify this so it receives the specific value to monitor. 
  //final Player player;
  const Tick({super.key});
  
  @override
  State<Tick> createState() => _TickState();
}

class _TickState extends State<Tick> {

  @override
  void initState() {
    super.initState();
    
    // widget.player.score.addListener((){
    //   setState(() {
    //     show = true;
    //   });
    // Timer _ = Timer(const Duration(milliseconds: 1500), (){
    //     setState(() {
    //       show = false;
    //     });
    //   });
    // });
  // }
  // bool show = false;
  // void display(){
  //   setState(() {
  //     show = true;
  //   });
  }
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/tick.png',
      height: 80,
      width: 80,
      color: Colors.green,
    );
  }
}
