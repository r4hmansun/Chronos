import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Formpage(),
    );
  }
}

class Formpage extends StatefulWidget {
  const Formpage({super.key});

  @override
  State<Formpage> createState() => _FormpageState();
}

class _FormpageState extends State<Formpage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Input Flutter")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.person, size: 25, color: Colors.grey)
              ],
            ),
           
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                label: Text("Masukkan Nama"),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),


            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.visibility, size: 25, color: Colors.grey)
              ],
            ),

         
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                label: Text("Masukkan Umur"),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox( height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.email, size: 25, color: Colors.grey)
              ],
            ),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                label: Text("Masukan Email Anda"),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

           
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final ageText = _ageController.text.trim();
                final email = _emailController.text.trim();

                if (name.isEmpty || ageText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Nama, umur dan email harus diisi!")),
                  );
                  return;
                }

                final ageInt = int.tryParse(ageText);
                if (ageInt == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Umur harus berupa angka yang valid.")),
                  );
                  return;
                }

                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SecondPage(name: name, age: ageInt, email: email),
                  ),
                );
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final String name;
  final int age;
  final String email;

  const SecondPage({super.key, required this.name, required this.age, required this.email});
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Halaman Kedua")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Halo, nama anda $name dan umur anda $age serta email anda $email",
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Kembali ke halaman pertama"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}