import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timer_app/constants/app_colors.dart';
import 'package:timer_app/screens/result_screen.dart';

import '../blocs/bloc_event.dart';
import '../blocs/timer_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String input = '';

  void _handleNumpadInput(String value) {
    setState(() {
      if (input.length < 6) {
        input += value; // Menambah input ke string
      }
    });
  }

  void _handleDeleteInput() {
    setState(() {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1); // Menghapus satu karakter
      }
    });
  }

  String get hours {
    if (input.length <= 4) return '0';
    return input.substring(0, input.length - 4);
  }

  String get minutes {
    if (input.length <= 2) return '0';
    return input.length == 3
        ? '0${input.substring(0, 1)}'
        : input.substring(input.length - 4, input.length - 2);
  }

  String get seconds {
    if (input.isEmpty) return '0';
    return input.length == 1
        ? '0${input.substring(input.length - 1)}'
        : input.substring(input.length - 2);
  }

  void clearInput() {
    setState(() {
      input = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: Text(
          'FreTimer',
          style: TextStyle(
            fontSize: 22,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: hours,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                        text: 'j',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                RichText(
                  text: TextSpan(
                    text: minutes,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                        text: 'm',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                RichText(
                  text: TextSpan(
                    text: seconds,
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                        text: 'd',
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48.0),
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: 12,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                itemBuilder: (context, index) {
                  if (index < 9) {
                    return _buildNumpadButton((index + 1).toString());
                  } else if (index == 9) {
                    return _buildNumpadButton('00');
                  } else if (index == 10) {
                    return _buildNumpadButton('0');
                  } else {
                    return _buildDeleteButton();
                  }
                },
              ),
            ),
            if (input.isNotEmpty)
              Container(
                padding: EdgeInsets.all(22),
                margin: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.greenAccent,
                ),
                child: IconButton(
                  onPressed: () {
                    int totalSeconds = (int.parse(hours) * 3600) +
                        (int.parse(minutes) * 60) +
                        int.parse(seconds);

                    context.read<TimerBloc>().add(TimerStarted(totalSeconds));

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResultScreen()),
                    );
                    clearInput();
                  },
                  icon: Icon(
                    Icons.play_arrow,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumpadButton(String text) {
    return GestureDetector(
      onTap: () => _handleNumpadInput(text),
      child: Container(
        margin: const EdgeInsets.all(4), // Jarak antara tombol
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(12), // Radius sudut tombol
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Posisi shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white, // Warna teks
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return GestureDetector(
      onTap: _handleDeleteInput, // Menghapus input ketika tombol ditekan
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.backspace, // Ikon hapus
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
