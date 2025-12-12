import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_service.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

/// Data transfer object for User
@JsonSerializable(fieldRename: FieldRename.snake)
class UserDto {
  const UserDto({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
  });

  final String id;
  final String email;
  final String name;
  final String? avatar;

  /// Creates a UserDto from JSON
  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  /// Converts this UserDto to JSON
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  /// Converts this DTO to domain model
  User toDomain() {
    return User(
      id: id,
      email: email,
      name: name,
      avatar: avatar,
    );
  }

  /// Creates a DTO from domain model
  factory UserDto.fromDomain(User user) {
    return UserDto(
      id: user.id,
      email: user.email,
      name: user.name,
      avatar: user.avatar,
    );
  }
}

/// Login response DTO
@JsonSerializable(fieldRename: FieldRename.snake)
class LoginResponseDto {
  const LoginResponseDto({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  final UserDto user;
  final String accessToken;
  final String refreshToken;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseDtoToJson(this);
}
