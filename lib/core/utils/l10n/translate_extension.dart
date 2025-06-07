import 'package:flutter/material.dart';
import 'package:todo_project/core/utils/l10n/app_localizations.dart';

extension TranslateX on BuildContext {
  AppLocalizations get translate => AppLocalizations.of(this)!;
}
