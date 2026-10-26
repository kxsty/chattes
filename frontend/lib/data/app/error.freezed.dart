// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Error {

 Object get field0;



@override
bool operator ==(Object other) {
  final _this = this as Error;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Error&&const DeepCollectionEquality().equals(other.field0, _this.field0));
}


@override
int get hashCode {
  final _this = this as Error;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.field0));
}

@override
String toString() {
  final _this = this as Error;
  return 'Error(field0: ${_this.field0})';
}


}

/// @nodoc
class $ErrorCopyWith<$Res>  {
$ErrorCopyWith(Error _, $Res Function(Error) __);
}


/// Adds pattern-matching-related methods to [Error].
extension ErrorPatterns on Error {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Error_Infrastructure value)?  infrastructure,TResult Function( Error_Validation value)?  validation,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Error_Infrastructure() when infrastructure != null:
return infrastructure(_that);case Error_Validation() when validation != null:
return validation(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Error_Infrastructure value)  infrastructure,required TResult Function( Error_Validation value)  validation,}){
final _that = this;
switch (_that) {
case Error_Infrastructure():
return infrastructure(_that);case Error_Validation():
return validation(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Error_Infrastructure value)?  infrastructure,TResult? Function( Error_Validation value)?  validation,}){
final _that = this;
switch (_that) {
case Error_Infrastructure() when infrastructure != null:
return infrastructure(_that);case Error_Validation() when validation != null:
return validation(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String field0)?  infrastructure,TResult Function( ValidationError field0)?  validation,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Error_Infrastructure() when infrastructure != null:
return infrastructure(_that.field0);case Error_Validation() when validation != null:
return validation(_that.field0);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String field0)  infrastructure,required TResult Function( ValidationError field0)  validation,}) {final _that = this;
switch (_that) {
case Error_Infrastructure():
return infrastructure(_that.field0);case Error_Validation():
return validation(_that.field0);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String field0)?  infrastructure,TResult? Function( ValidationError field0)?  validation,}) {final _that = this;
switch (_that) {
case Error_Infrastructure() when infrastructure != null:
return infrastructure(_that.field0);case Error_Validation() when validation != null:
return validation(_that.field0);case _:
  return null;

}
}

}

/// @nodoc


class Error_Infrastructure extends Error {
  const Error_Infrastructure(this.field0): super._();
  

@override final  String field0;

/// Create a copy of Error
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Error_InfrastructureCopyWith<Error_Infrastructure> get copyWith => _$Error_InfrastructureCopyWithImpl<Error_Infrastructure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Error_Infrastructure&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'Error.infrastructure(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $Error_InfrastructureCopyWith<$Res> implements $ErrorCopyWith<$Res> {
  factory $Error_InfrastructureCopyWith(Error_Infrastructure value, $Res Function(Error_Infrastructure) _then) = _$Error_InfrastructureCopyWithImpl;
@useResult
$Res call({
 String field0
});




}
/// @nodoc
class _$Error_InfrastructureCopyWithImpl<$Res>
    implements $Error_InfrastructureCopyWith<$Res> {
  _$Error_InfrastructureCopyWithImpl(this._self, this._then);

  final Error_Infrastructure _self;
  final $Res Function(Error_Infrastructure) _then;

/// Create a copy of Error
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(Error_Infrastructure(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class Error_Validation extends Error {
  const Error_Validation(this.field0): super._();
  

@override final  ValidationError field0;

/// Create a copy of Error
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Error_ValidationCopyWith<Error_Validation> get copyWith => _$Error_ValidationCopyWithImpl<Error_Validation>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is Error_Validation&&(identical(other.field0, field0) || other.field0 == field0));
}


@override
int get hashCode {
    return Object.hash(runtimeType,field0);
}

@override
String toString() {
    return 'Error.validation(field0: $field0)';
}


}

/// @nodoc
abstract mixin class $Error_ValidationCopyWith<$Res> implements $ErrorCopyWith<$Res> {
  factory $Error_ValidationCopyWith(Error_Validation value, $Res Function(Error_Validation) _then) = _$Error_ValidationCopyWithImpl;
@useResult
$Res call({
 ValidationError field0
});




}
/// @nodoc
class _$Error_ValidationCopyWithImpl<$Res>
    implements $Error_ValidationCopyWith<$Res> {
  _$Error_ValidationCopyWithImpl(this._self, this._then);

  final Error_Validation _self;
  final $Res Function(Error_Validation) _then;

/// Create a copy of Error
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field0 = null,}) {
  return _then(Error_Validation(
null == field0 ? _self.field0 : field0 // ignore: cast_nullable_to_non_nullable
as ValidationError,
  ));
}


}

// dart format on
