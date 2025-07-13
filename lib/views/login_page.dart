import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  String? error;

  Future<void> _login() async {
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text;

    try {
      final response = await SupabaseService.signIn(email: email, password: password);
      if (response.session != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      } else {
        setState(() => error = 'Identifiants incorrects.');
      }
    } catch (e) {
      setState(() => error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passwordCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Mot de passe')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: const Text('Se connecter')),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage())),
              child: const Text("Pas encore inscrit ? S'inscrire"),
            ),
            if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
