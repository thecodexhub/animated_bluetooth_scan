import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Animated Bluetooth Scan',
      debugShowCheckedModeBanner: false,
      home: ScannerScreen(),
    );
  }
}

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  var text = "TAP TO SCAN";
  bool isScanning = false;

  Animation<double> _scaleAnimation;
  Animation<double> _widthAnimation;
  Animation<double> _opacityAnimation;
  Animation<Color> _colorAnimation;
  Animation<double> _containerAnimation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 3000))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _controller.repeat();
            }
          });
    _scaleAnimation = Tween(begin: 100.0, end: 350.0).animate(_controller);
    _widthAnimation = Tween(begin: 2.5, end: 10.0).animate(_controller);
    _opacityAnimation = Tween(begin: 1.0, end: 0.1).animate(_controller);
    _colorAnimation =
        ColorTween(begin: Colors.white, end: Colors.lightBlue[100]).animate(
            CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.6)));
    _containerAnimation = Tween(begin: 0.0, end: 100.0).animate(
        CurvedAnimation(parent: _controller, curve: Interval(0.6, 1.0)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
            Center(
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: Container(
                  height: _scaleAnimation.value,
                  width: _scaleAnimation.value,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: _widthAnimation.value,
                      )),
                ),
              ),
            ),
            Center(
              child: Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _colorAnimation.value,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white.withOpacity(0.4),
                          offset: Offset(-6.0, -6.0),
                          blurRadius: 16.0),
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: Offset(6.0, 6.0),
                          blurRadius: 16.0)
                    ]),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                          height: _containerAnimation.value,
                          width: _containerAnimation.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          )),
                    ),
                    Center(
                      child: Icon(
                        Icons.bluetooth,
                        size: 35.0,
                        color: Colors.blue[900],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0.0,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isScanning = !isScanning;
                    if (isScanning) text = "CANCEL";
                    if (!isScanning) text = "TAP TO SCAN";
                  });
                  if (isScanning) _controller.forward();
                  if (!isScanning) _controller.reset();
                },
                child: Container(
                  height: 80.0,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
