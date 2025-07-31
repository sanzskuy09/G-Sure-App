import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gsure/blocs/auth/auth_bloc.dart';
import 'package:gsure/models/login_model.dart';
import 'package:gsure/models/user_model.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/widgets/buttons.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LoginUserPage extends StatefulWidget {
  const LoginUserPage({super.key});

  @override
  State<LoginUserPage> createState() => _LoginUserPageState();
}

class _LoginUserPageState extends State<LoginUserPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String appName = '';
  String version = '';
  String buildNumber = '';
  final int currentYear = DateTime.now().year;

  Future<void> loadAppInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appName = info.appName;
      version = info.version;
      buildNumber = info.buildNumber;
    });
  }

  UserModel? _loggedInUser;

  Future<bool> validate() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final String response = await rootBundle.loadString('assets/user.json');

    final List<dynamic> data = json.decode(response);

    final List<UserModel> users =
        data.map((json) => UserModel.fromJson(json)).toList();

    for (var user in users) {
      if (user.username == username && user.password == password) {
        setState(() {
          _loggedInUser = user;
        });
        return true;
      }
    }

    return false;
  }

  @override
  void initState() {
    super.initState();
    loadAppInfo();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Invalid Username or Password'),
                duration: Duration(seconds: 2),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Selamat datang, ${state.user.name}!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushNamedAndRemoveUntil(context, '/main', (_) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                child: Container(
                  height: 350,
                  // margin: const EdgeInsets.only(top: 150, bottom: 20),
                  margin: const EdgeInsets.only(top: 100, bottom: 0),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      // image: AssetImage('assets/bg_logo.png'),
                      image: AssetImage('assets/ic_logo.png'),
                      fit: BoxFit.contain, // mengecilkan agar muat
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ),

              // Align(
              //   alignment: Alignment.center,
              //   child: Text(
              //     'G-MORE APP',
              //     style: blackTextStyle.copyWith(
              //       fontSize: 20,
              //       fontWeight: semiBold,
              //     ),
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              Container(
                padding: EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: whiteColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username input
                    FractionallySizedBox(
                      // widthFactor: 0.8,
                      child: TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          prefixIcon: Icon(Icons.person, color: primaryColor),
                          prefixIconConstraints: BoxConstraints(minWidth: 60),
                          hintText: 'Input Username',
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Password input
                    FractionallySizedBox(
                      // widthFactor: 0.8,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          prefixIcon: Icon(Icons.lock, color: primaryColor),
                          prefixIconConstraints: BoxConstraints(minWidth: 60),
                          hintText: 'Input Password',
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    CustomFilledButton(
                      title: 'Sign in',
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              AuthLogin(
                                LoginModel(
                                  username: _usernameController.text,
                                  password: _passwordController.text,
                                ),
                              ),
                            );
                      },
                      // onPressed: login,
                    ),

                    const SizedBox(height: 30),

                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Versi $version (Build $buildNumber)',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),

                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 50,
                    //   child: TextButton(
                    //     onPressed: () {
                    //       login();
                    //     },
                    //     style: TextButton.styleFrom(
                    //       backgroundColor: primaryColor,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(50),
                    //       ),
                    //     ),
                    //     child: Text(
                    //       'Sign In',
                    //       style: whiteTextStyle.copyWith(
                    //         fontSize: 16,
                    //         fontWeight: semiBold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
