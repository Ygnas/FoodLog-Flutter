import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:food_log/src/models/listing.dart';
import 'package:food_log/src/providers/listing_provider.dart';
import 'package:food_log/src/providers/notification_provider.dart';
import 'package:food_log/src/providers/user_provider.dart';
import 'package:food_log/src/widgets/listing_bar_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import 'package:background_fetch/background_fetch.dart';

late List<BarChartGroupData> barGroups;

@pragma('vm:entry-point')
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    // print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  // print('[BackgroundFetch] Headless event received.');
  showNotification();
  BackgroundFetch.finish(taskId);
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  late int maxItemCount = 0;

  bool _enabled = true;
  final List<DateTime> _events = [];

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    initPlatformState();
    NotificationService().init();
    NotificationService().initializeNotificationChannels();
    readNotificationSetting().then((value) {
      setState(() {
        _enabled = value;
        if (value) {
          NotificationService().showNotificationDaily();
        } else {
          NotificationService().cancelAllNotifications();
        }
      });
    });
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

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 1450,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            startOnBoot: true,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      // <-- Event handler
      showNotification();
      // This is the fetch-event callback.
      // print("[BackgroundFetch] Event received $taskId");
      setState(() {
        _events.insert(0, DateTime.now());
      });
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      // print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    // print('[BackgroundFetch] configure success: $status');
    setState(() {});

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void _onClickEnable(enabled) {
    setState(() {
      _enabled = enabled;
      saveNotificationSetting(enabled);
    });
    if (enabled) {
      BackgroundFetch.start().then((int status) {
        // print('[BackgroundFetch] start success: $status');
      }).catchError((e) {
        // print('[BackgroundFetch] start FAILURE: $e');
      });
    } else {
      BackgroundFetch.stop().then((int status) {
        // print('[BackgroundFetch] stop success: $status');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    int totalSnacks = rawBarGroups.fold(
        0, (sum, group) => sum + group.barRods[0].toY.toInt());
    int totalOthers = rawBarGroups.fold(
        0, (sum, group) => sum + group.barRods[1].toY.toInt());

    double progressSnacks = totalSnacks / 7;
    double progressOthers = totalOthers / 21;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.account_circle_rounded,
                  size: 100,
                ),
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          strokeWidth: 8,
                          value: progressSnacks,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          strokeWidth: 8,
                          value: progressOthers,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
          const SizedBox(height: 20),
          const Divider(),
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
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListingBarChart(
                      maxItemCount: maxItemCount,
                      showingBarGroups: showingBarGroups,
                      bottomTitles: bottomTitles),
                ],
              ),
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SwitchListTile(
                  title: const Text(
                    'Food Log reminder:',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  value: _enabled,
                  onChanged: _onClickEnable,
                ),
              ),
              const SizedBox(height: 8.0),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              userProvider.logout();
              context.go('/login');
            },
            child: const Text(
              'Logout',
              style: TextStyle(fontSize: 20, color: Colors.red),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Account Deletion'),
                    content: const Text(
                        'Are you sure you want to delete your account?\nThis action cannot be undone.',
                        style: TextStyle(color: Colors.red)),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          userProvider.deleteAccount();
                          userProvider.logout();
                          context.go('/login');
                        },
                        child: const Text('Delete',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Delete Account',
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

void saveNotificationSetting(bool enabled) async {
  const storage = FlutterSecureStorage();
  await storage.write(key: "notification", value: enabled.toString());
}

Future<bool> readNotificationSetting() async {
  const storage = FlutterSecureStorage();
  final setting = await storage.read(key: "notification");
  return setting?.toLowerCase() == 'true' ? true : false;
}

void showNotification() async {
  await NotificationService().init();
  await NotificationService().initializeNotificationChannels();
  await NotificationService().showNotifications();
}
