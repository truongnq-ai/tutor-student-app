import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/app_localization.dart';
import '../../../core/theme/theme.dart';

class MathSymbolsToolbar extends StatelessWidget {
  final Function(String) onSymbolTap;

  const MathSymbolsToolbar({
    super.key,
    required this.onSymbolTap,
  });

  @override
  Widget build(BuildContext context) {
    // Common math symbols for grades 6-7
    final symbols = [
      ['+', '-', '×', '÷'],
      ['=', '≠', '<', '>'],
      ['≤', '≥', '±', '√'],
      ['²', '³', '°', '%'],
      ['(', ')', '[', ']'],
      ['{', '}', '|', '|'],
      ['π', '∞', '∑', '∫'],
      ['α', 'β', 'γ', 'θ'],
      ['x', 'y', 'a', 'b'],
      ['c', 'n', 'm', 'k'],
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.padding.p8,
        vertical: context.padding.p8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: symbols.expand((row) {
            return [
              ...row.map((symbol) => _SymbolButton(
                    symbol: symbol,
                    onTap: () => onSymbolTap(symbol),
                  )),
              Gap(context.spacing.s4),
            ];
          }).toList(),
        ),
      ),
    );
  }
}

class _SymbolButton extends StatelessWidget {
  final String symbol;
  final VoidCallback onTap;

  const _SymbolButton({
    required this.symbol,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Ký hiệu toán học: $symbol',
      button: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFE0E0E0),
                width: 1,
              ),
            ),
            child: Text(
              symbol,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF212121),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

