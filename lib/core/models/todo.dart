import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

/// {@template todo_item}
/// A single `todo` item.
///
/// Contains a [title], [description] and [id], in addition to a [isCompleted]
/// flag.
///
/// If an [id] is provided, it cannot be empty. If no [id] is provided, one
/// will be generated.
///
/// [Todo]s are immutable and can be copied using [copyWith], in addition to
/// being serialized and deserialized using [toJson] and [fromJson]
/// respectively.
/// {@endtemplate}
@immutable
class Todo extends Equatable {
  /// {@macro todo_item}
  Todo({
    required this.title,
    String? id,
    this.description = '',
    this.isCompleted = false,
  }) : assert(
         id == null || id.isNotEmpty,
         'id must either be null or not empty',
       ),
       id = id ?? const Uuid().v4();

  factory Todo.fromJson(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  /// The unique identifier of the `todo`.
  ///
  /// Cannot be empty.
  final String id;

  /// The title of the `todo`.
  ///
  /// Note that the title may be empty.
  final String title;

  /// The description of the `todo`.
  ///
  /// Defaults to an empty string.
  final String description;

  /// Whether the `todo` is completed.
  ///
  /// Defaults to `false`.
  final bool isCompleted;

  /// Returns a copy of this `todo` with the given values updated.
  ///
  /// {@macro todo_item}
  Todo copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };

  @override
  List<Object> get props => [id, title, description, isCompleted];
}
