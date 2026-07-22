import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sra_hotel/core/database/local_database.dart';
import 'package:sra_hotel/core/network/api_client.dart';
import 'package:sra_hotel/core/network/api_cache.dart';

// Cart Feature Imports
import 'package:sra_hotel/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:sra_hotel/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:sra_hotel/features/cart/domain/repositories/cart_repository.dart';
import 'package:sra_hotel/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:sra_hotel/features/cart/domain/usecases/save_cart_usecase.dart';
import 'package:sra_hotel/features/cart/domain/usecases/clear_cart_usecase.dart';

// Auth Feature Imports
import 'package:sra_hotel/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:sra_hotel/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sra_hotel/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sra_hotel/features/auth/domain/repositories/auth_repository.dart';
import 'package:sra_hotel/features/auth/domain/usecases/login_usecase.dart';
import 'package:sra_hotel/features/auth/domain/usecases/register_usecase.dart';
import 'package:sra_hotel/features/auth/presentation/bloc/auth_bloc.dart';

// Backoffice Modular Feature Imports
// KPIs
import 'package:sra_hotel/features/backoffice_kpis/data/datasources/kpi_remote_data_source.dart';
import 'package:sra_hotel/features/backoffice_kpis/data/repositories/kpi_repository_impl.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/repositories/kpi_repository.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/usecases/get_kpis_usecase.dart';
import 'package:sra_hotel/features/backoffice_kpis/domain/usecases/get_history_usecase.dart';
import 'package:sra_hotel/features/backoffice_kpis/presentation/bloc/kpi_bloc.dart';

// Room Management
import 'package:sra_hotel/features/room_management/data/datasources/room_remote_data_source.dart';
import 'package:sra_hotel/features/room_management/data/repositories/room_repository_impl.dart';
import 'package:sra_hotel/features/room_management/domain/repositories/room_repository.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/get_rooms_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/create_room_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/update_room_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/delete_room_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/get_room_types_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/create_room_type_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/update_room_type_usecase.dart';
import 'package:sra_hotel/features/room_management/domain/usecases/delete_room_type_usecase.dart';
import 'package:sra_hotel/features/room_management/presentation/bloc/room_bloc.dart';

// Service Management
import 'package:sra_hotel/features/service_management/data/datasources/service_remote_data_source.dart';
import 'package:sra_hotel/features/service_management/data/repositories/service_repository_impl.dart';
import 'package:sra_hotel/features/service_management/domain/repositories/service_repository.dart';
import 'package:sra_hotel/features/service_management/domain/usecases/get_services_usecase.dart';
import 'package:sra_hotel/features/service_management/domain/usecases/create_service_usecase.dart';
import 'package:sra_hotel/features/service_management/domain/usecases/update_service_usecase.dart';
import 'package:sra_hotel/features/service_management/domain/usecases/delete_service_usecase.dart';
import 'package:sra_hotel/features/service_management/presentation/bloc/service_bloc.dart';

// User Management
import 'package:sra_hotel/features/user_management/data/datasources/user_remote_data_source.dart';
import 'package:sra_hotel/features/user_management/data/repositories/user_repository_impl.dart';
import 'package:sra_hotel/features/user_management/domain/repositories/user_repository.dart';
import 'package:sra_hotel/features/user_management/domain/usecases/get_users_usecase.dart';
import 'package:sra_hotel/features/user_management/domain/usecases/create_user_usecase.dart';
import 'package:sra_hotel/features/user_management/domain/usecases/update_user_usecase.dart';
import 'package:sra_hotel/features/user_management/domain/usecases/delete_user_usecase.dart';
import 'package:sra_hotel/features/user_management/presentation/bloc/user_bloc.dart';

// Reservation Management
import 'package:sra_hotel/features/reservation_management/data/datasources/booking_remote_data_source.dart' as res_ds;
import 'package:sra_hotel/features/reservation_management/data/repositories/booking_repository_impl.dart' as res_repo_impl;
import 'package:sra_hotel/features/reservation_management/domain/repositories/booking_repository.dart' as res_repo;
import 'package:sra_hotel/features/reservation_management/domain/usecases/get_bookings_usecase.dart' as res_uc_get;
import 'package:sra_hotel/features/reservation_management/domain/usecases/update_booking_usecase.dart' as res_uc_up;
import 'package:sra_hotel/features/reservation_management/domain/usecases/cancel_booking_usecase.dart' as res_uc_can;
import 'package:sra_hotel/features/reservation_management/domain/usecases/update_booking_line_usecase.dart' as res_uc_line;
import 'package:sra_hotel/features/reservation_management/domain/usecases/apply_global_discount_usecase.dart' as res_uc_disc;
import 'package:sra_hotel/features/reservation_management/domain/usecases/pay_booking_usecase.dart' as res_uc_pay;
import 'package:sra_hotel/features/reservation_management/presentation/bloc/admin_booking_bloc.dart';

// Reception Desk
import 'package:sra_hotel/features/reception/data/datasources/reception_remote_data_source.dart';
import 'package:sra_hotel/features/reception/data/repositories/reception_repository_impl.dart';
import 'package:sra_hotel/features/reception/domain/repositories/reception_repository.dart';
import 'package:sra_hotel/features/reception/domain/usecases/get_arrivals_usecase.dart';
import 'package:sra_hotel/features/reception/domain/usecases/get_departures_usecase.dart';
import 'package:sra_hotel/features/reception/domain/usecases/perform_checkin_usecase.dart';
import 'package:sra_hotel/features/reception/domain/usecases/perform_checkout_usecase.dart';
import 'package:sra_hotel/features/reception/domain/usecases/get_reception_rooms_usecase.dart';
import 'package:sra_hotel/features/reception/presentation/bloc/reception_bloc.dart';

// Invoices / Billing
import 'package:sra_hotel/features/invoice_management/data/datasources/invoice_remote_data_source.dart';
import 'package:sra_hotel/features/invoice_management/data/repositories/invoice_repository_impl.dart';
import 'package:sra_hotel/features/invoice_management/domain/repositories/invoice_repository.dart';
import 'package:sra_hotel/features/invoice_management/domain/usecases/get_invoices_usecase.dart';
import 'package:sra_hotel/features/invoice_management/presentation/bloc/invoice_bloc.dart';

// Booking Feature Imports
import 'package:sra_hotel/features/room_search/data/datasources/booking_local_data_source.dart';
import 'package:sra_hotel/features/room_search/data/datasources/booking_remote_data_source.dart';
import 'package:sra_hotel/features/room_search/data/repositories/booking_repository_impl.dart';
import 'package:sra_hotel/features/room_search/domain/repositories/booking_repository.dart';
import 'package:sra_hotel/features/room_search/domain/usecases/search_rooms_usecase.dart';
import 'package:sra_hotel/features/room_search/domain/usecases/verify_availability_usecase.dart';
import 'package:sra_hotel/features/room_search/presentation/bloc/booking_bloc.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:sra_hotel/features/cart/presentation/bloc/cart_event.dart';
import 'package:sra_hotel/features/checkout/presentation/bloc/payment_bloc.dart';
import 'package:sra_hotel/features/checkout/domain/repositories/payment_repository.dart';
import 'package:sra_hotel/features/checkout/data/repositories/payment_repository_impl.dart';
import 'package:sra_hotel/features/checkout/domain/usecases/payment_usecases.dart';
import 'package:sra_hotel/features/checkout/data/datasources/payment_remote_data_source.dart';

// Client Booking Feature Imports
import 'package:sra_hotel/features/client_booking/data/datasources/client_booking_remote_datasource.dart';
import 'package:sra_hotel/features/client_booking/data/repositories/client_booking_repository_impl.dart';
import 'package:sra_hotel/features/client_booking/domain/repositories/client_booking_repository.dart';
import 'package:sra_hotel/features/client_booking/domain/usecases/get_booking_room_types_usecase.dart';
import 'package:sra_hotel/features/client_booking/domain/usecases/check_type_availability_usecase.dart';
import 'package:sra_hotel/features/client_booking/presentation/bloc/client_booking_bloc.dart';

// Room Assignment Feature Imports
import 'package:sra_hotel/features/room_assignment/data/datasources/room_assignment_remote_datasource.dart';
import 'package:sra_hotel/features/room_assignment/data/repositories/room_assignment_repository_impl.dart';
import 'package:sra_hotel/features/room_assignment/domain/repositories/room_assignment_repository.dart';
import 'package:sra_hotel/features/room_assignment/domain/usecases/get_assignment_data_usecase.dart';
import 'package:sra_hotel/features/room_assignment/domain/usecases/update_assignment_usecase.dart';
import 'package:sra_hotel/features/room_assignment/presentation/bloc/room_assignment_bloc.dart';

// Equipment Management Feature Imports
import 'package:sra_hotel/features/equipment_management/data/datasources/equipment_remote_data_source.dart';
import 'package:sra_hotel/features/equipment_management/data/repositories/equipment_repository_impl.dart';
import 'package:sra_hotel/features/equipment_management/domain/repositories/equipment_repository.dart';
import 'package:sra_hotel/features/equipment_management/domain/usecases/get_equipments_usecase.dart';
import 'package:sra_hotel/features/equipment_management/domain/usecases/create_equipment_usecase.dart';
import 'package:sra_hotel/features/equipment_management/domain/usecases/update_equipment_usecase.dart';
import 'package:sra_hotel/features/equipment_management/domain/usecases/delete_equipment_usecase.dart';
import 'package:sra_hotel/features/equipment_management/presentation/bloc/equipment_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Cart
  sl.registerLazySingleton(
    () => CartBloc(
      getCartUseCase: sl(),
      saveCartUseCase: sl(),
      clearCartUseCase: sl(),
    )..add(CartStarted()),
  );
  sl.registerLazySingleton(() => GetCartUseCase(sl()));
  sl.registerLazySingleton(() => SaveCartUseCase(sl()));
  sl.registerLazySingleton(() => ClearCartUseCase(sl()));
  sl.registerLazySingleton<ICartRepository>(
    () => CartRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<CartLocalDataSource>(
    () => CartLocalDataSourceImpl(secureStorage: sl()),
  );
  
  // Features - Payment (Module 6)
  sl.registerFactory(
    () => PaymentBloc(
      initiatePaymentUseCase: sl(),
      verifyPaymentStatusUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => InitiatePaymentUseCase(repository: sl()));
  sl.registerLazySingleton(() => VerifyPaymentStatusUseCase(repository: sl()));
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(
      remoteDataSource: sl(),
      localDatabase: sl(),
    ),
  );
  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(apiClient: sl()),
  );
  
  sl.registerFactory(
    () => BookingBloc(
      searchRoomsUseCase: sl(),
      verifyAvailabilityUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => SearchRoomsUseCase(sl()));
  sl.registerLazySingleton(() => VerifyAvailabilityUseCase(sl()));
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<BookingLocalDataSource>(
    () => BookingLocalDataSourceImpl(localDatabase: sl()),
  );

  // Features - Client Booking
  sl.registerFactory(
    () => ClientBookingBloc(
      getRoomTypesUseCase: sl(),
      checkTypeAvailabilityUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetBookingRoomTypesUseCase(sl()));
  sl.registerLazySingleton(() => CheckTypeAvailabilityUseCase(sl()));
  sl.registerLazySingleton<ClientBookingRepository>(
    () => ClientBookingRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ClientBookingRemoteDataSource>(
    () => ClientBookingRemoteDataSourceImpl(apiClient: sl()),
  );

  // Features - Auth
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      authRepository: sl(),
    ),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      secureStorage: sl(),
      localDatabase: sl(),
    ),
  );

  // Features - Modular Backoffice
  // 1. KPIs
  sl.registerFactory(
    () => KpiBloc(
      getKpisUseCase: sl(),
      getHistoryUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetKpisUseCase(sl()));
  sl.registerLazySingleton(() => GetHistoryUseCase(sl()));
  sl.registerLazySingleton<KpiRepository>(
    () => KpiRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<KpiRemoteDataSource>(
    () => KpiRemoteDataSourceImpl(apiClient: sl(), apiCache: sl()),
  );

  // 2. Room Management
  sl.registerFactory(
    () => RoomBloc(
      getRoomsUseCase: sl(),
      createRoomUseCase: sl(),
      updateRoomUseCase: sl(),
      deleteRoomUseCase: sl(),
      getRoomTypesUseCase: sl(),
      createRoomTypeUseCase: sl(),
      updateRoomTypeUseCase: sl(),
      deleteRoomTypeUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetRoomsUseCase(sl()));
  sl.registerLazySingleton(() => CreateRoomUseCase(sl()));
  sl.registerLazySingleton(() => UpdateRoomUseCase(sl()));
  sl.registerLazySingleton(() => DeleteRoomUseCase(sl()));
  sl.registerLazySingleton(() => GetRoomTypesUseCase(sl()));
  sl.registerLazySingleton(() => CreateRoomTypeUseCase(sl()));
  sl.registerLazySingleton(() => UpdateRoomTypeUseCase(sl()));
  sl.registerLazySingleton(() => DeleteRoomTypeUseCase(sl()));
  sl.registerLazySingleton<RoomRepository>(
    () => RoomRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<RoomRemoteDataSource>(
    () => RoomRemoteDataSourceImpl(apiClient: sl(), apiCache: sl()),
  );

  // 3. Service Management
  sl.registerFactory(
    () => ServiceBloc(
      getServicesUseCase: sl(),
      createServiceUseCase: sl(),
      updateServiceUseCase: sl(),
      deleteServiceUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetServicesUseCase(sl()));
  sl.registerLazySingleton(() => CreateServiceUseCase(sl()));
  sl.registerLazySingleton(() => UpdateServiceUseCase(sl()));
  sl.registerLazySingleton(() => DeleteServiceUseCase(sl()));
  sl.registerLazySingleton<ServiceRepository>(
    () => ServiceRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ServiceRemoteDataSource>(
    () => ServiceRemoteDataSourceImpl(apiClient: sl(), apiCache: sl()),
  );

  // 4. User Management
  sl.registerFactory(
    () => UserBloc(
      getUsersUseCase: sl(),
      createUserUseCase: sl(),
      updateUserUseCase: sl(),
      deleteUserUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));
  sl.registerLazySingleton(() => CreateUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUserUseCase(sl()));
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(apiClient: sl(), apiCache: sl()),
  );

  // 5. Reservation Management
  sl.registerFactory(
    () => AdminBookingBloc(
      getBookingsUseCase: sl(),
      updateBookingUseCase: sl(),
      cancelBookingUseCase: sl(),
      updateBookingLineUseCase: sl(),
      applyGlobalDiscountUseCase: sl(),
      payBookingUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => res_uc_get.GetBookingsUseCase(sl()));
  sl.registerLazySingleton(() => res_uc_up.UpdateBookingUseCase(sl()));
  sl.registerLazySingleton(() => res_uc_can.CancelBookingUseCase(sl()));
  sl.registerLazySingleton(() => res_uc_line.UpdateBookingLineUseCase(sl()));
  sl.registerLazySingleton(() => res_uc_disc.ApplyGlobalDiscountUseCase(sl()));
  sl.registerLazySingleton(() => res_uc_pay.PayBookingUseCase(sl()));
  sl.registerLazySingleton<res_repo.BookingRepository>(
    () => res_repo_impl.BookingRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<res_ds.BookingRemoteDataSource>(
    () => res_ds.BookingRemoteDataSourceImpl(apiClient: sl(), apiCache: sl()),
  );

  // 6. Reception Desk
  sl.registerFactory(
    () => ReceptionBloc(
      getArrivalsUseCase: sl(),
      getDeparturesUseCase: sl(),
      performCheckInUseCase: sl(),
      performCheckOutUseCase: sl(),
      getReceptionRoomsUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetArrivalsUseCase(sl()));
  sl.registerLazySingleton(() => GetDeparturesUseCase(sl()));
  sl.registerLazySingleton(() => PerformCheckInUseCase(sl()));
  sl.registerLazySingleton(() => PerformCheckOutUseCase(sl()));
  sl.registerLazySingleton(() => GetReceptionRoomsUseCase(sl()));
  sl.registerLazySingleton<ReceptionRepository>(
    () => ReceptionRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ReceptionRemoteDataSource>(
    () => ReceptionRemoteDataSourceImpl(apiClient: sl()),
  );

  // 7. Invoices / Billing
  sl.registerFactory(
    () => InvoiceBloc(
      getInvoicesUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetInvoicesUseCase(sl()));
  sl.registerLazySingleton<InvoiceRepository>(
    () => InvoiceRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<InvoiceRemoteDataSource>(
    () => InvoiceRemoteDataSourceImpl(apiClient: sl(), apiCache: sl()),
  );

  // 8. Room Assignment Management
  sl.registerFactory(
    () => RoomAssignmentBloc(
      getAssignmentDataUseCase: sl(),
      updateAssignmentUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetAssignmentDataUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAssignmentUseCase(sl()));
  sl.registerLazySingleton<RoomAssignmentRepository>(
    () => RoomAssignmentRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<RoomAssignmentRemoteDataSource>(
    () => RoomAssignmentRemoteDataSourceImpl(apiClient: sl(), apiCache: sl()),
  );

  // 9. Equipment Management
  sl.registerFactory(
    () => EquipmentBloc(
      getEquipmentsUseCase: sl(),
      createEquipmentUseCase: sl(),
      updateEquipmentUseCase: sl(),
      deleteEquipmentUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => GetEquipmentsUseCase(repository: sl()));
  sl.registerLazySingleton(() => CreateEquipmentUseCase(repository: sl()));
  sl.registerLazySingleton(() => UpdateEquipmentUseCase(repository: sl()));
  sl.registerLazySingleton(() => DeleteEquipmentUseCase(repository: sl()));
  sl.registerLazySingleton<EquipmentRepository>(
    () => EquipmentRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<EquipmentRemoteDataSource>(
    () => EquipmentRemoteDataSourceImpl(apiClient: sl(), apiCache: sl()),
  );

  // Core
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(dio: sl(), secureStorage: sl()),
  );
  
  // Local Database
  final localDatabase = LocalDatabase();
  // Ensure the database is initialized (only on mobile/desktop)
  if (!kIsWeb) {
    await localDatabase.database;
  }
  sl.registerLazySingleton<LocalDatabase>(() => localDatabase);

  sl.registerLazySingleton<ApiCache>(() => ApiCache(localDatabase: sl()));

  // External / Third-party
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage());
}

