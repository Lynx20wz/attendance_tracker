extension IsSameDay on DateTime {
  bool isSameDay(final DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
