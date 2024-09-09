import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  /// not using fp-dart here as in remote data-source we are only concerned calls made to external data-base,
  /// we don't want any other packages/plugins inside of it.
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// here we are injecting the supabaseClient whenever this class is called, means we are following dependency injection,
  /// so it won't cause a dependency b/w AuthRemoteDataSourceImpl & supabase client
  /// so we can switch to any other database in future easily.
  final SupabaseClient supabaseClient;
  const AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw ServerException(message: Constants.userIsNull);
      }
      return UserModel.fromJson(response.user!.toJson()).copyWith(
        email: currentUserSession!.user.email,
      );
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {
          'name': name,
        },
      );
      if (response.user == null) {
        throw ServerException(message: Constants.userIsNull);
      }
      return UserModel.fromJson(response.user!.toJson()).copyWith(
        email: currentUserSession!.user.email,
      );
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        /// The data i will get is in list form having data
        /// [{...}, {...}, {...}, {...}]
        final userData = await supabaseClient.from('profiles').select().eq(
              'id',
              currentUserSession!.user.id,
            );

        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
        );
      }
      return null;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
