import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:milktea/bloc/order_history_bloc.dart';
import 'package:milktea/common_widget/order_history_card_widget.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late OrderHistoryBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = OrderHistoryBloc();
    bloc.getOrderHistory();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocProvider<OrderHistoryBloc>(
          create: (BuildContext context) => bloc,
          child: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
            builder: (context, state) {
              return Column(
                children: [
                  Container(
                    height: 40,
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Lịch sử đơn hàng',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).primaryColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Iconsax.arrow_left,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.grey),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return OrderHistoryCardWidget(
                          orderModel: state.listOrder[index],
                        );
                      },
                      itemCount: state.listOrder.length,
                      shrinkWrap: true,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
