import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final String label;
  final String title;
  final String? selectedOption;
  final List<String> options;
  final ValueChanged<String> onOptionSelected; // Callback to handle selected option

  const CustomDropdown({
    super.key,
    required this.label,
    required this.title,
    this.selectedOption,
    required this.options,
    required this.onOptionSelected,
  });

  @override
  CustomDropdownState createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> {
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = widget.selectedOption;
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Options list
              ...widget.options.map((option) {
                final bool isSelected = option == _selectedOption;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedOption = option;
                    });
                    widget.onOptionSelected(option);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.purple.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: isSelected ? Colors.purple : Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Text(
                          option,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: isSelected ? Colors.purple : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _showOptions,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F4),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Text(
                _selectedOption ?? widget.label,
                style: const TextStyle(fontSize: 16.0),
              ),
              const Spacer(),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }
}
