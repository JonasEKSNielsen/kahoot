import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/custom_image_button.dart';
import 'my_page_bloc.dart';
import 'my_page_events_states.dart';
import '../../widgets/default_scaffold.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  
  Future<void> selected(String value) async {
    switch (value) {
      case 'mypage':
        // Navigate to My Page
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyPageBloc(),
      child: BlocBuilder<MyPageBloc, MyPageState>(
        builder: (context, state) => DefaultScaffold(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (state is NotLoginState)
                  _buildLoginState(context, state),
                
                if (state is GoogleLoginLoadingState)
                  _buildLoadingState(),
                
                if (state is LoginSuccessState)
                  _buildLoginSuccessState(context, state),
                
                if (state is LoginErrorState)
                  _buildErrorState(context, state),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 20),
        const Text(
          'Signing in...',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildLoginSuccessState(BuildContext context, LoginSuccessState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Login Successful!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          'Email: ${state.email}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          'Name: ${state.name}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          'User ID: ${state.oauthResponse.user.id}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          'Role: ${state.oauthResponse.user.role}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          onPressed: () {
            context.read<MyPageBloc>().add(const SignOutEvent());
          },
          icon: const Icon(Icons.logout),
          label: const Text('Sign Out'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, LoginErrorState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Login Failed',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
        ),
        const SizedBox(height: 20),
        Text(
          state.message,
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            context.read<MyPageBloc>().add(const GoogleLoginEvent());
          },
          child: const Text('Try Again'),
        ),
      ],
    );
  }

  Widget _buildLoginState(BuildContext context, NotLoginState state) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Email/Username',
          ),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Password',
          ),
          obscureText: true,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            context.read<MyPageBloc>().add(LoginEvent(email: emailController.text, password: passwordController.text));
          },
          child: const Text('Login'),
        ),
        const SizedBox(height: 30),
        ImageButton(
          imagePath: 'assets/github-icon.png', 
          text: 'Sign in with Github',
          onTap: () {
            context.read<MyPageBloc>().add(const GithubLoginEvent());
          }
        ),
        const SizedBox(height: 10),
        ImageButton(
          imagePath: 'assets/google-icon.png', 
          text: 'Sign in with Google',
          onTap: () {
            context.read<MyPageBloc>().add(const GoogleLoginEvent());
          }
        ),
      ],
    );
  }
}
