import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  /// not using fp-dart here as in remote data-source we are only concerned calls made to external data-base,
  /// we don't want any other packages/plugins inside of it.
  Future<String> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<String> loginWithEmailPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// here we are injecting the supabaseClient whenever this class is called, means we are following dependency injection,
  /// so it won't cause a dependency b/w AuthRemoteDataSourceImpl & supabase client
  /// so we can switch to any other database in future easily.
  final SupabaseClient supabaseClient;
  const AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<String> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<String> signUpWithEmailPassword({
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
      return response.user!.id;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
