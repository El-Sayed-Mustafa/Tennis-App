import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:tennis_app/Main-Features/Featured/event_calender/widgets/daily_calendar.dart';
import 'package:tennis_app/Main-Features/Featured/event_calender/widgets/day_crausal.dart';
import 'package:tennis_app/Main-Features/Featured/event_calender/widgets/weekly_calendar.dart';
import 'package:tennis_app/Main-Features/Featured/event_calender/widgets/tab_bar_with_indicator.dart';
import 'package:tennis_app/Main-Features/Featured/event_calender/widgets/schedule_calendar.dart';

import '../../../core/utils/widgets/app_bar_wave.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  DateTime selectedDay = DateTime.now();
  CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController(initialPage: selectedDay.day - 1);
    _pageController.addListener(_onPageChange);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChange() {
    setState(() {
      selectedDay = DateTime.now()
          .subtract(Duration(days: DateTime.now().day - 1))
          .add(Duration(days: _pageController.page!.toInt()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    List<Appointment> appointments = [
      // Add your actual data here
      Appointment(
        startTime: DateTime.now().add(Duration(hours: 2)),
        endTime: DateTime.now().add(Duration(hours: 7)),
        subject: 'Meeting with Client',
        color: Colors.blue,
      ),
      Appointment(
        startTime: DateTime.now().add(Duration(hours: 5)),
        endTime: DateTime.now().add(Duration(hours: 8)),
        subject: 'Lunch Break',
        color: Colors.green,
      ),
      Appointment(
        startTime: DateTime.now().add(Duration(hours: 9)),
        endTime: DateTime.now().add(Duration(hours: 12)),
        subject: 'Project Discussion',
        color: Colors.orange,
      ),
    ];
    return Scaffold(
      body: Column(
        children: [
          AppBarWaveHome(
            prefixIcon: IconButton(
              onPressed: () {
                GoRouter.of(context).replace('/home');
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.white,
              ),
            ),
            text: '   Event Calender',
            suffixIconPath: '',
          ),
          DayCarousel(
            carouselController: _carouselController,
            selectedDay: selectedDay.day,
            onDayTap: (index) {
              _carouselController.animateToPage(index);
            },
          ),
          TabBarWithIndicator(
            tabController: _tabController,
            tabs: ['Daily', 'Schedule', 'Weekly'],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                DailyCalendar(appointments),
                ScheduleCalendar(appointments),
                MonthlyCalendar(appointments),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
