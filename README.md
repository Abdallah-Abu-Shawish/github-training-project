# Orders Manager

Orders Manager is a Flutter app for managing simple product orders. The app lets the user add orders, select the orders that should be completed, and keep a separate list of completed orders.

I worked on this project as part of my Git and GitHub training assignment. The main goal was to practice a real workflow: local commits, a feature branch, a pull request, and a clean project structure.

Repository:
https://github.com/Abdallah-Abu-Shawish/github-training-project

## Features

- Add a product order with a name and quantity
- Validate order input before saving
- Show active orders in a list
- Select and unselect orders
- Complete selected orders
- View completed orders separately
- Delete orders with a confirmation dialog
- Show helpful empty states when there are no orders
- Handle loading errors with a retry button

## Technologies

- Flutter
- Dart
- GetX for state management
- SQLite database using `sqflite`
- Git and GitHub

## Project Structure

```text
lib/
  controllers/
    order_controller.dart
  database/
    db_helper.dart
  models/
    order_model.dart
  views/
    complete_screen.dart
    home_screen.dart
    list_screen.dart
    selected_screen.dart
    splash_screen.dart
    widgets/
```

The controller contains the order state and main app logic. The database folder has the SQLite helper, the model folder has the order data model, and the views folder contains the screens and reusable widgets.

## Screenshots

Screenshots should be placed inside a folder named `screenshots`.

Suggested files:

```text
screenshots/
  list_screen.png
  selected_screen.png
  completed_screen.png
  design_update.png
```

After adding the images, they can be shown in this section like this:

```md
![List Screen](screenshots/list_screen.png)
![Selected Screen](screenshots/selected_screen.png)
![Completed Screen](screenshots/completed_screen.png)
```

## How to Run the Project

1. Clone the repository:

```bash
git clone https://github.com/Abdallah-Abu-Shawish/github-training-project.git
```

2. Open the project folder:

```bash
cd github-training-project
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the app:

```bash
flutter run
```

## Git Workflow Used

I used `master` for the main project work and created a separate branch for the design update:

```text
feature/design-update
```

The design branch includes the BottomNavigationBar improvement only. The plan is to push both branches to GitHub, open a pull request from `feature/design-update` into `master`, and merge it from GitHub after review.

## Student

Abdallah Abu Shawish
