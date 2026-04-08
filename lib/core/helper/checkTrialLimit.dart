
class CheckTrial {
  bool trialLimitFunction(DateTime startTime, int trialLimit)  {
    final DateTime now = DateTime.now();
    final int differenceInDays = now.difference(startTime).inDays;
    return differenceInDays <= trialLimit;
  }
}