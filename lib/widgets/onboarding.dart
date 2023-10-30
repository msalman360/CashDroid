import 'package:cash_droid/main.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';


class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
        title: "Welcome to Cash Droid",
        description: "Keep track of your finances easily.",
        pathImage: "assets/images/wallet1.png", // Replace with your image
      ),
    );

    slides.add(
      Slide(
        title: "Manage Accounts",
        description: "Add and manage your financial accounts.",
        pathImage: "assets/images/wallet2.png", // Replace with your image
      ),
    );

    slides.add(
      Slide(
        title: "Track Expenses and Incomes",
        description: "Log your expenses and incomes effortlessly.",
        pathImage: "assets/images/wallet3.png", // Replace with your image
      ),
    );

    slides.add(
      Slide(
        title: "Analyze Your Finances",
        description: "Visualize your financial data with charts.",
        pathImage: "assets/images/wallet4.png", // Replace with your image
      ),
    );
  }

  void onDonePress() {
    // Navigate to the HomeScreen when the user taps "Get Started"
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BudgetApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        child: IntroSlider(
          slides: slides,
          onDonePress: onDonePress,
        ), // Set the background color here
      ),
    );
  }
}
