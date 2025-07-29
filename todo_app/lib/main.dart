import 'package:flutter/material.dart';

void main() {
  runApp(ToDoUygulamasi());
}

class ToDoUygulamasi extends StatelessWidget {
  const ToDoUygulamasi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _aktifSayfa = 0;

  final List<Widget> _sayfalar = [];

  @override
  void initState() {
    super.initState();
    _sayfalar.add(_buildGorevSayfasi());
    _sayfalar.add(Center(child: Text('Takvim Sayfası')));
    _sayfalar.add(Center(child: Text('Profil Sayfası')));
    _sayfalar.add(Center(child: Text('Ayarlar Sayfası')));
  }

  Widget _buildGorevSayfasi() {
    List<Map<String, dynamic>> bugunGorevler = gorevler
        .where((gorev) => gorev['tarih'] == tarihler[selectedDateIndex])
        .toList();

    return bugunGorevler.isEmpty
        ? const Center(child: Text("Bugün için görev yok."))
        : ListView.builder(
            itemCount: bugunGorevler.length,
            itemBuilder: (context, index) {
              final gorev = bugunGorevler[index];
              return Card(
                child: ListTile(
                  leading: Checkbox(
                    value: gorev['tamamlandi'],
                    onChanged: (val) {
                      setState(() {
                        gorev['tamamlandi'] = val!;
                      });
                    },
                  ),
                  title: Text(gorev['baslik']),
                  subtitle: Text(gorev['saat']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        gorevler.remove(gorev);

                        _sayfalar[0] = _buildGorevSayfasi();
                      });
                    },
                  ),
                ),
              );
            },
          );
  }

  int selectedDateIndex = 0;

  final List<String> tarihler = [
    "29 Jul",
    "30 Jul",
    "31 Jul",
    "1 Aug",
    "2 Aug",
    "3 Aug",
    "4 Aug",
    "5 Aug",
    "6 Aug",
    "7 Aug",
    "8 Aug",
    "9 Aug",
  ];

  List<Map<String, dynamic>> gorevler = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Reminders'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              PopupMenuItem(child: Text("Filtre 1")),
              PopupMenuItem(child: Text("Filtre 2")),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 70,
            padding: EdgeInsets.symmetric(vertical: 10),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: tarihler.length,
              itemBuilder: (context, index) {
                final bool secili = index == selectedDateIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDateIndex = index;
                    });
                  },
                  child: Container(
                    width: 70,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: secili ? Colors.deepPurple : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tarihler[index],
                      style: TextStyle(
                        color: secili ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(child: _sayfalar[_aktifSayfa]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String baslik = '';
          String saat = '';

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Yeni Görev Ekle"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'Görev Başlığı'),
                      onChanged: (value) => baslik = value,
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(labelText: 'Saat (örn: 14:00)'),
                      onChanged: (value) => saat = value,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text("İptal"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  ElevatedButton(
                    child: const Text("Ekle"),
                    onPressed: () {
                      if (baslik.isNotEmpty && saat.isNotEmpty) {
                        setState(() {
                          gorevler.add({
                            'baslik': baslik,
                            'saat': saat,
                            'tarih': tarihler[selectedDateIndex],
                            'tamamlandi': false,
                          });
                          _sayfalar[0] = _buildGorevSayfasi();
                        });
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.list),
                color: _aktifSayfa == 0 ? Colors.deepPurple : Colors.grey,
                onPressed: () => setState(() => _aktifSayfa = 0),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today),
                color: _aktifSayfa == 1 ? Colors.deepPurple : Colors.grey,
                onPressed: () => setState(() => _aktifSayfa = 1),
              ),
              SizedBox(width: 40),
              IconButton(
                icon: Icon(Icons.person),
                color: _aktifSayfa == 2 ? Colors.deepPurple : Colors.grey,
                onPressed: () => setState(() => _aktifSayfa = 2),
              ),
              IconButton(
                icon: Icon(Icons.settings),
                color: _aktifSayfa == 3 ? Colors.deepPurple : Colors.grey,
                onPressed: () => setState(() => _aktifSayfa = 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
