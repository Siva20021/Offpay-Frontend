import 'package:flutter/material.dart';

class OnboardingContents {
  final String title;
  final String image;

  OnboardingContents(
      {required this.title, required this.image});
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Track Your work and get the result",
    image: "assets/images/image1.png"
  ),
  OnboardingContents(
    title: "Stay organized with team",
    image: "assets/images/image2.png"
  ),
  OnboardingContents(
    title: "Get notified when work happens",
    image: "assets/images/image3.png"
  ),
];