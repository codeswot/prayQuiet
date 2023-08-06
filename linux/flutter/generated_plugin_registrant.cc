//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <do_not_disturb/do_not_disturb_plugin.h>
#include <flutter_localization/flutter_localization_plugin.h>
#include <flutter_volume_controller/flutter_volume_controller_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) do_not_disturb_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DoNotDisturbPlugin");
  do_not_disturb_plugin_register_with_registrar(do_not_disturb_registrar);
  g_autoptr(FlPluginRegistrar) flutter_localization_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterLocalizationPlugin");
  flutter_localization_plugin_register_with_registrar(flutter_localization_registrar);
  g_autoptr(FlPluginRegistrar) flutter_volume_controller_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterVolumeControllerPlugin");
  flutter_volume_controller_plugin_register_with_registrar(flutter_volume_controller_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
}
