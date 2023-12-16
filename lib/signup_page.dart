// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatelessWidget {
  final String usernameHint;
  final String emailHint;
  final String passwordHint;
  final String confirmPasswordHint;

  const SignUpPage({
    super.key,
    this.usernameHint = 'User Name',
    this.emailHint = 'Email',
    this.passwordHint = 'Password',
    this.confirmPasswordHint = 'Confirm Password',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.network(
              'https://www.onlinelogomaker.com/blog/wp-content/uploads/2017/09/fashion-logo-design.jpg',
              width: 200,
              height: 160,
            ),
          ),
          const Positioned(
            top: 200,
            left: 16,
            child: Text(
              'Sign Up',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 27,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Positioned(
            top: 240,
            left: 16,
            child: Text(
              'Create a new account',
              style: TextStyle(
                  color: Color.fromARGB(218, 109, 109, 109),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Positioned(
            top: 300,
            left: 16,
            right: 16,
            child: SignUpForm(
              usernameHint: usernameHint,
              emailHint: emailHint,
              passwordHint: passwordHint,
              confirmPasswordHint: confirmPasswordHint,
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  final String usernameHint;
  final String emailHint;
  final String passwordHint;
  final String confirmPasswordHint;

  const SignUpForm({
    super.key,
    required this.usernameHint,
    required this.emailHint,
    required this.passwordHint,
    required this.confirmPasswordHint,
  });

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;

  Future<void> registerUser() async {
    final response = await http.post(
      Uri.parse('http://45.87.173.50:3000/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    if (response.statusCode == 201) {
      print('Register is successful.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Register is successful.')),
      );
    } else {
      print('User registration failed: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'There is already an account with the same username or email. User registration failed.')),
      );
    }
  }

  Future<bool> isUserExists() async {
    final response = await http.get(
      Uri.parse(
          'http://45.87.173.50:3000/check?email=${_emailController.text}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. ${widget.usernameHint}',
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: widget.usernameHint,
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '2. ${widget.emailHint}',
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: widget.emailHint,
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '3. ${widget.passwordHint}',
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: widget.passwordHint,
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '4. ${widget.confirmPasswordHint}',
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: widget.confirmPasswordHint,
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            // Kullanıcı bilgilerini yazdırma
            print('Username: ${_nameController.text}');
            print('Email: ${_emailController.text}');
            print('Password: ${_passwordController.text}');
            print('Confirm Password: ${_confirmPasswordController.text}');

            // Kullanıcı kontrolü
            final userExists = await isUserExists();
            if (userExists) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'There is already a registered user with this email address.')),
              );
            } else {
              // API'ye post işlemi yapma
              registerUser();
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
