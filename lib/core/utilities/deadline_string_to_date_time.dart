DateTime? deadlineStringToDateTime(String input) {
  final now = DateTime.now();
  switch (input) {
    case 'Next 30min':
      return now.add(Duration(minutes: 30));
    case 'Next 45min':
      return now.add(Duration(minutes: 45));
    case 'Next 1hr':
      return now.add(Duration(hours: 1));
    case 'Next 1.5hrs':
      return now.add(Duration(minutes: 90));
    case 'Next 2hrs':
      return now.add(Duration(hours: 2));
    default:
      return null;
  }
}
