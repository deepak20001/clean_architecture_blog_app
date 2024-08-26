part of 'app_user_cubit.dart';

@immutable
sealed class AppUserState {
  const AppUserState();
}

/// this state shows that a user is logged-out
final class AppUserInitial extends AppUserState {}

final class AppUserLoggedIn extends AppUserState {
  final User user;
  const AppUserLoggedIn(this.user);
}
