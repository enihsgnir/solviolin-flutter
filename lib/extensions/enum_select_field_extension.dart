// TODO: refactor and apply this to enum select fields
extension EnumSelectFieldExtension<T extends Enum> on Map<T, bool> {
  bool of(T key) => this[key] ?? false;

  void toggle(T key) => this[key] = !of(key);

  bool get all => keys.every(of);

  void select(T key) {}

  void multiSelect(T key) {}
}
