import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tower_box_game/color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tower Box Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isTapFirst = true;
  late Timer _timer;
  var rng = math.Random();
  List listBlock = [];

  @override
  void initState() {
    for (var i = 0; i < 10; i++) {
      listBlock.add(rng.nextInt(10));
    }

    setState(() {});
    super.initState();
  }

  //เมื่อกดปุ่ม ทำลาย block ครั้งแรก
  void onTapFirst() {
    if (isTapFirst) {
      isTapFirst = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          "กดปุ่มสีที่ตรงกัน\nค้างไว้ 2 วินาที\nเพื่อทำลาย Block",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.grey[400],
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.4),
      ));
    }
  }

  //ปุ่มทำลาย block
  Widget blockDestroyButton(
    Color color,
  ) {
    return GestureDetector(
      onPanEnd: (_) => _timer.cancel(),
      onPanDown: (_) {
        onTapFirst();
        _timer = Timer(const Duration(seconds: 2), () {
          if (listBlock.last % 2 == 0 && color == ColorApp.pink) {
            listBlock.removeLast();
            setState(() {});
            print("บล็อก pink ถูกทำลาย");
          } else if (listBlock.last % 2 != 0 && color == ColorApp.blue) {
            listBlock.removeLast();
            setState(() {});
            print("บล็อก blue ถูกทำลาย");
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: color,
            border: Border.all(width: 1, color: ColorApp.border),
            borderRadius: const BorderRadius.all(Radius.circular(100))),
        width: 64,
        height: 64,
      ),
    );
  }

  Widget block(int number) {
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      height: 64,
      width: 120,
      decoration: BoxDecoration(
          color: number % 2 == 0 ? ColorApp.pink : ColorApp.blue,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: ColorApp.border)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        appBar: null,
        body: Column(
          children: [
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              children:
                                  List.generate(listBlock.length, (index) {
                                if (index == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Transform.rotate(
                                      angle: math.pi / 4,
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFD27AFF),
                                            border: Border.all(
                                                color: ColorApp.border)),
                                      ),
                                    ),
                                  );
                                } else {
                                  return block(listBlock[index]);
                                }
                              }),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width * 0.27,
                            bottom: 0,
                            child: Row(
                              children: [
                                const Icon(Icons.arrow_forward_ios_outlined),
                                Container(
                                  color: Colors.transparent,
                                  height: 65,
                                  width: 120,
                                ),
                                const Icon(Icons.arrow_back_ios_new_outlined),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                  )
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        blockDestroyButton(ColorApp.pink),
                        blockDestroyButton(ColorApp.blue)
                      ],
                    )))
          ],
        ),
      ),
    );
  }
}
