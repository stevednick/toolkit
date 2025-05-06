import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/simple_game/game_options.dart';
import 'package:toolkit/game_modes/simple_game/saving_and_loading/saved_states_list_view.dart';
import 'package:toolkit/models/player/player.dart';
import 'package:toolkit/widgets/qr_code_generator.dart';
import 'package:toolkit/widgets/qr_scanner.dart';
import 'package:toolkit/widgets/widgets.dart';

class LoadAndSaveView extends StatefulWidget {
  final GameOptions gameOptions;
  final Player player;
  final Function() refreshScene;
  // final ServerSaver serverSaver = ServerSaver();
  // final ServerLoader serverLoader = ServerLoader();
  const LoadAndSaveView(
      {super.key,
      required this.gameOptions,
      required this.player,
      required this.refreshScene});

  @override
  State<LoadAndSaveView> createState() => _LoadAndSaveViewState();
}

class _LoadAndSaveViewState extends State<LoadAndSaveView> {
  Widget _buildQRScannerButton() {
    return Align(
      alignment: Alignment(0.5, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 200,
            child: Text(
                textAlign: TextAlign.center,
                "Use the QR scanner to load settings from a QR code."),
          ),
          SizedBox(
            height: 40,
          ),
          NiceButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrScanner(
                      player: widget.player,
                    ),
                  ),
                );
              },
              text: "Scan Code"),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BackButton(
        onPressed: () {
          widget.refreshScene();
          Navigator.pop(context);
        },
      ),
    );
  }

//  Widget _buildSaveSettingsToServerButton() {
//   return Positioned(
//     bottom: 30,
//     right: 30,
//     child: NiceButton(
//       onPressed: () async {
//         int? selectedCategoryId; // Store the selected category
//         List<Map<String, dynamic>> categories = [];

//         // Fetch categories before showing the dialog
//         categories = await widget.serverLoader.getCategories();

//         showDialog(
//           context: context,
//           builder: ((context) {
//             String? settingName;
//             return StatefulBuilder(
//               builder: (context, setState) {
//                 return SimpleDialog(
//                   title: const Text("Save Settings"),
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   children: [
//                     // Text Field for Setting Name
//                     TextFormField(
//                       decoration: const InputDecoration(labelText: "Setting Name"),
//                       onChanged: (value) {
//                         settingName = value;
//                       },
//                     ),
//                     const SizedBox(height: 10),

//                     // Dropdown for Selecting a Category
//                     DropdownButton<int>(
//                       value: selectedCategoryId,
//                       hint: const Text("Select Category"),
//                       isExpanded: true,
//                       items: categories.map((category) {
//                         return DropdownMenuItem<int>(
//                           value: category['id'],
//                           child: Text(category['name']),
//                         );
//                       }).toList(),
//                       onChanged: (newValue) {
//                         setState(() {
//                           selectedCategoryId = newValue;
//                         });
//                       },
//                     ),

//                     const SizedBox(height: 20),

//                     // Save Button
//                     ElevatedButton(
//                       onPressed: () async {
//                         if (settingName != null && selectedCategoryId != null) {
//                           await widget.serverSaver.saveGameOptions(
//                             widget.gameOptions,
//                             settingName!,
//                             selectedCategoryId!,
//                           );
//                           Navigator.pop(context); // Close dialog after saving
//                         } else {
//                           // Show an error message if fields are empty
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("Please enter a name and select a category")),
//                           );
//                         }
//                       },
//                       child: const Text("Save"),
//                     ),
//                   ],
//                 );
//               },
//             );
//           }),
//         );
//       },
//       text: "Save Settings to Server",
//     ),
//   );
// }

  Widget _buildLoadPageButton() {
    return Positioned(
      bottom: 70,
      right: 30,
      child: NiceButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SavedStatesListView(
                  player: widget.player,
                  gameOptions: widget.gameOptions,
                ),
              ),
            );
          },
          text: "Load Page"),
    );
  }

  Widget _buildQRCodeGenerator() {
    return Align(
      alignment: Alignment(-0.5, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              style: TextStyle(
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
              "Scan this code from your from Toolkit on another device to share your game settings,",
              //ssoftWrap: true,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          QRCodeGenerator(gameOptions: widget.gameOptions),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildBackButton(),
          _buildQRScannerButton(),
          _buildQRCodeGenerator(),
          //_buildSaveSettingsToServerButton(),
          //_buildLoadPageButton(),
        ],
      ),
    );
  }
}
