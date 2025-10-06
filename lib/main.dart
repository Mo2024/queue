import 'package:flutter/material.dart';
import 'package:queue/customer.dart';
import 'package:queue/customer_form/customer_form_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('myBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/customer_form_page': (context) => const CustomerFormPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with RouteAware {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: ValueListenableBuilder(
          valueListenable: Hive.box('myBox').listenable(),
          builder: (context, box, _) {
            final rawItems = box.get('customers', defaultValue: []) as List;
            final count = rawItems.length;
            return Column(
              children: [
                Text(
                  'Queue Overview',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 1, 102, 92),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('myBox').listenable(),
        builder: (context, box, _) {
          final rawItems = box.get('customers', defaultValue: []) as List;
          final items = rawItems
              .map((item) => Customer.fromMap(Map<String, dynamic>.from(item)))
              .toList();

          if (items.isEmpty) {
            return Center(
              child: Text(
                'No customers in the waiting list',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final customer = items[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    MediaQuery(
                      data: MediaQuery.of(
                        context,
                      ).copyWith(textScaler: TextScaler.linear(1.0)),
                      child: numberOfPeople(context, index, customer),
                    ),
                    const SizedBox(height: 4),
                    Text('Mobile 1: ${customer.mobile1}'),
                    if ((customer.mobile2 ?? '').isNotEmpty)
                      Text('Mobile 2: ${customer.mobile2}'),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF009688),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          print('bnn');
          Navigator.pushNamed(context, '/customer_form_page');
        },
      ),
    );
  }

  Widget numberOfPeople(BuildContext build, int index, Customer customer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Number of people: ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold, // bold
                ),
              ),
              TextSpan(
                text: '${customer.numberOfPeople}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal, // normal
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.check, color: Color(0xFF1B5E20)),
              padding: EdgeInsets.zero,
              constraints:
                  const BoxConstraints(), // removes min size constraints
              onPressed: () {
                var box = Hive.box('myBox');
                var customers = box.get('customers') as List;
                customers.removeAt(index);
                box.put('customers', customers);
              },
            ),
          ],
        ),
      ],
    );
  }
}
