import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  int tabsCount = 0;
  int doubleTabsCount = 0;
  int longPressCount = 0;
  double xPosition = 0.0;
  double yPosition = 0.0;
  double boxSize=150.0;
  double fullBoxSize=150.0;

  AnimationController controller;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();
    controller=AnimationController(
      duration: const Duration(milliseconds: 10000),
      vsync: this//ekran kaynalşarının gereksiz kullanımını engellemyi sağlar.
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceInOut);
    animation.addListener(() {
      setState(() {
        boxSize=fullBoxSize*animation.value;//0 dan 1 e gitmeyi 10 saniyede yapacak.
      });
      centerBox(context);
    });
    controller.forward();//controller ı çalıştırır.
  }

  @override
  void dispose() {//bellekten atar.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if(xPosition==0.0){
    //   centerBox(context);
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestures demo"),
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            tabsCount++;
          });
        },
        onDoubleTap: () {
          setState(() {
            doubleTabsCount++;
          });
        },
        onLongPress: () {
          setState(() {
            longPressCount++;
          });
        },
        onVerticalDragUpdate: (DragUpdateDetails value) {
          //dikey sürükleme için
          setState(() {
            double delta = value.delta.dy;
            yPosition += delta;
          });
        },
        onHorizontalDragUpdate: (DragUpdateDetails value) {
          //yatay sürükleme için
          setState(() {
            double delta = value.delta.dx;
            xPosition += delta;
          });
        },
        child: Stack(
          children: <Widget>[
            Positioned(
              left: xPosition,
              top: yPosition,
              child: Container(
                width: boxSize,
                height: boxSize,
                decoration: BoxDecoration(color: Colors.deepPurpleAccent),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Material(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
              "Tab : $tabsCount, DoubleTab : $doubleTabsCount, Long Press : $longPressCount"),
        ),
      ),
    );
  }

  void centerBox(BuildContext context){//kutuyu ekrana ortaladık.
    xPosition= MediaQuery.of(context).size.width/2.0 - boxSize/2.0;
    yPosition= MediaQuery.of(context).size.height/2.0 - boxSize/2.0 -30.0;

    setState(() {
      this.xPosition=xPosition;
      this.yPosition=yPosition;
    });
  }
}
