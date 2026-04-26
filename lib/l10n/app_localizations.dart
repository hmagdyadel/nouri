import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Agpeya'**
  String get appTitle;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @agpeyaTab.
  ///
  /// In en, this message translates to:
  /// **'Agpeya'**
  String get agpeyaTab;

  /// No description provided for @gospelTab.
  ///
  /// In en, this message translates to:
  /// **'Gospel'**
  String get gospelTab;

  /// No description provided for @competitionTab.
  ///
  /// In en, this message translates to:
  /// **'Competition'**
  String get competitionTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @greeting_morning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greeting_morning;

  /// No description provided for @greeting_afternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greeting_afternoon;

  /// No description provided for @greeting_evening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greeting_evening;

  /// No description provided for @daily_card_title.
  ///
  /// In en, this message translates to:
  /// **'Daily Prayer Card'**
  String get daily_card_title;

  /// No description provided for @start_prayer_btn.
  ///
  /// In en, this message translates to:
  /// **'Start Prayer'**
  String get start_prayer_btn;

  /// No description provided for @todays_progress.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Progress'**
  String get todays_progress;

  /// No description provided for @your_streak.
  ///
  /// In en, this message translates to:
  /// **'Your streak'**
  String get your_streak;

  /// No description provided for @weekly_rank.
  ///
  /// In en, this message translates to:
  /// **'Weekly rank'**
  String get weekly_rank;

  /// No description provided for @points_today.
  ///
  /// In en, this message translates to:
  /// **'Points today'**
  String get points_today;

  /// No description provided for @agpeya_title.
  ///
  /// In en, this message translates to:
  /// **'Agpeya'**
  String get agpeya_title;

  /// No description provided for @hour_prime.
  ///
  /// In en, this message translates to:
  /// **'Prime'**
  String get hour_prime;

  /// No description provided for @hour_terce.
  ///
  /// In en, this message translates to:
  /// **'Terce'**
  String get hour_terce;

  /// No description provided for @hour_sext.
  ///
  /// In en, this message translates to:
  /// **'Sext'**
  String get hour_sext;

  /// No description provided for @hour_none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get hour_none;

  /// No description provided for @hour_vespers.
  ///
  /// In en, this message translates to:
  /// **'Vespers'**
  String get hour_vespers;

  /// No description provided for @hour_compline.
  ///
  /// In en, this message translates to:
  /// **'Compline'**
  String get hour_compline;

  /// No description provided for @hour_midnight.
  ///
  /// In en, this message translates to:
  /// **'Midnight'**
  String get hour_midnight;

  /// No description provided for @theme_incarnation.
  ///
  /// In en, this message translates to:
  /// **'Incarnation'**
  String get theme_incarnation;

  /// No description provided for @theme_holy_spirit.
  ///
  /// In en, this message translates to:
  /// **'Holy Spirit descent'**
  String get theme_holy_spirit;

  /// No description provided for @theme_crucifixion.
  ///
  /// In en, this message translates to:
  /// **'Crucifixion'**
  String get theme_crucifixion;

  /// No description provided for @theme_death.
  ///
  /// In en, this message translates to:
  /// **'Death of Christ'**
  String get theme_death;

  /// No description provided for @theme_removal.
  ///
  /// In en, this message translates to:
  /// **'Removal from Cross'**
  String get theme_removal;

  /// No description provided for @theme_burial.
  ///
  /// In en, this message translates to:
  /// **'Burial'**
  String get theme_burial;

  /// No description provided for @theme_second_coming.
  ///
  /// In en, this message translates to:
  /// **'Second Coming'**
  String get theme_second_coming;

  /// No description provided for @estimated_duration.
  ///
  /// In en, this message translates to:
  /// **'Estimated duration'**
  String get estimated_duration;

  /// No description provided for @completed_today.
  ///
  /// In en, this message translates to:
  /// **'Completed today'**
  String get completed_today;

  /// No description provided for @start_reading.
  ///
  /// In en, this message translates to:
  /// **'Start reading'**
  String get start_reading;

  /// No description provided for @tab_arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get tab_arabic;

  /// No description provided for @tab_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get tab_english;

  /// No description provided for @tab_coptic.
  ///
  /// In en, this message translates to:
  /// **'Coptic'**
  String get tab_coptic;

  /// No description provided for @font_size.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get font_size;

  /// No description provided for @auto_scroll.
  ///
  /// In en, this message translates to:
  /// **'Auto scroll'**
  String get auto_scroll;

  /// No description provided for @audio_player.
  ///
  /// In en, this message translates to:
  /// **'Audio player'**
  String get audio_player;

  /// No description provided for @prayer_complete.
  ///
  /// In en, this message translates to:
  /// **'Prayer complete'**
  String get prayer_complete;

  /// No description provided for @points_earned.
  ///
  /// In en, this message translates to:
  /// **'Points earned'**
  String get points_earned;

  /// No description provided for @new_streak.
  ///
  /// In en, this message translates to:
  /// **'New streak'**
  String get new_streak;

  /// No description provided for @mark_complete_btn.
  ///
  /// In en, this message translates to:
  /// **'Mark complete'**
  String get mark_complete_btn;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations'**
  String get congratulations;

  /// No description provided for @gospel_title.
  ///
  /// In en, this message translates to:
  /// **'Gospel'**
  String get gospel_title;

  /// No description provided for @todays_reading.
  ///
  /// In en, this message translates to:
  /// **'Today\'s reading'**
  String get todays_reading;

  /// No description provided for @read_gospel_btn.
  ///
  /// In en, this message translates to:
  /// **'I read today\'s Gospel'**
  String get read_gospel_btn;

  /// No description provided for @gospel_completed.
  ///
  /// In en, this message translates to:
  /// **'Gospel completed'**
  String get gospel_completed;

  /// No description provided for @share_verse.
  ///
  /// In en, this message translates to:
  /// **'Share verse'**
  String get share_verse;

  /// No description provided for @competition_title.
  ///
  /// In en, this message translates to:
  /// **'Competition'**
  String get competition_title;

  /// No description provided for @tab_weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get tab_weekly;

  /// No description provided for @tab_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get tab_monthly;

  /// No description provided for @tab_alltime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get tab_alltime;

  /// No description provided for @leaderboard_global.
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get leaderboard_global;

  /// No description provided for @leaderboard_church.
  ///
  /// In en, this message translates to:
  /// **'Church'**
  String get leaderboard_church;

  /// No description provided for @leaderboard_family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get leaderboard_family;

  /// No description provided for @next_reset.
  ///
  /// In en, this message translates to:
  /// **'Next reset'**
  String get next_reset;

  /// No description provided for @your_rank.
  ///
  /// In en, this message translates to:
  /// **'Your rank'**
  String get your_rank;

  /// No description provided for @join_church.
  ///
  /// In en, this message translates to:
  /// **'Join church'**
  String get join_church;

  /// No description provided for @join_family.
  ///
  /// In en, this message translates to:
  /// **'Join family'**
  String get join_family;

  /// No description provided for @create_family.
  ///
  /// In en, this message translates to:
  /// **'Create family'**
  String get create_family;

  /// No description provided for @enter_church_code.
  ///
  /// In en, this message translates to:
  /// **'Enter church code'**
  String get enter_church_code;

  /// No description provided for @invite_link.
  ///
  /// In en, this message translates to:
  /// **'Invite link'**
  String get invite_link;

  /// No description provided for @rank_1.
  ///
  /// In en, this message translates to:
  /// **'1st'**
  String get rank_1;

  /// No description provided for @rank_2.
  ///
  /// In en, this message translates to:
  /// **'2nd'**
  String get rank_2;

  /// No description provided for @rank_3.
  ///
  /// In en, this message translates to:
  /// **'3rd'**
  String get rank_3;

  /// No description provided for @profile_title.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile_title;

  /// No description provided for @display_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get display_name_hint;

  /// No description provided for @username_hint.
  ///
  /// In en, this message translates to:
  /// **'@username'**
  String get username_hint;

  /// No description provided for @church_hint.
  ///
  /// In en, this message translates to:
  /// **'Your church'**
  String get church_hint;

  /// No description provided for @city_hint.
  ///
  /// In en, this message translates to:
  /// **'Your city'**
  String get city_hint;

  /// No description provided for @save_btn.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save_btn;

  /// No description provided for @sign_in_google.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get sign_in_google;

  /// No description provided for @sign_in_apple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get sign_in_apple;

  /// No description provided for @already_signed_in.
  ///
  /// In en, this message translates to:
  /// **'Signed in with Google'**
  String get already_signed_in;

  /// No description provided for @sign_out.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get sign_out;

  /// No description provided for @username_available.
  ///
  /// In en, this message translates to:
  /// **'Username is available'**
  String get username_available;

  /// No description provided for @username_taken.
  ///
  /// In en, this message translates to:
  /// **'This username is taken'**
  String get username_taken;

  /// No description provided for @username_invalid.
  ///
  /// In en, this message translates to:
  /// **'Only lowercase letters, numbers, underscores (3-20)'**
  String get username_invalid;

  /// No description provided for @migrate_logs_success.
  ///
  /// In en, this message translates to:
  /// **'Local logs migrated'**
  String get migrate_logs_success;

  /// No description provided for @badge_dawn.
  ///
  /// In en, this message translates to:
  /// **'Dawn keeper'**
  String get badge_dawn;

  /// No description provided for @badge_streak_30.
  ///
  /// In en, this message translates to:
  /// **'30-day streak'**
  String get badge_streak_30;

  /// No description provided for @badge_full_agpeya.
  ///
  /// In en, this message translates to:
  /// **'Full Agpeya'**
  String get badge_full_agpeya;

  /// No description provided for @badge_gospel_reader.
  ///
  /// In en, this message translates to:
  /// **'Gospel reader'**
  String get badge_gospel_reader;

  /// No description provided for @badge_weekly_champion.
  ///
  /// In en, this message translates to:
  /// **'Weekly champion'**
  String get badge_weekly_champion;

  /// No description provided for @badge_community.
  ///
  /// In en, this message translates to:
  /// **'Community spirit'**
  String get badge_community;

  /// No description provided for @badge_first_step.
  ///
  /// In en, this message translates to:
  /// **'First step'**
  String get badge_first_step;

  /// No description provided for @badge_locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get badge_locked;

  /// No description provided for @notif_prayer_time.
  ///
  /// In en, this message translates to:
  /// **'Prayer time'**
  String get notif_prayer_time;

  /// No description provided for @notif_streak_reminder.
  ///
  /// In en, this message translates to:
  /// **'Don\'t lose your streak'**
  String get notif_streak_reminder;

  /// No description provided for @notif_weekly_result.
  ///
  /// In en, this message translates to:
  /// **'Weekly result'**
  String get notif_weekly_result;

  /// No description provided for @notif_badge_earned.
  ///
  /// In en, this message translates to:
  /// **'Badge earned'**
  String get notif_badge_earned;

  /// No description provided for @share_card_btn.
  ///
  /// In en, this message translates to:
  /// **'Share card'**
  String get share_card_btn;

  /// No description provided for @add_name_to_card_snackbar.
  ///
  /// In en, this message translates to:
  /// **'Add your name to your card'**
  String get add_name_to_card_snackbar;

  /// No description provided for @points_animation_text.
  ///
  /// In en, this message translates to:
  /// **'+10 points'**
  String get points_animation_text;

  /// No description provided for @error_network.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get error_network;

  /// No description provided for @error_generic.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get error_generic;

  /// No description provided for @offline_mode_banner.
  ///
  /// In en, this message translates to:
  /// **'Offline mode'**
  String get offline_mode_banner;

  /// No description provided for @settings_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settings_language;

  /// No description provided for @settings_dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get settings_dark_mode;

  /// No description provided for @settings_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settings_notifications;

  /// No description provided for @settings_font_size.
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get settings_font_size;

  /// No description provided for @profileSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get profileSaveSuccess;

  /// No description provided for @profileSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save'**
  String get profileSaveError;

  /// No description provided for @signedInCrossDevice.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync across devices'**
  String get signedInCrossDevice;

  /// No description provided for @openProfileAction.
  ///
  /// In en, this message translates to:
  /// **'Open profile'**
  String get openProfileAction;

  /// No description provided for @nameBranding.
  ///
  /// In en, this message translates to:
  /// **'Nouri'**
  String get nameBranding;

  /// No description provided for @logoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged out'**
  String get logoutSuccess;

  /// No description provided for @total_points.
  ///
  /// In en, this message translates to:
  /// **'Total points'**
  String get total_points;

  /// No description provided for @enable_prayer_reminders.
  ///
  /// In en, this message translates to:
  /// **'Enable prayer reminders'**
  String get enable_prayer_reminders;

  /// No description provided for @audio_source_label.
  ///
  /// In en, this message translates to:
  /// **'archive.org'**
  String get audio_source_label;

  /// No description provided for @prime_content_en.
  ///
  /// In en, this message translates to:
  /// **'Prime prayer content (EN)'**
  String get prime_content_en;

  /// No description provided for @competition_points_suffix.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get competition_points_suffix;

  /// No description provided for @design_preview_title.
  ///
  /// In en, this message translates to:
  /// **'Design Preview'**
  String get design_preview_title;

  /// No description provided for @login_title.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_title;

  /// No description provided for @login_action.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get login_action;

  /// No description provided for @onboarding_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Agpeya'**
  String get onboarding_welcome;

  /// No description provided for @onboarding_start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onboarding_start;

  /// No description provided for @hour_subtitle_format.
  ///
  /// In en, this message translates to:
  /// **'{english} • {time}'**
  String hour_subtitle_format(Object english, Object time);

  /// No description provided for @prayer_logged_success.
  ///
  /// In en, this message translates to:
  /// **'Prayer logged +10 points'**
  String get prayer_logged_success;

  /// No description provided for @prayer_logged_error.
  ///
  /// In en, this message translates to:
  /// **'Could not log prayer'**
  String get prayer_logged_error;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
