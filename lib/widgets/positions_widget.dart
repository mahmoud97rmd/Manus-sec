import 'package:flutter/material.dart';
import '../models/position.dart';

class PositionsWidget extends StatelessWidget {
  final List<Position> positions;
  final String title;

  const PositionsWidget({
    Key? key,
    required this.positions,
    required this.title,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: positions.length,
            itemBuilder: (context, index) {
              final position = positions[index];
              return _buildPositionItem(position);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPositionItem(Position position) {
    final isProfit = position.isProfit;
    final profitColor = isProfit ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                position.type == PositionType.buy ? 'BUY' : 'SELL',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: position.type == PositionType.buy ? Colors.blue : Colors.red,
                ),
              ),
              Text(
                '${position.lots} lots',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Entry: ${position.entryPrice.toStringAsFixed(5)}',
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                'Current: ${position.currentPrice.toStringAsFixed(5)}',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'P/L: \$${position.profitLoss.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: profitColor,
                ),
              ),
              Text(
                '${position.profitLossPercent.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: profitColor,
                ),
              ),
            ],
          ),
          if (position.takeProfit != null || position.stopLoss != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (position.takeProfit != null)
                    Text(
                      'TP: ${position.takeProfit!.toStringAsFixed(5)}',
                      style: const TextStyle(fontSize: 11, color: Colors.green),
                    ),
                  if (position.stopLoss != null)
                    Text(
                      'SL: ${position.stopLoss!.toStringAsFixed(5)}',
                      style: const TextStyle(fontSize: 11, color: Colors.red),
                    ),
                ],
              ),
            ),
          if (position.isClosed && position.closeTime != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Closed: ${position.closeTime!.toString().split('.')[0]}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
