import 'package:equatable/equatable.dart';

import '../../model/add_wallet.dart';
import '../../model/get_wallet.dart';

abstract class RazorpayPaymentState extends Equatable {
  const RazorpayPaymentState();

  @override
  List<Object> get props => [];
}

class RazorpayPaymentInitial extends RazorpayPaymentState {}

class RazorpayPaymentLoading extends RazorpayPaymentState {}

class RazorpayPaymentSuccess extends RazorpayPaymentState {
  final AddWallet addWallet;

  const RazorpayPaymentSuccess(this.addWallet);

  @override
  List<Object> get props => [addWallet];
}

class RazorpayPaymentWalletFetched extends RazorpayPaymentState {
  final GetWallet wallet;

  const RazorpayPaymentWalletFetched(this.wallet);

  @override
  List<Object> get props => [wallet];
}

class RazorpayPaymentFailure extends RazorpayPaymentState {
  final String error;

  const RazorpayPaymentFailure(this.error);

  @override
  List<Object> get props => [error];
}
