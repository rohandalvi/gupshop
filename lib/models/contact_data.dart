class DummyContact {
  final  List phoneNumbers;
  final String name;
  final String email;

  DummyContact({
    this.phoneNumbers,
    this.name,
    this.email
  });

  @override
  String toString() {
    // TODO: implement toString
    return name;
  }
}