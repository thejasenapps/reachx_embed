class RatingLogic {

  double weightedAverageRating(double newRating, averageRating, int count) {
    double result = (newRating + averageRating * count)/(count + 1);
    return result;
  }

}

