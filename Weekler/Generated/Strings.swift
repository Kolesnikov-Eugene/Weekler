// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  internal enum LaunchScreen {
    }
  internal enum Localizable {
    internal enum Calendar {
      internal enum Full {
        /// Пятница
        internal static let friday = L10n.tr("Localizable", "Calendar.full.friday", fallback: "Пятница")
        /// Понедельник
        internal static let monday = L10n.tr("Localizable", "Calendar.full.monday", fallback: "Понедельник")
        /// Суббота
        internal static let saturday = L10n.tr("Localizable", "Calendar.full.saturday", fallback: "Суббота")
        /// Воскресенье
        internal static let sunday = L10n.tr("Localizable", "Calendar.full.sunday", fallback: "Воскресенье")
        /// Четверг
        internal static let thursday = L10n.tr("Localizable", "Calendar.full.thursday", fallback: "Четверг")
        /// Вторник
        internal static let tuesday = L10n.tr("Localizable", "Calendar.full.tuesday", fallback: "Вторник")
        /// Среда
        internal static let wednesday = L10n.tr("Localizable", "Calendar.full.wednesday", fallback: "Среда")
      }
      internal enum Short {
        /// Пт
        internal static let friday = L10n.tr("Localizable", "Calendar.short.friday", fallback: "Пт")
        /// Пн
        internal static let monday = L10n.tr("Localizable", "Calendar.short.monday", fallback: "Пн")
        /// Сб
        internal static let saturday = L10n.tr("Localizable", "Calendar.short.saturday", fallback: "Сб")
        /// Вс
        internal static let sunday = L10n.tr("Localizable", "Calendar.short.sunday", fallback: "Вс")
        /// Чт
        internal static let thursday = L10n.tr("Localizable", "Calendar.short.thursday", fallback: "Чт")
        /// Вт
        internal static let tuesday = L10n.tr("Localizable", "Calendar.short.tuesday", fallback: "Вт")
        /// Ср
        internal static let wednesday = L10n.tr("Localizable", "Calendar.short.wednesday", fallback: "Ср")
      }
    }
    internal enum CreateSchedule {
      /// Готово
      internal static let doneButtonText = L10n.tr("Localizable", "CreateSchedule.doneButtonText", fallback: "Готово")
      /// Введите Вашу задачу...
      internal static let placeholder = L10n.tr("Localizable", "CreateSchedule.placeholder", fallback: "Введите Вашу задачу...")
    }
    internal enum RepeatedDays {
      /// Выбрать числа
      internal static let byDate = L10n.tr("Localizable", "RepeatedDays.byDate", fallback: "Выбрать числа")
      /// По дням недели
      internal static let byDay = L10n.tr("Localizable", "RepeatedDays.byDay", fallback: "По дням недели")
    }
    internal enum Schedule {
      /// Дата
      internal static let date = L10n.tr("Localizable", "Schedule.date", fallback: "Дата")
      /// Уведомление
      internal static let notification = L10n.tr("Localizable", "Schedule.notification", fallback: "Уведомление")
      /// Повтор
      internal static let `repeat` = L10n.tr("Localizable", "Schedule.repeat", fallback: "Повтор")
      /// Время
      internal static let time = L10n.tr("Localizable", "Schedule.time", fallback: "Время")
    }
    internal enum Tab {
      /// Настройки
      internal static let config = L10n.tr("Localizable", "Tab.config", fallback: "Настройки")
      /// Запланировать
      internal static let edit = L10n.tr("Localizable", "Tab.edit", fallback: "Запланировать")
      /// Расписание
      internal static let schedule = L10n.tr("Localizable", "Tab.schedule", fallback: "Расписание")
      /// Статистика
      internal static let statistics = L10n.tr("Localizable", "Tab.statistics", fallback: "Статистика")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
