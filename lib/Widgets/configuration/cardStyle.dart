enum CardStyle { SIMPLE, DEFAULT }

class HashPassCardStyle {
  CardStyle style;
  HashPassCardStyle({
    required this.style,
  });

  static final List<HashPassCardStyle> values = CardStyle.values.map((style) => HashPassCardStyle(style: style)).toList();

  @override
  String toString() {
    switch (style) {
      case CardStyle.SIMPLE:
        return "Simples";
      case CardStyle.DEFAULT:
        return "Padrão";
    }
  }
}
