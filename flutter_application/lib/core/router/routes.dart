enum Routes {
  initial(
    name: "initial",
    path: "/",
  ),
  login(
    name: "login",
    path: "/login",
  ),
  home(
    name: "home",
    path: "/home",
  ),
  settings(
    name: "settings",
    path: "/settings",
  ),
  changeEmailAddress(
    name: "changeEmailAddress",
    path: "/changeEmailAddress",
  ),
  themeMode(
    name: "themeMode",
    path: "/themeMode",
  ),
  onboarding(
    name: "onboarding",
    path: "/onboarding",
  ),
  profile(
    name: "profile",
    path: "/profile",
  ),
  progress(
    name: "progress",
    path: "/progress",
  ),
  foodSearchTest(
    name: "foodSearchTest",
    path: "/food-search-test",
  ),
  mealTracking(
    name: "mealTracking",
    path: "/meal-tracking",
  ),
  exercises(
    name: "exercises",
    path: "/exercises",
  ),
  mealPlan(
    name: "mealPlan",
    path: "/meal-plan",
  );

  const Routes({
    required this.path,
    required this.name,
  });

  final String path;
  final String name;
}
