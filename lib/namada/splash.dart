import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namadaapp/namada/menu.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Color textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyListWidget()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/icon.png',
                  height: 200,
                  width: 200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MouseRegion(
                onEnter: (PointerEvent details) {
                  setState(() {
                    textColor =
                        Colors.blue; // Change to your desired hover color
                  });
                },
                onExit: (PointerEvent details) {
                  setState(() {
                    textColor = Colors.black;
                  });
                },
                child: InkWell(
                  onTap: () => Clipboard.setData(const ClipboardData(
                    text:
                        'tpknam1qzr84ydtsd2zg28k62qwds37x446pjy3zcsmwy5rcfdhejuwdezm72gaccy',
                  )),
                  child: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Colors.red,
                        Colors.orange,
                        Colors.yellow,
                        Colors.green,
                        Colors.blue,
                        Colors.indigo,
                        Colors.purple
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      tileMode: TileMode.mirror,
                    ).createShader(bounds),
                    child: const Text(
                      'tpknam1qzr84ydtsd2zg28k62qwds37x446pjy3zcsmwy5rcfdhejuwdezm72gaccy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
