import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_log_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// What is Dependency Injection?
/// Dependency injection is a technique whereby one object supplies the dependencies of another object.
/// A “dependency” here refers to any external resource or service a class needs to perform its function,
/// such as a database connection, a REST API, shared preferences, or another class.
/// DI involves providing these dependencies from the outside, making your components more decoupled, maintainable, and flexible.

/// Why Use Dependency Injection in Flutter?
/// Testability: DI makes it easier to replace actual implementations with mock or test implementations,
/// facilitating unit testing without relying on real resources.
/// Decoupling: It promotes the separation of concerns by decoupling the creation of an object from the behavior of its dependencies,
/// leading to more modular and maintainable code.
/// Flexibility: With DI, switching between different implementations of a dependency
/// (e.g., swapping out database providers) can be done with minimal code changes in the dependent classes.

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  /// this will create a single instance of this dependency throughout the life of app
  serviceLocator.registerLazySingleton(() => supabase.client);

  _initAuth();
}

/// In the code provided, the principle of "depend on interface, not on implementation" (also known as Dependency Inversion Principle) is followed,
/// by using abstract classes or interfaces as the primary means of interaction in the business logic.
/// This is evident in the use of the AuthRemoteDataSource interface and AuthRepository interface,
/// which decouple the higher-level logic (like the AuthBloc and UserSignUp classes) from the specific details of how the underlying data operations are implemented.
///
/// How the Principle is Followed ?
/// Interface Definition:
/// The AuthRemoteDataSource and AuthRepository would typically be defined as abstract classes or interfaces,
/// specifying the contract (methods) that any implementation must follow.
/// This allows your business logic to rely on these contracts rather than the specific implementations.
///
/// Implementation Classes:
/// AuthRemoteDataSourceImpl and AuthRepositoryImpl are concrete classes that implement these interfaces.
/// They provide the actual implementation details (e.g., interacting with Supabase).
///
/// Dependency Injection:
/// In the main() function, AuthRemoteDataSourceImpl and AuthRepositoryImpl are instantiated and passed into higher-level components (UserSignUp, AuthBloc).
/// These components rely on the interfaces rather than the concrete implementations, even though in this specific instance,
/// the implementation is being passed directly.
///
/// if you want to switch to a different backend (e.g., Firebase), you only need to create new classes that implement the same interfaces (AuthRemoteDataSource and AuthRepository).
/// Then, you can replace AuthRemoteDataSourceImpl with a FirebaseAuthRemoteDataSource implementation without modifying the business logic that depends on the interface.
void _initAuth() {
  // Data-source
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator<SupabaseClient>(),
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator<AuthRemoteDataSource>(),
      ),
    )
    // Use-cases
    ..registerFactory(
      () => UserSignUp(
        serviceLocator<AuthRepository>(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator<AuthRepository>(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator<AuthRepository>(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator<UserSignUp>(),
        userLogin: serviceLocator<UserLogin>(),
        currentUser: serviceLocator<CurrentUser>(),
      ),
    );
}
