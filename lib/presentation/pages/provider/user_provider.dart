import 'package:flutter_princess/data/data_source/auth_data_source.dart';
import 'package:flutter_princess/data/data_source/auth_data_source_impl.dart';
import 'package:flutter_princess/data/data_source/user_data_source.dart';
import 'package:flutter_princess/data/data_source/user_data_source_impl.dart';
import 'package:flutter_princess/data/repository/auth_repository_impl.dart';
import 'package:flutter_princess/data/repository/user_repository_impl.dart';
import 'package:flutter_princess/domain/repository/auth_repository.dart';
import 'package:flutter_princess/domain/repository/user_repository.dart';
import 'package:flutter_princess/domain/usecase/edit_profile_usercase.dart';
import 'package:flutter_princess/domain/usecase/email_login_usecase.dart';
import 'package:flutter_princess/domain/usecase/email_signup_usecase.dart';
import 'package:flutter_princess/domain/usecase/fetch_user_usecase.dart';
import 'package:flutter_princess/domain/usecase/google_login_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//user
final _userDataSourceProvider = Provider<UserDataSource>((ref) {
  return UserDataSourceImpl();
});
final _userRepositoryProvider = Provider<UserRepository>((ref) {
  final dataSource = ref.read(_userDataSourceProvider);
  return UserRepositoryImpl(dataSource);
});

final fetchUserusecaseProvider = Provider((ref) {
  final userRepository = ref.read(_userRepositoryProvider);
  return FetchUserUsecase(userRepository);
});

final emailSignupusecaseProvider = Provider((ref) {
  final userRepository = ref.read(_userRepositoryProvider);
  return EmailSignupUsecase(userRepository);
});

final editProfileUsecaseProvider = Provider((ref) {
  final userRepository = ref.read(_userRepositoryProvider);
  return EditProfileUsecase(userRepository);
});

//user auth
final _authDataSourceProvider = Provider<AuthDataSource>((ref) {
  return AuthDataSourceImpl();
});

final _authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.read(_authDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

final emailLoginUsecaseProvider = Provider((ref) {
  final authRepository = ref.read(_authRepositoryProvider);
  return EmailLoginUsecase(authRepository);
});

final googleLoginUsecaseProvider = Provider((ref) {
  final authRepository = ref.read(_authRepositoryProvider);
  return GoogleLoginUsecaseImpl(authRepository);
});
