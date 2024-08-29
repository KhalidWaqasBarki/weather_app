import 'package:flutter/material.dart';

class ForecastCard extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;
  final Color? iconColor;
  const ForecastCard({
    required this.time,
    required this.temperature,
    super.key, required this.icon, this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
color: Colors.blueGrey[500],
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  time,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17,color: Colors.white),
                ),
                Icon(
                  icon,
                  size: 35,
                  color: iconColor
                ),
                Text(
                  temperature,
                  style: const TextStyle(fontSize: 16,color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class AdditionalInfo extends StatelessWidget {

  final IconData icon;
  final String forecast;
  final String value;
  const AdditionalInfo({
    super.key, required this.icon, required this.forecast, required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          Icon(
           icon,
            size: 30,
          ),
          const SizedBox(height: 5),
          Text(
            forecast,
            style: const TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 5),
          Text(value,
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}




