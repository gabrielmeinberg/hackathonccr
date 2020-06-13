// Flutter code sample for BottomNavigationBar

// This example shows a [BottomNavigationBar] as it is used within a [Scaffold]
// widget. The [BottomNavigationBar] has three [BottomNavigationBarItem]
// widgets and the [currentIndex] is set to index 0. The selected item is
// amber. The `_onItemTapped` function changes the selected item's index
// and displays a corresponding message in the center of the [Scaffold].
//
// ![A scaffold with a bottom navigation bar containing three bottom navigation
// bar items. The first one is selected.](https://flutter.github.io/assets-for-api-docs/assets/material/bottom_navigation_bar.png)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:siga_saudavel_caminhoneiro/adapter/camunda_adapter.dart';


void main() => runApp(MyApp());

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Siga Saudavel Caminhoneiro';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: MyStatefulWidget(),
    );
  }
}

class Appointment {
  Appointment({this.descricao, this.data, this.status, this.idProcess});

  String descricao;
  String data;
  String status;
  String idProcess;
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static List<Appointment> appointmentList = [];
  static DateFormat format = DateFormat("dd/MM/yyyy");
  static TextEditingController descricao = TextEditingController();
  static TextEditingController data = TextEditingController();



  static List<Widget> _widgetOptions = <Widget>[
    Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.album),
            title: Text('Olá esses são seus pontos até hoje'),
            subtitle: Text('1500 pontos'),
          ),
          ListTile(
            leading: Icon(Icons.album),
            title: Text('Caminhanha'),
            subtitle: Text('Hoje você já andou 200 passos, sua meta é 1000.'),
          ),
          ListTile(
            leading: Icon(Icons.album),
            title: Text('Saúde Mental'),
            subtitle: Text('Você já leu 2 dicas de 5'),
          ),
          ListTile(
            leading: Icon(Icons.album),
            title: Text('Saúde Fisica'),
            subtitle: Text('Você já leu 2 dicas de 5'),
          ),
        ],
      ),
    ),
    Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: descricao,
            style: TextStyle(fontSize: 25.0),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: const InputDecoration(
                labelText: "O que você esta sentindo? *",
                contentPadding: EdgeInsets.all(15.0),
                border: InputBorder.none,
                filled: true),
            validator: (value) {
              if (value.isEmpty) {
                return 'Insira uma Descrição';
              }
              return null;
            },
          ),
          DateTimeField(
            controller: data,
            style: TextStyle(fontSize: 25.0),
            format: format,
            decoration: const InputDecoration(
                hintText: 'Data Consulta',
                labelText: "Data Consulta? *",
                contentPadding: EdgeInsets.all(15.0),
                border: InputBorder.none,
                filled: true),
            onShowPicker: (context, currentValue) {
              return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));
            },
            validator: (date) {
              if (date == null) {
                return 'Selecione uma Data';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () async {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  List<String> idCamunda = await Future.wait([CamundaAdapter().createAppointment(data.text, descricao.value.text)]);
                  Appointment appointment = Appointment(
                    descricao.text,
                    data.text,
                    "ACTIVE",
                    idCamunda[0]
                  );
                }
              },
              child: Text('Agendar'),
            ),
          ),
        ],
      ),
    ),
    Card(
      child: Column(
        children: <Widget>[
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: appointmentList.length,
            itemBuilder: (BuildContext ctxt, int index) {
              return ListTile(
                leading: Icon(Icons.album),
                title: Text('Olá esses são seus pontos até hoje'),
                subtitle: Text('1500 pontos'),
              );
            },
          ),
        ],
      ),
    )
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Siga Saudavel Caminhoneiro'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            title: Text('Perfil'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            title: Text('Marcar Consulta'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            title: Text('Agenda de Consulta'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
