import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reports/serviceprovider.dart';


class Search extends StatefulWidget {
  const Search({
    super.key,
  });

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DateTime? selectedDate;

  // Function to display the date picker and save the selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
               final serviceProvider = Provider.of<Serviceprovider>(context, listen: false);

        // Update the TextField's text with the formatted date only
        serviceProvider.text.text = "${selectedDate!.toLocal()}".split(' ')[0];
      });
      // Fetch data from API with the selected date
       // ignore: use_build_context_synchronously
                      final serviceProvider = Provider.of<Serviceprovider>(context, listen: false);

      await serviceProvider.fetchDatasearch(selectedDate!);
    }
  }


  @override
  Widget build(BuildContext context)
   {               final serviceProvider = Provider.of<Serviceprovider>(context, listen: false);

    return TextField(
      readOnly: true,
      controller: serviceProvider.text,
      onTap: () {
        _selectDate(context);
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: 'بحث',
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
