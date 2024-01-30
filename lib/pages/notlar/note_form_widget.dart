import 'package:digital_agenda/pages/components/colors.dart';
import 'package:flutter/material.dart';

class NoteFormWidget extends StatelessWidget {
  final bool? isImportant;
  final int? number;
  final String? title;
  final String? description;
  final ValueChanged<bool> onChangedImportant;
  final ValueChanged<int> onChangedNumber;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;

  const NoteFormWidget({
    Key? key,
    this.isImportant = false,
    this.number = 0,
    this.title = ' ',
    this.description = ' ',
    required this.onChangedImportant,
    required this.onChangedNumber,
    required this.onChangedTitle,
    required this.onChangedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              const SizedBox(height: 8),
              buildDescription(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        initialValue: title,
        style: const TextStyle(
          color: ColorUtility.defaultBlackColor,
          fontSize: 22,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Başlık : ',
          hintStyle: TextStyle(
            color: ColorUtility.defaultGreyColor,
          ),
        ),
        validator: (title) => title != null && title.isEmpty ? 'Başlık boş olmamalıdır.' : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => TextFormField(
        initialValue: description,
        style: const TextStyle(color: ColorUtility.defaultGreyColor, fontSize: 20),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Bir şeyler yazın.',
          hintStyle: TextStyle(
            color: ColorUtility.defaultBlackColor,
          ),
        ),
        validator: (title) => title != null && title.isEmpty ? 'Açıklama boş olmamalıdır.' : null,
        onChanged: onChangedDescription,
      );
}
