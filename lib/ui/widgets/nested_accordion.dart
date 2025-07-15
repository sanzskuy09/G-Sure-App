import 'package:flutter/material.dart';
import 'package:gsure/models/question_model.dart';
import 'package:gsure/shared/theme.dart';
import 'package:gsure/ui/widgets/form_field_builder.dart';

class MyNestedAccordion extends StatefulWidget //__
{
  final String title;
  final List<FieldModel> fields;
  final Map<String, dynamic> formAnswers;
  final VoidCallback? onFieldChanged;

  const MyNestedAccordion({
    super.key,
    required this.title,
    required this.fields,
    required this.formAnswers,
    this.onFieldChanged,
  });

  @override
  State<MyNestedAccordion> createState() => _MyNestedAccordionState();
}

class _MyNestedAccordionState extends State<MyNestedAccordion> {
  @override
  Widget build(context) //__
  {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 2), // 🟥 Border merah
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔺 Header Merah
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.maps_home_work, color: whiteColor),
                SizedBox(width: 12),
                Text(
                  widget.title,
                  style: whiteTextStyle.copyWith(
                      fontSize: 16, fontWeight: semiBold),
                ),
              ],
            ),
          ),
          // ⬜ Konten Form Putih
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Data Field
                ...widget.fields.map(
                  (sf) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 0),
                    child: FieldBuilder(
                      field: sf,
                      index: widget.fields.indexOf(sf) + 1,
                      formAnswers: widget.formAnswers,
                      setState: setState,
                      onValueChanged: (newValue) {
                        setState(() {
                          sf.value = newValue;
                          widget.formAnswers[sf.key!] = newValue;
                          widget.onFieldChanged?.call();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
