import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  String? error;

  Future<void> _register() async {
    final email = emailCtrl.text.trim();
    final password = passwordCtrl.text;

    try {
      final response = await SupabaseService.signUp(email: email, password: password);
      if (response.user != null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
      } else {
        setState(() => error = 'Inscription échouée.');
      }
    } catch (e) {
      setState(() => error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: passwordCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Mot de passe')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: const Text("S'inscrire")),
            if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
