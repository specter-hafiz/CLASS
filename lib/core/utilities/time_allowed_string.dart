String? timeAllowedString(String input) {
  switch (input) {
    case '30mins':
      return '30';
    case '45mins':
      return '45';
    case '1hr':
      return '60';
    case '1.5hrs':
      return '90'; // 1hr 30min
    case '2hrs':
      return '120';
    default:
      return null;
  }
}
