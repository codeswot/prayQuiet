// ignore_for_file: constant_identifier_names

mixin AppLocale {
  static const String home = 'Home';
  static const String settings = 'Settings';

  static const grantAccess = 'Grant access';
  static const notNow = 'Not now';

  static const preference = 'Preferences';
  static const now = 'Now';
  static const language = 'Change language';
  static const theme = 'Change theme';
  static const enableService = 'Enable service';
  static const afterPrayerBehaviour = 'After prayer behaviour';
  static const afterPrayerBehaviourInfo = 'After prayer behaviour information';
  static const afterPrayerBehaviourDesc =
      'This setting deals with the behavior of your device after prayer time. It determines whether it should be set back to ringer mode, vibrate mode, or left on silence. By default, the device is set to ringer mode after prayer time.';
  static const after = 'After';
  static const hour = 'an hour';
  static const minute = 'minute';

  static const light = 'Light theme';
  static const dark = 'Dark theme';
  static const system = 'System default theme';

  static const edit = 'Edit';
  static const next = 'Next';
  static const previous = 'Previous';
  static const oneMoreThing = 'one more thing...';
  static const inOtherTo =
      'in order to do a great job, Pray Quiet needs you to grant  permission to these things,';

  static const setupFailed = 'The setup was unsuccessful';
  static const setupFailedDesc =
      'Seems your device location is turned off, please enable location and make sure you have internet connection, then try again !';

  static const permissionInfo =
      'When you tap the "Grant Access" button, the app will open the "Do Not Disturb" settings page. It guides you to find and activate the "Pray Quiet" option, allowing the app to use the "Do Not Disturb" feature during prayer times according to your preferences. This helps you stay undisturbed and focused during your moments of prayer or quiet reflection."';

  static const serviceDisabled = 'Service disabled';
  static const serviceDisabledDesc =
      'To toggle your prayer silence preference, you need to enable the service first. To do this, simply switch on the "Enable Service" option. This will allow you to customize your device\'s behavior during prayer times, such as setting it to silent mode, vibrate mode, or ringer mode as per your preference. Once the service is enabled, you can configure the settings according to your needs.';
  //
  static const appDescription =
      'Embrace peaceful worship with PrayQuiet. Silence your phone while praying, make sure you phone is silent when its time to pray.';

  //
  static const prayerSettings = 'Prayer time settings';
  static const useCustomPrayer = 'Use custom prayer time';

  static const customPrayer = 'Custom prayer time';
  static const customPrayerDesc =
      'By enabling this option, you can input the specific prayer times observed at your masjid, allowing the app to align with your local community\'s prayer schedule. By toggling this option, you ensure that the app accurately reflects the prayer times practiced at your masjid, enhancing your prayer experience and spiritual connection.';
  static const putDeviceOn = 'Put device on';
  static const afterPrayerInterval = 'After prayer interval';
  static const afterPrayerIntervalInfo = 'After prayer interval information';
  static const afterPrayerIntervalDesc =
      'This refers to the interval or waiting period to remove the device from "Do Not Disturb" mode after prayer. By default, the waiting period is set to 30 minutes. During this time, the device will remain in "Do Not Disturb" mode after the prayer event before automatically reverting to its normal mode of operation.';

  //
  static const intro1Title = 'Assalamualaikum\n 🤝';
  static const intro1Desc =
      'PrayQuiet ensures uninterrupted worship moments through seamless device silence during daily Islamic prayers, deepening your faith connection. Join our journey of undistracted devotion.';

  static const intro2Title = 'Prayer time reminer \n 🕋';
  static const intro2Desc =
      'PrayQuiet gently notifies you for the five daily prayers. Embrace the convenience of our crafted alerts that ensure you never miss prayer times. Let prayQuiet be your faithful spiritual rhythm, guiding you through the day.';

  static const intro3Title = 'PrayQuiet\n 🤫';
  static const intro3Desc =
      'No interruptions, just serenity. With prayQuiet, your device will automatically switch to \'Do Not Disturb\' mode during each of the five daily prayers. Stay fully immersed in your worship without any distractions.';

  static const dndDesc =
      'To automatically put your phone on silent during prayer times';

  static const locDesc = 'To get prayer times for your location/region';

  static const notiDesc = 'To notify you when it\'s time to pray';

  static const Map<String, dynamic> EN = {
    home: home,
    settings: settings,
    preference: preference,
    language: language,
    theme: theme,
    edit: edit,
    next: next,
    grantAccess: grantAccess,
    previous: previous,
    oneMoreThing: oneMoreThing,
    inOtherTo: inOtherTo,
    permissionInfo: permissionInfo,
    now: now,
    intro1Title: intro1Title,
    intro1Desc: intro1Desc,
    intro2Title: intro2Title,
    intro2Desc: intro2Desc,
    intro3Title: intro3Title,
    intro3Desc: intro3Desc,
    prayerSettings: prayerSettings,
    appDescription: appDescription,
    putDeviceOn: putDeviceOn,
    customPrayer: customPrayer,
    customPrayerDesc: customPrayerDesc,
    useCustomPrayer: useCustomPrayer,
    enableService: enableService,
    afterPrayerBehaviour: afterPrayerBehaviour,
    afterPrayerBehaviourInfo: afterPrayerBehaviourInfo,
    afterPrayerBehaviourDesc: afterPrayerBehaviourDesc,
    afterPrayerInterval: afterPrayerInterval,
    afterPrayerIntervalInfo: afterPrayerIntervalInfo,
    afterPrayerIntervalDesc: afterPrayerIntervalDesc,
    serviceDisabled: serviceDisabled,
    serviceDisabledDesc: serviceDisabledDesc,
    after: after,
    hour: hour,
    minute: minute,
    setupFailed: setupFailed,
    setupFailedDesc: setupFailedDesc,
    dndDesc: dndDesc,
    locDesc: locDesc,
    notiDesc: notiDesc,
    light: light,
    dark: dark,
    system: system,
  };

  static const Map<String, dynamic> HA = {
    home: 'Gida',
    settings: 'Saiti',
    edit: 'Gyara',
    now: 'Yanzu',
    preference: 'Fifiko',
    language: 'Canza harshe',
    prayerSettings: 'Saitunan lokacin sallah',
    customPrayer: 'lokutan sallan ka',
    customPrayerDesc:
        'Ta hanyar kunna wannan zaɓi, zaku iya shigar da takamaiman lokutan sallah da aka kiyaye a masallacin ku, ba da damar app ɗin ya daidaita da jadawalin sallah yankinku. Ta hanyar jujjuya wannan zaɓi, kuna tabbatar da cewa app ɗin yana nuna daidai lokacin lokutan sallah da ake yi a masallacin ku, yana haɓaka kwarewar salar ku da alakar ruhaniya.',
    useCustomPrayer: 'Yi amfani da lokutan sallan ka',
    appDescription:
        'Rungumar Ibadah a cikin Kwanciyar Hankali, Ba Tada Hankali! sa wayar tayi shiru a duk lokutan sallah',
    enableService: 'ba da damar sabis',
    afterPrayerBehaviour: 'Bayan halayen sallah',
    afterPrayerBehaviourInfo: 'Bayanin halayen bayan sallah',
    afterPrayerBehaviourDesc:
        'Wannan saitin yana magana ne akan halayen wayar ku bayan lokacin sallah. Yana kayyade ko yakamata a saita shi zuwa yanayin ringi, yanayin girgiza, ko barin shi shiru. Ta hanyar tsoho, an saita waya zuwa yanayin ringi bayan lokacin sallah.',
    afterPrayerInterval: 'Bayan tazarar sallah',
    afterPrayerIntervalInfo: 'Bayanin tazara bayan sallah',
    afterPrayerIntervalDesc:
        'Wannan yana nufin tazara ko lokacin jira don cire waya daga yanayin "Do Not Disturb" bayan sallah. Ta hanyar tsoho, an saita lokacin jira zuwa mintuna 30. A wannan lokacin, waya za ta ci gaba da kasancewa a cikin yanayin "Do Not Disturb" bayan taron sallah kafin ta koma yanayin aiki ta atomatik.',
    putDeviceOn: 'Saka waya a',
    serviceDisabled: 'An kashe sabis',
    serviceDisabledDesc:
        'Don kunna zaɓin shiru na sallar ku, kuna bukatar kunna sabis ɗin tukuna. Don yin wannan, kawai kunna zaɓin "Enable Service". Wannan zai ba ku damar tsara halayen wayar yayin lokutan sallah, kamar saita ta zuwa yanayin shiru, yanayin girgiza, ko yanayin kara kamar yadda kuke so. Da zarar an kunna sabis ɗin, zaku iya saita saitunan gwargwadon bukatunku.',
    intro1Title: intro1Title,
    intro1Desc:
        'PrayQuiet yana tabbatar da lokutan ibada ba tare da katsewa ba ta hanyar shiru na waya mara nauyi yayin sallolin Musulunci na yau da kullun, yana zurfafa alakar bangaskiyar ku. Ku shiga cikin tafiyar mu ta ibada mara sha\'awa.',
    intro2Title: 'Tunatar lokacin sallah \n🕋',
    intro2Desc:
        'PrayQuiet ya sanar da ku don salloli biyar na kullun. Tattara la\'akari da dacewa ta taka. Yi amintattun zirga-zirga da ayyukanmu wanda suka tabbata cewa ba ku taɓa rasa lokutan sallah ba. Yin sallah tare da PrayQuiet, yana sauyin ku tare da hanya.',
    intro3Title: intro3Title,
    intro3Desc:
        'Babu tsangwama, kawai nutsuwa. Tare da prayerQuiet, wayar za ta canza ta atomatik zuwa yanayin "Do Not Disturb" yayin kowace salloli biyar. Ku kasance da cikakkiyar nutsuwa a cikin ibadarku ba tare da wata damuwa ba.',
    after: 'Bayan',
    minute: 'minti',
    hour: 'awa daya',
    next: 'Na gaba',
    previous: 'Na baya',
    oneMoreThing: 'Saura abu daya...',
    inOtherTo:
        'Domin yin babban aiki, PrayQuiet yana bukatar ku ba da izini ga waɗannan abubuwan,',
    permissionInfo:
        'Lokacin da ka matsa maɓallin "Ba da izinin shiga", ka\'idar za ta buɗe shafin saitin "Do Not Disturb". Yana jagorance ku don nemo da kunna zaɓin "PrayQuiet", yana ba app damar amfani da fasalin "Do Not Disturb" yayin lokutan sallah gwargwadon abubuwan da kuke so. Wannan yana taimaka muku kasancewa cikin rashin damuwa da mai da hankali yayin lokutan sallah ko tunani a hankali."',
    grantAccess: 'Ba da izinin shiga',
    notNow: 'Ba yanzu ba',
    setupFailed: 'Saitin bai yi nasara ba',
    setupFailedDesc:
        'Da alama an kashe "Location" wayarka, da fatan za a kunna "Location" kuma tabbatar cewa kuna da haɗin Intanet, sannan a sake gwadawa!',
    dndDesc: 'Don sanya wayarka ta kunna shiru yayin lokutan sallah',
    locDesc: 'Don samun lokutan sallah wurin da kuke / yankin ku',
    notiDesc: 'Don sanar da kai duk san da lokacin yin sallah yayi',
    theme: 'Canza jigo',
    light: 'Jigo mai haske',
    dark: 'Jigo mai duhu',
    system: 'Jigon tsarin wayar',
  };
}

enum PrayQuietLocaleType {
  en,
  ha,
}
