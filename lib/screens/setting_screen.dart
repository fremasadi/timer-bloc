import 'package:flutter/material.dart';
import 'package:timer_app/constants/app_colors.dart';
import 'package:timer_app/screens/widgets/horizontal_card.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            size: 28,
            color: AppColors.white,
          ),
        ),
        centerTitle: true,
        title: Text(
          'Setting',
          style: TextStyle(
            fontSize: 22,
            color: AppColors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              HorizontalCard(
                title: 'Bunyi Timer',
                subTitle: Text(
                  'TImer Berakhir',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                ),
              ),
              HorizontalCard(
                title: 'Keraskan volume secara bertahap',
                subTitle: Text(
                  'Tidak pernah',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.white,
                  ),
                ),
              ),
              HorizontalCard(
                title: 'Timer Bergetar',
                subTitle: ToggleSwitch(
                  customWidths: [90.0, 50.0],
                  cornerRadius: 20.0,
                  activeBgColors: [
                    [Colors.cyan],
                    [Colors.redAccent]
                  ],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  labels: ['YES', ''],
                  icons: [null, Icons.clear],
                  onToggle: (index) {
                    print('switched to: $index');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
