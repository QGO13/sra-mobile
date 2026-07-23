import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sra_hotel/features/cart/domain/entities/cart_item_entity.dart';
import 'package:sra_hotel/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:sra_hotel/features/cart/domain/usecases/save_cart_usecase.dart';
import 'package:sra_hotel/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartUseCase getCartUseCase;
  final SaveCartUseCase saveCartUseCase;
  final ClearCartUseCase clearCartUseCase;

  final List<CartItemEntity> _cartItems = [];
  DateTime _checkIn = DateTime.now().add(const Duration(days: 1));
  DateTime _checkOut = DateTime.now().add(const Duration(days: 3));

  CartBloc({
    required this.getCartUseCase,
    required this.saveCartUseCase,
    required this.clearCartUseCase,
  }) : super(CartInitial()) {
    on<CartStarted>(_onCartStarted);
    on<CartItemAdded>(_onCartItemAdded);
    on<CartItemRemoved>(_onCartItemRemoved);
    on<CartItemUpdated>(_onCartItemUpdated);
    on<CartItemSelectionToggled>(_onCartItemSelectionToggled);
    on<CartAllItemsSelectionToggled>(_onCartAllItemsSelectionToggled);
    on<CartCleared>(_onCartCleared);
    on<CartDatesUpdated>(_onCartDatesUpdated);
  }

  Future<void> _onCartStarted(CartStarted event, Emitter<CartState> emit) async {
    final cartData = await getCartUseCase();
    if (cartData != null) {
      final items = cartData['items'] as List<CartItemEntity>;
      _checkIn = cartData['checkIn'] as DateTime;
      _checkOut = cartData['checkOut'] as DateTime;
      _cartItems.clear();
      _cartItems.addAll(items);
      emit(CartUpdated(
        items: List.from(_cartItems),
        checkIn: _checkIn,
        checkOut: _checkOut,
      ));
    }
  }

  Future<void> _onCartItemAdded(CartItemAdded event, Emitter<CartState> emit) async {
    final index = _cartItems.indexWhere((item) => item.room.id == event.room.id);
    if (index == -1) {
      _cartItems.add(
        CartItemEntity(
          room: event.room,
          checkIn: event.checkIn,
          checkOut: event.checkOut,
          extraBedIncluded: event.extraBedIncluded,
        ),
      );
      await saveCartUseCase(items: _cartItems, checkIn: _checkIn, checkOut: _checkOut);
    }
    emit(CartUpdated(
      items: List.from(_cartItems),
      checkIn: _checkIn,
      checkOut: _checkOut,
    ));
  }

  Future<void> _onCartItemRemoved(CartItemRemoved event, Emitter<CartState> emit) async {
    _cartItems.removeWhere((item) => item.room.id == event.roomId);
    await saveCartUseCase(items: _cartItems, checkIn: _checkIn, checkOut: _checkOut);
    if (_cartItems.isEmpty) {
      await clearCartUseCase();
      emit(CartInitial());
    } else {
      emit(CartUpdated(
        items: List.from(_cartItems),
        checkIn: _checkIn,
        checkOut: _checkOut,
      ));
    }
  }

  Future<void> _onCartItemUpdated(CartItemUpdated event, Emitter<CartState> emit) async {
    final index = _cartItems.indexWhere((item) => item.room.id == event.roomId);
    if (index != -1) {
      final currentItem = _cartItems[index];
      _cartItems[index] = currentItem.copyWith(
        extraBedIncluded: event.extraBedIncluded,
        breakfastIncluded: event.breakfastIncluded,
        breakfastCount: event.breakfastCount,
        isSelected: event.isSelected,
      );
      await saveCartUseCase(items: _cartItems, checkIn: _checkIn, checkOut: _checkOut);
    }
    emit(CartUpdated(
      items: List.from(_cartItems),
      checkIn: _checkIn,
      checkOut: _checkOut,
    ));
  }

  void _onCartItemSelectionToggled(CartItemSelectionToggled event, Emitter<CartState> emit) {
    final index = _cartItems.indexWhere((item) => item.room.id == event.roomId);
    if (index != -1) {
      _cartItems[index] = _cartItems[index].copyWith(isSelected: event.isSelected);
      emit(CartUpdated(
        items: List.from(_cartItems),
        checkIn: _checkIn,
        checkOut: _checkOut,
      ));
    }
  }

  void _onCartAllItemsSelectionToggled(CartAllItemsSelectionToggled event, Emitter<CartState> emit) {
    for (int i = 0; i < _cartItems.length; i++) {
      _cartItems[i] = _cartItems[i].copyWith(isSelected: event.isSelected);
    }
    emit(CartUpdated(
      items: List.from(_cartItems),
      checkIn: _checkIn,
      checkOut: _checkOut,
    ));
  }

  Future<void> _onCartCleared(CartCleared event, Emitter<CartState> emit) async {
    _cartItems.clear();
    await clearCartUseCase();
    emit(CartInitial());
  }

  Future<void> _onCartDatesUpdated(CartDatesUpdated event, Emitter<CartState> emit) async {
    _checkIn = event.checkIn;
    _checkOut = event.checkOut;
    await saveCartUseCase(items: _cartItems, checkIn: _checkIn, checkOut: _checkOut);
    if (_cartItems.isNotEmpty) {
      emit(CartUpdated(
        items: List.from(_cartItems),
        checkIn: _checkIn,
        checkOut: _checkOut,
      ));
    }
  }
}

