import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cash_droid/theme/colors.dart';
import 'package:cash_droid/pages/daily_page.dart';
import 'package:cash_droid/pages/stats_page.dart';
import 'package:cash_droid/pages/profile_page.dart';
import 'package:cash_droid/pages/newentry_page.dart';
import 'package:cash_droid/scoped_model/expenseScope.dart';
import 'package:animations/animations.dart';
import 'package:ionicons/ionicons.dart';


class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int pageIndex = 0;
  PageController controller = PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<ExpenseModel>(
        builder: (context, child, model) => PageView(
          controller: controller,
          children: [
            DailyPage(key: UniqueKey()),
            StatsPage(),
            ProfilePage(),
          ],
          onPageChanged: (val) {
            setState(() {
              pageIndex = val;
            });
          },
          physics: ClampingScrollPhysics(),
        ),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeColor: myColors[pageIndex][0],
        splashColor: myColors[pageIndex][1],
        inactiveColor: Colors.black.withOpacity(0.5),
        icons: <IconData>[
          Ionicons.calendar_outline,
          Ionicons.stats_chart,
          Ionicons.settings,
        ],
        activeIndex: pageIndex,
        notchSmoothness: NotchSmoothness.softEdge,
        iconSize: 30,
        onTap: (index) {
          setState(() {
            pageIndex = index;
            controller.animateToPage(
              pageIndex,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
      floatingActionButton: OpenContainer(
        transitionType: ContainerTransitionType.fadeThrough,
        openBuilder: (BuildContext context, _) => NewEntryLog(),
        closedElevation: 5.0,
        openElevation: 0,
        closedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
        closedColor: Colors.pink,
        closedBuilder: (_, __) => SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  callback(int index) {
    setState(() {
      pageIndex = index;
      controller.animateToPage(
        pageIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }
}
