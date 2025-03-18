import 'package:flutter/material.dart';
import 'package:toolkit/game_modes/simple_game/saving_and_loading/server_loader.dart';
import 'package:toolkit/models/models.dart';
import 'package:toolkit/game_modes/simple_game/game_options.dart';
import 'package:toolkit/widgets/nice_button.dart';

class SavedStatesListView extends StatefulWidget {
  const SavedStatesListView(
      {super.key, required this.player, required this.gameOptions});

  final Player player;
  final GameOptions gameOptions;

  @override
  State<SavedStatesListView> createState() => _SavedStatesListViewState();
}

class _SavedStatesListViewState extends State<SavedStatesListView> {
  final ServerLoader serverLoader = ServerLoader();


  int currentCategory = 1;
  Widget _buildBackButton() {
    return Positioned(
      top: 30,
      left: 30,
      child: BackButton(),
    );
  }

  Future<Widget> _buildLeftContent() async {
    List<Map<String, dynamic>> categories = await serverLoader.getCategories();
    String categoryName = categories[currentCategory]['name'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        NiceButton(onPressed: () {}, text: categoryName),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackButton(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 2,
                child: FutureBuilder<Widget>(
                  future: _buildLeftContent(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return snapshot.data ?? SizedBox.shrink();
                    }
                  },
                ),
              ),
              VerticalDivider(
                width: 5,
              ),
              Expanded(
                flex: 3,
                child: Text("Placeholder2"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class SavedStatesListView extends StatefulWidget {
//   const SavedStatesListView({
//     super.key, 
//     required this.player, 
//     required this.gameOptions
//   });
  
//   final Player player;
//   final GameOptions gameOptions;

//   @override
//   State<SavedStatesListView> createState() => _SavedStatesListViewState();
// }

// class _SavedStatesListViewState extends State<SavedStatesListView> {
//   final ServerLoader serverLoader = ServerLoader();
//   final ServerDeleter serverDeleter = ServerDeleter();
//   late OptionsSaver optionsSaver;
//   bool _isLoading = false;
//   int? _selectedCategoryId = 1;
//   List<Map<String, dynamic>> _categories = [];

//   @override
//   void initState() {
//     super.initState();
//     optionsSaver = OptionsSaver(widget.player);
//     _loadCategories();
//   }

//   Future<void> _loadCategories() async {
//     _categories = await serverLoader.getCategories();
//   }

//   Future<void> _handleSave(Map<String, dynamic> save) async {
//     setState(() => _isLoading = true);
    
//     try {
//       final newOptions = await serverLoader.loadGameOptions(
//         widget.gameOptions, 
//         save['id']
//       );
      
//       if (await optionsSaver.saveOptions(newOptions)) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Game state loaded successfully'),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       } else {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Error loading game state'),
//             backgroundColor: Colors.red,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Future<void> _handleDelete(Map<String, dynamic> save) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Confirm Deletion'),
//         content: Text('Are you sure you want to delete "${save['name']}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('CANCEL'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.red,
//             ),
//             child: const Text('DELETE'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       setState(() => _isLoading = true);
      
//       try {
//         await serverDeleter.delete(save['id']);
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Game state deleted successfully'),
//             backgroundColor: Colors.green,
//             behavior: SnackBarBehavior.floating,
//           ),
//         );
//         setState(() {}); // Refresh UI after deletion
//       } finally {
//         if (mounted) {
//           setState(() => _isLoading = false);
//         }
//       }
//     }
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.save_outlined,
//             size: 64,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             "No saved states available",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             "Save your game progress to see it here",
//             style: TextStyle(
//               color: Colors.grey[500],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLoadingState() {
//     return const Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircularProgressIndicator(),
//           SizedBox(height: 16),
//           Text(
//             "Loading saved states...",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryDropdown() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Theme.of(context).cardColor,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<int>(
//           value: _selectedCategoryId,
//           hint: Row(
//             children: [
//               Icon(
//                 Icons.folder_outlined,
//                 color: Theme.of(context).primaryColor,
//                 size: 20,
//               ),
//               const SizedBox(width: 8),
//               const Text(
//                 "Select Category",
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//           isExpanded: true,
//           icon: Icon(
//             Icons.arrow_drop_down,
//             color: Theme.of(context).primaryColor,
//           ),
//           elevation: 2,
//           onChanged: (newValue) {
//             setState(() {
//               _selectedCategoryId = newValue;
//             });
//           },
//           items: _categories.map((category) {
//             return DropdownMenuItem<int>(
//               value: category['id'],
//               child: Row(
//                 children: [
//                   Icon(
//                     Icons.folder,
//                     color: Theme.of(context).primaryColor,
//                     size: 20,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     category['name'],
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildListView() {
//     final saveStates = serverLoader.getData(_selectedCategoryId ?? 1);
    
//     return StreamBuilder<List<Map<String, dynamic>>>(
//       stream: saveStates,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildLoadingState();
//         }
        
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return _buildEmptyState();
//         }
        
//         final saves = snapshot.data!;
        
//         return LayoutBuilder(
//           builder: (context, constraints) {
//             final crossAxisCount = constraints.maxWidth > 900 ? 3 : 2;
            
//             return Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).scaffoldBackgroundColor,
//                     borderRadius: const BorderRadius.vertical(
//                       bottom: Radius.circular(16),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 10,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Categories',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: Theme.of(context).textTheme.bodySmall?.color,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       _buildCategoryDropdown(),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: RefreshIndicator(
//                     onRefresh: () async {
//                       await _loadCategories();
//                       setState(() {});
//                     },
//                     child: GridView.builder(
//                       padding: const EdgeInsets.all(16),
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: crossAxisCount,
//                         childAspectRatio: 2.5,
//                         crossAxisSpacing: 16,
//                         mainAxisSpacing: 16,
//                       ),
//                       itemCount: saves.length,
//                       itemBuilder: (context, index) {
//                         final save = saves[index];
//                         return _buildSaveCard(save);
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// Widget _buildSaveCard(Map<String, dynamic> save) {
//   return Card(
//     elevation: 2,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(16),
//     ),
//     child: InkWell(
//       borderRadius: BorderRadius.circular(16),
//       onTap: () => _handleSave(save),
//       child: Container(
//         padding: const EdgeInsets.all(12), // Reduced padding
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: Theme.of(context).dividerColor.withOpacity(0.1),
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Save Icon with Background
//             Container(
//               width: 48, // Reduced size
//               height: 48, // Reduced size
//               decoration: BoxDecoration(
//                 color: Theme.of(context).primaryColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: Theme.of(context).primaryColor.withOpacity(0.2),
//                   width: 1.5,
//                 ),
//               ),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Icon(
//                     Icons.save_outlined,
//                     color: Theme.of(context).primaryColor,
//                     size: 24, // Reduced size
//                   ),
//                   if (save['isAutoSave'] == true)
//                     Positioned(
//                       right: 2,
//                       bottom: 2,
//                       child: Container(
//                         width: 8, // Reduced size
//                         height: 8, // Reduced size
//                         decoration: BoxDecoration(
//                           color: Colors.green,
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: Theme.of(context).cardColor,
//                             width: 1.5,
//                           ),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 12), // Reduced spacing
            
//             // Save Information
//             Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min, // Added to prevent vertical expansion
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           save['name'],
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14, // Reduced font size
//                           ),
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                       if (save['isNew'] == true)
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 4,
//                             vertical: 2,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).primaryColor,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: const Text(
//                             'NEW',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 9, // Reduced font size
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                   const SizedBox(height: 2), // Reduced spacing
//                   Row(
//                     children: [
//                       const SizedBox(width: 4),
//                       if (save['level'] != null) ...[
//                         const SizedBox(width: 8), // Reduced spacing
//                         Icon(
//                           Icons.stars,
//                           size: 12, // Reduced size
//                           color: Colors.grey[600],
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           'Level ${save['level']}',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 11, // Reduced font size
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ],
//               ),
//             ),
            
//             // Action Buttons
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 // Load Button
//                 Material(
//                   color: Theme.of(context).primaryColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(10),
//                     onTap: () => _handleSave(save),
//                     child: Container(
//                       padding: const EdgeInsets.all(8), // Reduced padding
//                       child: Icon(
//                         Icons.file_download_outlined,
//                         color: Theme.of(context).primaryColor,
//                         size: 20, // Reduced size
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 6), // Reduced spacing
//                 Material(
//                   color: Colors.red[50],
//                   borderRadius: BorderRadius.circular(10),
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(10),
//                     onTap: () => _handleDelete(save),
//                     child: Container(
//                       padding: const EdgeInsets.all(8), // Reduced padding
//                       child: Icon(
//                         Icons.delete_outline,
//                         color: Colors.red[400],
//                         size: 20, // Reduced size
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Saved Games'),
//         centerTitle: false,
//         elevation: 0,
//         actions: [
//           if (_isLoading)
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               ),
//             ),
//         ],
//       ),
//       body: _buildListView(),
//     );
//   }
// }

