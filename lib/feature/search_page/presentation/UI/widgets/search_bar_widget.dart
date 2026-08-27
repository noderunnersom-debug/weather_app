import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather/core/theme/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final FocusNode focusNode;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 15, right: 15, bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                hintText: 'Поиск города...',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.border, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: AppColors.borderFocus,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: AppColors.textField,
                suffixIcon: ValueListenableBuilder(
                  valueListenable: controller,
                  builder: (context, TextEditingValue value, _) {
                    if (value.text.isEmpty) return const SizedBox();

                    return IconButton(
                      icon: const Icon(Icons.clear, color: AppColors.red),
                      onPressed: () {
                        controller.clear();
                        onChanged('');
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Отмена',
              style: TextStyle(color: AppColors.textAccent, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
