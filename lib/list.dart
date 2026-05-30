import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListView.builder + ListTile',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contoh ListView.builder'),
        ),
        body: const DaftarOrang(),
      ),
    );
  }
}

class DaftarOrang extends StatelessWidget {
  const DaftarOrang({super.key});

  
  final List<Map<String, String>> data = const [
    {'nama': 'maleakhi', 'email': 'maleakhi@mail.com'},
    {'nama': 'jodi', 'email': 'jodi@mail.com'},
    {'nama': 'lutfi', 'email': 'lutfi@mail.com'},
    {'nama': 'harry', 'email': 'harry@mail.com'},
    {'nama': 'brema', 'email': 'brema@mail.com'},
    {'nama': 'vorgiano', 'email': 'vorgiano@mail.com'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length, 
      itemBuilder: (context, index) {
        final orang = data[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                orang['nama']![0], 
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(orang['nama']!),
            subtitle: Text(orang['email']!),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Kamu menekan ${orang['nama']}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        );
      },
    );
  }
}