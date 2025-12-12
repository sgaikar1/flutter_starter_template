/// User domain model
class User {
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
  });

  final String id;
  final String email;
  final String name;
  final String? avatar;

  @override
  String toString() => 'User(id: $id, email: $email, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name;

  @override
  int get hashCode => Object.hash(id, email, name);
}
