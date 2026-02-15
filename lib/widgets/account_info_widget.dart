import 'package:flutter/material.dart';

class AccountInfoWidget extends StatelessWidget {
  final double balance;
  final double equity;
  final double margin;
  final double marginLevel;
  final double floatingPL;

  const AccountInfoWidget({
    Key? key,
    required this.balance,
    required this.equity,
    required this.margin,
    required this.marginLevel,
    required this.floatingPL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem('Balance', '\$${balance.toStringAsFixed(2)}'),
              _buildInfoItem('Equity', '\$${equity.toStringAsFixed(2)}'),
              _buildInfoItem('Margin', '\$${margin.toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem(
                'Margin Level',
                '${marginLevel.toStringAsFixed(2)}%',
                color: marginLevel < 100 ? Colors.red : Colors.green,
              ),
              _buildInfoItem(
                'Floating P/L',
                '\$${floatingPL.toStringAsFixed(2)}',
                color: floatingPL >= 0 ? Colors.green : Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
