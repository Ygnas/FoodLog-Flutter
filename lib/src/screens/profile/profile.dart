import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:food_log/src/models/listing.dart';
import 'package:food_log/src/providers/listing_provider.dart';
import 'package:food_log/src/providers/user_provider.dart';
import 'package:food_log/src/widgets/listing_bar_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

late List<BarChartGroupData> barGroups;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  late int maxItemCount = 0;

  @override
  void initState() {
    super.initState();
    final listingProvider = context.read<ListingProvider>();
    listingProvider.loadListings();
    if (listingProvider.listings.isNotEmpty) {
      rawBarGroups = barChartWeekData(listingProvider.listings);
      showingBarGroups = rawBarGroups;

      for (var groupData in showingBarGroups) {
        for (var rodData in groupData.barRods) {
          maxItemCount = max(maxItemCount, rodData.toY.toInt());
        }
      }
    } else {
      rawBarGroups = [];
      showingBarGroups = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Icon(
              Icons.account_circle_rounded,
              size: 100,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Name: ${userProvider.user.name}',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(
            'Email: ${userProvider.user.email}',
            style: const TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                legendItem('Snacks', Colors.blue),
                const SizedBox(width: 20),
                legendItem('Other', Colors.red),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ListingBarChart(
              maxItemCount: maxItemCount,
              showingBarGroups: showingBarGroups,
              bottomTitles: bottomTitles),
          const Spacer(),
          GestureDetector(
            onTap: () {
              userProvider.logout();
              context.go('/login');
            },
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<BarChartGroupData> barChartWeekData(List<Listing> listings) {
  List<BarChartGroupData> weekData = [];

  DateTime now = DateTime.now();
  DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1)).subtract(
      Duration(hours: now.hour, minutes: now.minute, seconds: now.second));

  for (int i = 0; i < 7; i++) {
    DateTime currentDay = startOfWeek.add(Duration(days: i));
    List<Listing> listingsThisDay = listings
        .where((listing) =>
            listing.createdAt!.isAfter(currentDay) &&
            listing.createdAt!
                .isBefore(currentDay.add(const Duration(days: 1))))
        .toList();
    int snackCount = listingsThisDay
        .where((listing) => listing.type == ListingType.snack)
        .length;
    int dinnerCount = listingsThisDay
        .where((listing) => listing.type != ListingType.snack)
        .length;
    weekData
        .add(makeGroupData(i, snackCount.toDouble(), dinnerCount.toDouble()));
  }

  return weekData;
}

const double width = 7;

BarChartGroupData makeGroupData(int x, double y1, double y2) {
  return BarChartGroupData(
    barsSpace: 4,
    x: x,
    barRods: [
      BarChartRodData(
        toY: y1,
        color: Colors.blue,
        width: width,
      ),
      BarChartRodData(
        toY: y2,
        color: Colors.red,
        width: width,
      ),
    ],
  );
}

Widget bottomTitles(double value, TitleMeta meta) {
  final titles = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final Widget text = Text(
    titles[value.toInt()],
    style: const TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
  );

  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 16,
    child: text,
  );
}

Widget legendItem(String name, Color color) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 12,
        height: 12,
        color: color,
        margin: const EdgeInsets.only(right: 4),
      ),
      Text(
        name,
        style: const TextStyle(fontSize: 12),
      ),
    ],
  );
}
