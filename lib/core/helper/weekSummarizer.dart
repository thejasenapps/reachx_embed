
class WeekSummarizer {

  List<String> summarizeWeekdays(List<dynamic> days, int flag) {

    const weekOrder = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];


    const shortNames = {
      'sunday': 'Sun',
      'monday': 'Mon',
      'tuesday': 'Tue',
      'wednesday': 'Wed',
      'thursday': 'Thu',
      'friday': 'Fri',
      'saturday': 'Sat',
    };

    const longNames = {
      'sunday': 'Sunday',
      'monday': 'Monday',
      'tuesday': 'Tuesday',
      'wednesday': 'Wednesday',
      'thursday': 'Thursday',
      'friday': 'Friday',
      'saturday': 'Saturday',
    };

    final normalized = days.map((day) => day.toLowerCase());

    final indices = weekOrder
          .asMap()
          .entries
          .where((entry) => normalized.contains(entry.value))
          .map((entry) => entry.key)
          .toList();

    indices.sort();

    List<String> result = [];
    int start = indices.first;
    int prev = start;

    final names = flag == 0 ? shortNames : longNames;

    for(int i = 1; i < indices.length; i++) {
      if (indices[i] != prev + 1) {
        result.add(_formatRange(weekOrder, names, start, prev));
        start = indices[i];
      }
      prev = indices[i];
    }

    result.add(_formatRange(weekOrder, names, start, prev));

    return result;
  }


  String _formatRange(List<String> weekOrder, Map<String, String> shortNames, int start, int end) {
    if(start == end) {
      return shortNames[weekOrder[start]]!;
    }

    return '${shortNames[weekOrder[start]]} - ${shortNames[weekOrder[end]]}';
  }
}