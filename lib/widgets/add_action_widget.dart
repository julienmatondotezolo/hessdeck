import 'package:flutter/material.dart';
import 'package:hessdeck/services/actions/manage_actions.dart';
import 'package:hessdeck/themes/colors.dart';

class AddActionWidget extends StatelessWidget {
  final BuildContext context;
  final String action;
  final void Function(String) onActionChanged;

  const AddActionWidget({
    Key? key,
    required this.onActionChanged,
    required this.context,
    required this.action,
  }) : super(key: key);

  void _showAddActionModal(context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final allActions = ManageAcions.getAllActions();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              decoration: const BoxDecoration(
                gradient: AppColors.blueToGreyGradient,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25.0),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(
                    color: AppColors.darkGrey,
                    thickness: 5,
                    indent: 140,
                    endIndent: 140,
                  ),
                  SizedBox(
                    height: screenHeight * 0.03, // 3% of the screen height
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Add a action",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  for (var action in allActions.entries)
                    GestureDetector(
                      onTap: () {
                        onActionChanged(action.key);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.darkGrey, // Grey background color
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white10,
                              width: 1.0,
                            ), // Thin white border bottom
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26.0,
                          vertical: 16.0,
                        ),
                        child: Row(
                          children: [
                            /*Image.network(
                              action['image'],
                              width: 24,
                            ),
                            const SizedBox(width: 16.0),*/
                            Text(
                              action.key,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (action.isNotEmpty) {
      return Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white10,
              width: 1.0,
            ), // Thin white border bottom
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                _showAddActionModal(context);
              },
              child: Row(
                children: [
                  const Text(
                    'Action: ',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    action,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.blueGrey,
                  width: 2,
                ), // Green border
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              child: GestureDetector(
                onTap: () {
                  onActionChanged('');
                },
                child: const Text(
                  'Remove action',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ElevatedButton(
      onPressed: () {
        _showAddActionModal(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkGrey, // Dark grey color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Rounded corners
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: Colors.white), // + icon
          SizedBox(width: 8), // Spacing
          Text('Add Action'), // Text
        ],
      ),
    );
  }
}
