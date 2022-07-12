class HashFunction {
  int index;
  String label;
  HashFunction({
    required this.index,
    required this.label,
  });

  @override
  String toString() => label;

  int value() => index;
}
