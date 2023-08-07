import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);
  static final List<Widget> _widgetOptions = <Widget>[
    const Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    const Text(
      'Index 1: List',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<bool> itemExpanded = List.generate(10, (index) => false);
    List<double> dragStartX =
        List.generate(itemExpanded.length, (index) => 0.0);

    return MaterialApp(
        home: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'List',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: const Color.fromARGB(255, 255, 141, 141),
              onTap: _onItemTapped,
            ),
            floatingActionButton: SizedBox(
              width: 70,
              height: 70,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.pink[100],
                child: const Icon(
                  Icons.add_rounded,
                  size: 50,
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: Column(
              children: [
                Stack(
                  children: <Widget>[
                    SizedBox(
                        width: double.infinity,
                        height: 180,
                        child: CustomPaint(
                          painter: WavePainter(),
                        )),
                    const Positioned(
                      left: 15,
                      bottom: 80,
                      child: Text(
                        "TO-DO LIST",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        "today",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    sliderWidget(),
                  ],
                ),
              ],
            )));
  }

  Slidable sliderWidget() {
    return Slidable(
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          MaterialButton(
            onPressed: () {},
            color: Colors.red[300],
            textColor: Colors.white,
            padding: const EdgeInsets.all(8),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.delete,
              size: 35,
            ),
          ),
          MaterialButton(
            onPressed: () {},
            color: Colors.blue[300],
            textColor: Colors.white,
            padding: const EdgeInsets.all(8),
            shape: const CircleBorder(),
            child: const Icon(
              Icons.check,
              size: 35,
            ),
          ),
        ],
      ),
      child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.lightGreen[200],
          ),
          child: const ListTile(
            title: Text('밥 먹기',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18)),
          )),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    /// Paints the whole canvas white
    canvas.drawPaint(Paint()..color = Colors.white);

    /// Translate method shifts the coordinate of the canvas, in this case we are shifting
    /// the point of origin to the top-center of  the canvas
    canvas.translate(size.width / 2, 0);

    final width = size.width / 2;

    Path bezierPath = Path()
      ..moveTo(-width, size.height)
      ..lineTo(-width, (size.height) * 0.2)
      ..cubicTo(
        -width * 0.4,
        (size.height - 150) * 0.4,
        0.3,
        (size.height) * 0.7,
        width,
        (size.height - 180) * 0.8,
      )
      ..lineTo(width, size.height);

    final bezierPaint = Paint()
      ..shader = LinearGradient(colors: [
        Colors.blue[200]!,
        Colors.green[200]!,
      ]).createShader(Offset(-width, size.height) & size);

    // y axis mirror
    canvas.scale(1, -1);
    canvas.translate(0, -size.height);

    canvas.drawPath(bezierPath, bezierPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
