# Clean Architecture Guide

## Overview

This project implements Clean Architecture principles with the following layers:

1. **Presentation Layer** - UI and State Management
2. **Domain Layer** - Business Logic and Rules
3. **Data Layer** - Data Sources and Repository Implementations

## Layer Dependencies

```
Presentation → Domain ← Data
```

- Presentation depends on Domain
- Data depends on Domain
- Domain depends on nothing (pure business logic)

## Folder Structure

```
lib/
├── core/                    # Shared core functionality
│   ├── constants/          # App constants
│   ├── di/                 # Dependency injection
│   ├── error/              # Error handling
│   ├── network/            # Network utilities
│   ├── router/             # App routing
│   ├── theme/              # App theming
│   ├── utils/              # Utilities & extensions
│   └── widgets/            # Reusable widgets
├── features/               # Feature modules
│   └── [feature_name]/
│       ├── data/           # Data layer
│       │   ├── datasources/    # Remote & local data sources
│       │   ├── models/         # Data models
│       │   └── repositories/   # Repository implementations
│       ├── domain/         # Domain layer
│       │   ├── entities/       # Business entities
│       │   ├── repositories/   # Repository interfaces
│       │   └── usecases/       # Business use cases
│       └── presentation/   # Presentation layer
│           ├── bloc/           # BLoC state management
│           ├── pages/          # UI pages
│           └── widgets/        # Feature widgets
└── shared/                 # Shared UI components
    └── presentation/       # Shared pages & widgets
```

## Creating a New Feature

### 1. Create Folder Structure

```bash
mkdir -p lib/features/[feature_name]/{data,domain,presentation}
mkdir -p lib/features/[feature_name]/data/{datasources,models,repositories}
mkdir -p lib/features/[feature_name]/domain/{entities,repositories,usecases}
mkdir -p lib/features/[feature_name]/presentation/{bloc,pages,widgets}
```

### 2. Domain Layer (Start Here)

#### Entities
```dart
// lib/features/[feature]/domain/entities/[entity].dart
import 'package:equatable/equatable.dart';

class MyEntity extends Equatable {
  const MyEntity({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  List<Object> get props => [id, name];
}
```

#### Repository Interface
```dart
// lib/features/[feature]/domain/repositories/[feature]_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/my_entity.dart';

abstract class MyRepository {
  Future<Either<Failure, List<MyEntity>>> getItems();
  Future<Either<Failure, MyEntity>> getItem(String id);
}
```

#### Use Cases
```dart
// lib/features/[feature]/domain/usecases/get_items_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../entities/my_entity.dart';
import '../repositories/my_repository.dart';

@injectable
class GetItemsUseCase {
  const GetItemsUseCase(this._repository);

  final MyRepository _repository;

  Future<Either<Failure, List<MyEntity>>> call() async {
    return await _repository.getItems();
  }
}
```

### 3. Data Layer

#### Models
```dart
// lib/features/[feature]/data/models/[entity]_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/my_entity.dart';

part '[entity]_model.g.dart';

@JsonSerializable()
class MyEntityModel extends MyEntity {
  const MyEntityModel({
    required super.id,
    required super.name,
  });

  factory MyEntityModel.fromJson(Map<String, dynamic> json) =>
      _$MyEntityModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyEntityModelToJson(this);

  factory MyEntityModel.fromEntity(MyEntity entity) {
    return MyEntityModel(
      id: entity.id,
      name: entity.name,
    );
  }
}
```

#### Data Sources
```dart
// lib/features/[feature]/data/datasources/[feature]_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../models/my_entity_model.dart';

part '[feature]_remote_datasource.g.dart';

abstract class MyRemoteDataSource {
  Future<List<MyEntityModel>> getItems();
  Future<MyEntityModel> getItem(String id);
}

@RestApi()
@Injectable(as: MyRemoteDataSource)
abstract class MyRemoteDataSourceImpl implements MyRemoteDataSource {
  @factoryMethod
  factory MyRemoteDataSourceImpl(Dio dio) = _MyRemoteDataSourceImpl;

  @override
  @GET('/items')
  Future<List<MyEntityModel>> getItems();

  @override
  @GET('/items/{id}')
  Future<MyEntityModel> getItem(@Path() String id);
}
```

#### Repository Implementation
```dart
// lib/features/[feature]/data/repositories/[feature]_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/my_entity.dart';
import '../../domain/repositories/my_repository.dart';
import '../datasources/my_remote_datasource.dart';

@Injectable(as: MyRepository)
class MyRepositoryImpl implements MyRepository {
  const MyRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  final MyRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<MyEntity>>> getItems() async {
    if (await networkInfo.isConnected) {
      try {
        final models = await remoteDataSource.getItems();
        return Right(models);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, MyEntity>> getItem(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final model = await remoteDataSource.getItem(id);
        return Right(model);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
```

### 4. Presentation Layer

#### BLoC
```dart
// lib/features/[feature]/presentation/bloc/[feature]_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/my_entity.dart';
import '../../domain/usecases/get_items_usecase.dart';

part '[feature]_event.dart';
part '[feature]_state.dart';

@injectable
class MyBloc extends Bloc<MyEvent, MyState> {
  MyBloc({
    required this.getItemsUseCase,
  }) : super(const MyInitial()) {
    on<GetItemsRequested>(_onGetItemsRequested);
  }

  final GetItemsUseCase getItemsUseCase;

  Future<void> _onGetItemsRequested(
    GetItemsRequested event,
    Emitter<MyState> emit,
  ) async {
    emit(const MyLoading());

    final result = await getItemsUseCase();

    result.fold(
      (failure) => emit(MyError(message: failure.message)),
      (items) => emit(MyLoaded(items: items)),
    );
  }
}
```

#### Pages
```dart
// lib/features/[feature]/presentation/pages/[feature]_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/my_bloc.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  static const String routeName = '/my-feature';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyBloc>()..add(const GetItemsRequested()),
      child: const MyView(),
    );
  }
}

class MyView extends StatelessWidget {
  const MyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Feature'),
      ),
      body: BlocBuilder<MyBloc, MyState>(
        builder: (context, state) {
          if (state is MyLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MyError) {
            return Center(child: Text(state.message));
          } else if (state is MyLoaded) {
            return ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                final item = state.items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.id),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

### 5. Register Dependencies

Add to `lib/core/di/injection_container.dart`:

```dart
// Add imports for your new feature classes

@module
abstract class MyFeatureModule {
  // Dependencies are automatically registered via @Injectable annotations
}
```

### 6. Generate Code

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 7. Add Route

Add to `lib/core/router/app_router.dart`:

```dart
GoRoute(
  path: MyPage.routeName,
  name: 'my-feature',
  builder: (context, state) => const MyPage(),
),
```

## Best Practices

1. **Always start with the Domain layer** - Define entities, repository interfaces, and use cases first
2. **Use dependency injection** - All classes should be registered with @Injectable
3. **Handle errors properly** - Use Either<Failure, Success> pattern
4. **Write tests** - Test business logic in use cases and BLoCs
5. **Keep UI logic separate** - BLoCs should handle state, widgets should only display
6. **Use code generation** - For models, API clients, and dependency injection
7. **Follow naming conventions** - Be consistent with file and class names

## Testing

### Unit Tests
```dart
// test/features/[feature]/domain/usecases/get_items_usecase_test.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockMyRepository extends Mock implements MyRepository {}

void main() {
  late GetItemsUseCase useCase;
  late MockMyRepository mockRepository;

  setUp(() {
    mockRepository = MockMyRepository();
    useCase = GetItemsUseCase(mockRepository);
  });

  test('should get items from repository', () async {
    // arrange
    final items = [MyEntity(id: '1', name: 'Test')];
    when(() => mockRepository.getItems())
        .thenAnswer((_) async => Right(items));

    // act
    final result = await useCase();

    // assert
    expect(result, Right(items));
    verify(() => mockRepository.getItems()).called(1);
  });
}
```

### BLoC Tests
```dart
// test/features/[feature]/presentation/bloc/my_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetItemsUseCase extends Mock implements GetItemsUseCase {}

void main() {
  late MyBloc bloc;
  late MockGetItemsUseCase mockGetItemsUseCase;

  setUp(() {
    mockGetItemsUseCase = MockGetItemsUseCase();
    bloc = MyBloc(getItemsUseCase: mockGetItemsUseCase);
  });

  blocTest<MyBloc, MyState>(
    'emits [MyLoading, MyLoaded] when GetItemsRequested is successful',
    build: () {
      when(() => mockGetItemsUseCase())
          .thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(const GetItemsRequested()),
    expect: () => [
      const MyLoading(),
      const MyLoaded(items: []),
    ],
  );
}
```

This architecture ensures:
- **Separation of Concerns** - Each layer has a specific responsibility
- **Testability** - Business logic is isolated and easily testable
- **Maintainability** - Changes in one layer don't affect others
- **Scalability** - Easy to add new features following the same pattern
