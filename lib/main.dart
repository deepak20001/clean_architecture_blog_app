import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  runApp(MultiBlocProvider(
    providers: [
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
      BlocProvider(
        create: (_) => AuthBloc(
          userSignUp: UserSignUp(
            AuthRepositoryImpl(
              AuthRemoteDataSourceImpl(supabase.client),
            ),
          ),
        ),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constants.appName,
      theme: AppTheme.darkThemeMode,
      home: const LoginPage(),
    );
  }
}
