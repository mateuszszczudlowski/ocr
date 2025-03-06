import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/allergen.dart';
import '../../repositories/allergen_repository.dart';

// Events
abstract class AllergenEvent {}

class LoadAllergens extends AllergenEvent {}
class AddAllergen extends AllergenEvent {
  final String name;
  final String? description;

  AddAllergen({required this.name, this.description});
}
class DeleteAllergen extends AllergenEvent {
  final Allergen allergen;

  DeleteAllergen(this.allergen);
}

// States
abstract class AllergenState {}

class AllergenInitial extends AllergenState {}
class AllergenLoading extends AllergenState {}
class AllergenLoaded extends AllergenState {
  final List<Allergen> allergens;

  AllergenLoaded(this.allergens);
}
class AllergenError extends AllergenState {
  final String message;

  AllergenError(this.message);
}

// Bloc
class AllergenBloc extends Bloc<AllergenEvent, AllergenState> {
  final AllergenRepository _repository;

  AllergenBloc(this._repository) : super(AllergenInitial()) {
    on<LoadAllergens>(_onLoadAllergens);
    on<AddAllergen>(_onAddAllergen);
    on<DeleteAllergen>(_onDeleteAllergen);
  }

  Future<void> _onLoadAllergens(
    LoadAllergens event,
    Emitter<AllergenState> emit,
  ) async {
    emit(AllergenLoading());
    try {
      final allergens = _repository.getAllAllergens();
      emit(AllergenLoaded(allergens));
    } catch (e) {
      emit(AllergenError(e.toString()));
    }
  }

  Future<void> _onAddAllergen(
    AddAllergen event,
    Emitter<AllergenState> emit,
  ) async {
    try {
      await _repository.addAllergen(
        Allergen(name: event.name, description: event.description),
      );
      add(LoadAllergens());
    } catch (e) {
      emit(AllergenError(e.toString()));
    }
  }

  Future<void> _onDeleteAllergen(
    DeleteAllergen event,
    Emitter<AllergenState> emit,
  ) async {
    try {
      await _repository.removeAllergen(event.allergen);
      add(LoadAllergens());
    } catch (e) {
      emit(AllergenError(e.toString()));
    }
  }
}