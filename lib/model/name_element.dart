//S, O, D - principles
class NameElement {
  final String textName;

  NameElement({
     this.textName = '',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NameElement && runtimeType == other.runtimeType && textName == other.textName;

  @override
  int get hashCode => textName.hashCode;

  NameElement copyWith({
    String? textName,
  }) {
    return NameElement(
      textName: textName ?? this.textName,
    );
  }
}
