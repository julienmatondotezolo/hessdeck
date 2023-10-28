import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hessdeck/models/deck.dart';
import 'package:hessdeck/screens/home_screen.dart';
import 'package:hessdeck/services/api_services.dart';
import 'package:hessdeck/services/decks/process_decks.dart';
import 'package:hessdeck/utils/helpers.dart';
import 'package:hessdeck/widgets/gradient_color_picker.dart';

class DeckSettingsScreen extends StatefulWidget {
  final Deck deck;
  final int deckIndex; // Index of the deck in the list
  final int? folderIndex;

  const DeckSettingsScreen({
    Key? key,
    required this.deck,
    required this.deckIndex,
    this.folderIndex,
  }) : super(key: key);

  @override
  DeckSettingsScreenState createState() => DeckSettingsScreenState();
}

class DeckSettingsScreenState extends State<DeckSettingsScreen> {
  late String _name;
  late Color _iconColor;
  late LinearGradient _backgroundColor;
  late LinearGradient _activeBackgroundColor;
  late String _selectedMethod;
  late List<dynamic> allConnectionsData;

  @override
  void initState() {
    super.initState();
    fetchConnections();
    _name = widget.deck.name;
    _iconColor = widget.deck.iconColor!;
    _backgroundColor = widget.deck.backgroundColor!;
    _activeBackgroundColor = widget.deck.activeBackgroundColor!;
  }

  // Function to fetch data from the API
  Future<void> fetchConnections() async {
    try {
      List<dynamic> data =
          await ApiServices.fetchConnections('connections.json');
      setState(() {
        allConnectionsData = data; // Update the data list with the fetched data
      });
    } catch (error) {
      // Handle any errors that occur during the data fetching process
      throw Exception('Error fetching data: $error');
    }
  }

  void _showGradientPicker(void Function(LinearGradient) onGradientChanged,
      LinearGradient gradient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Gradient'),
          content: SingleChildScrollView(
            child: GradientColorPicker(
              width: 300,
              height: 100,
              borderRadius: BorderRadius.circular(5.0),
              colors: gradient.colors,
              begin: gradient.begin,
              end: gradient.end,
              onColorsChanged: (colors, begin, end) {
                setState(() {
                  gradient = LinearGradient(
                    colors: colors,
                    begin: begin,
                    end: end,
                  );
                });
              },
              onGradientChanged: onGradientChanged,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _selectedMethod = allConnectionsData.last["name"];

    return Scaffold(
      appBar: AppBar(
        title: Text(_name),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: _name,
                onChanged: (newValue) {
                  setState(() {
                    _name = newValue;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16.0),
              DropdownButton<String>(
                value: _selectedMethod,
                items: allConnectionsData.map((table) {
                  return DropdownMenuItem<String>(
                    value: table["name"],
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.network(
                            table["image"],
                            width: 24,
                            height: 24,
                          ),
                        ),
                        Text(
                          table["name"],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedMethod = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: const Text(
                  'Icon Color',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: CircleAvatar(
                  backgroundColor: _iconColor,
                  radius: 18,
                ),
                onTap: () {
                  Helpers.showColorPicker(context, _iconColor, (color) {
                    setState(() {
                      _iconColor = color;
                    });
                  });
                },
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: const Text('Background Color',
                    style: TextStyle(color: Colors.white)),
                trailing: Container(
                  width: 36.0,
                  height: 36.0,
                  decoration: BoxDecoration(
                    gradient: _backgroundColor,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                onTap: () {
                  _showGradientPicker((gradient) {
                    setState(() {
                      _backgroundColor = gradient;
                    });
                  }, _backgroundColor);
                },
              ),
              const SizedBox(height: 16.0),
              widget.deck.clickableDeck == true
                  ? ListTile(
                      title: const Text('Active Background Color',
                          style: TextStyle(color: Colors.white)),
                      trailing: Container(
                        width: 36.0,
                        height: 36.0,
                        decoration: BoxDecoration(
                          gradient: _activeBackgroundColor,
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                      onTap: () {
                        _showGradientPicker((gradient) {
                          setState(() {
                            _activeBackgroundColor = gradient;
                          });
                        }, _activeBackgroundColor);
                      },
                    )
                  : Container(),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Deck? updatedDeck;

                  updatedDeck = widget.deck.copyWith(
                    name: _name,
                    iconColor: _iconColor,
                    activeBackgroundColor: _activeBackgroundColor,
                    backgroundColor: _backgroundColor,
                  );

                  ProcessDecks.addNewDeck(
                    context,
                    widget.deckIndex,
                    widget.folderIndex,
                    updatedDeck,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  'Update Deck',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  HapticFeedback.vibrate();
                  ProcessDecks.removeDeck(
                    context,
                    widget.deckIndex,
                    widget.folderIndex,
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Remove Deck',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
