int periodToIndex(int i) {
  switch (i) {
    case (2):
      return 0;
    case (5):
      return 1;
    case (10):
      return 2;
    case (25):
      return 3;
    default:
      return 0;
  }
}
