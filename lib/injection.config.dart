// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'data/repository/user_repository.dart' as _i762;
import 'data/services/user_api_service.dart' as _i621;
import 'viewmodels/cubit/product_cubit.dart' as _i125;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.lazySingleton<_i621.UserApiService>(() => _i621.IUserApiService());
  gh.lazySingleton<_i762.UserRepository>(
    () => _i762.IUserRepository(gh<_i621.UserApiService>()),
  );
  gh.factory<_i125.ProductCubit>(
    () => _i125.ProductCubit(gh<_i762.UserRepository>()),
  );
  return getIt;
}
