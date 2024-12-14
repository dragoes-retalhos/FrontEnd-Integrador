import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'perfil.dart';
import 'package:front_integrador/Components/bottomNavBar.dart';
import 'package:front_integrador/service/auth_service.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Future<List<NotificationItem>> fetchNotifications() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/notification'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((item) => NotificationItem.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar as notificações');
    }
  }

  Future<List<NotificationItem>> fetchMaintenanceNotifications() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse(
          'http://localhost:8080/notification/undisplayed?type=MANUTENCAO_ITEM'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((item) => NotificationItem.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar as notificações de manutenção');
    }
  }

  Future<List<NotificationItem>> fetchLoanNotifications() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse(
          'http://localhost:8080/notification/undisplayed?type=VENCIMENTO_EMPRESTIMO'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      return data.map((item) => NotificationItem.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar as notificações de empréstimo');
    }
  }

  late Future<List<NotificationItem>> notificationsFuture;

  @override
  void initState() {
    super.initState();
    notificationsFuture = fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0000FF),
        iconTheme: IconThemeData(color: Colors.white),
        title: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            "Notificaçôes",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 20.0, top: 10.0),
            icon: Icon(Icons.notifications, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
          IconButton(
            padding: const EdgeInsets.only(right: 20.0, top: 10.0),
            icon: Icon(Icons.account_circle, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PerfilPage()),
              );
            },
          ),
        ],
        toolbarHeight: 80,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      notificationsFuture = fetchLoanNotifications();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(100, 86, 100, 245),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'EMPRÉSTIMOS',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      notificationsFuture = fetchMaintenanceNotifications();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(100, 86, 100, 245),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'MANUTENÇÕES',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<NotificationItem>>(
              future: notificationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar notificações'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhuma notificação encontrada'));
                }

                final notifications = snapshot.data!;
                return ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 4.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notificação #${notification.id}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                notification.message,
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Criado em: ${_formatDate(notification.createdAt)}',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 0,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/beneficiados');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/itens');
          }
        },
      ),
    );
  }

  String _formatDate(String date) {
    final dateTime = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
}

class NotificationItem {
  final int id;
  final int relatedId;
  final String message;
  final String type;
  final String createdAt;
  final bool displayed;

  NotificationItem({
    required this.id,
    required this.relatedId,
    required this.message,
    required this.type,
    required this.createdAt,
    required this.displayed,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      relatedId: json['relatedId'],
      message: json['message'],
      type: json['type'],
      createdAt: json['createdAt'],
      displayed: json['displayed'],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NotificationsPage(),
    debugShowCheckedModeBanner: false,
  ));
}
