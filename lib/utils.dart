DateTime parseDate(datetime) {
  return DateTime.parse(datetime);
}

dateToString(datetime) {
  return parseDate(datetime).toString();
}

String daysLeft(datetime) {
  return parseDate(datetime).difference(DateTime.now()).inDays.toString();
}