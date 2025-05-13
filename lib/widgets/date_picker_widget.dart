import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

typedef DatePickerValueSelectedCallback = Function(DateTime date);

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget(
      {Key? key,
      required this.label,
      required this.initialDate,
      required this.minDate,
      required this.maxDate,
      required this.onDateSelected})
      : super(key: key);

  final String label;
  final DateTime initialDate;
  final DateTime minDate;
  final DateTime maxDate;

  final DatePickerValueSelectedCallback onDateSelected;

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  TextEditingController dateinput = TextEditingController();
  //text editing controller for text field

  DateTime currentDate = DateTime.now();
  @override
  void initState() {
    currentDate = widget.initialDate;
    dateinput.text = DateFormat('yyyy-MM-dd')
        .format(currentDate); //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextField(
      controller: dateinput, //editing controller of this TextField
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        fillColor: const Color(0xFF2963C8),
        labelText: widget.label,
      ),
      readOnly: true, //set it true, so that user will not able to edit text
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: currentDate,
          firstDate: widget
              .minDate, //DateTime.now() - not to allow to choose before today.
          lastDate: widget.maxDate,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                textTheme: TextTheme(
                    headlineMedium: GoogleFonts.openSans(
                        fontSize: 18.0,
                        color: Colors.white,
                        backgroundColor: Colors.transparent)),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          print(
              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          print(
              formattedDate); //formatted date output using intl package =>  2021-03-16
          //you can implement different kind of Date Format here according to your requirement
          widget.onDateSelected(pickedDate);
          setState(() {
            currentDate = pickedDate;
            dateinput.text = formattedDate;
            //set output date to TextField value.
          });
        } else {
          print("Date is not selected");
        }
      },
    ));
  }
}
