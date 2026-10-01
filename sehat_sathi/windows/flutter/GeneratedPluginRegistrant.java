//
//  Generated file. Do not edit.
//
// Converted from windows/flutter/generated_plugin_registrant.h +
// generated_plugin_registrant.cc (header and source merged into a single
// class, as Java has no header files).
//

package flutter;

public final class GeneratedPluginRegistrant {

    private GeneratedPluginRegistrant() {
        // Static holder class; no instances.
    }

    // Equivalent of the flutter::PluginRegistry C++ interface, limited to the
    // API surface used by the registrant.
    public interface PluginRegistry {
        // Wraps flutter::PluginRegistry::GetRegistrarForPlugin.
        Object getRegistrarForPlugin(String pluginName);
    }

    // Registers Flutter plugins.
    public static void registerPlugins(PluginRegistry registry) {
        flutterSecureStorageWindowsPluginRegisterWithRegistrar(
                registry.getRegistrarForPlugin("FlutterSecureStorageWindowsPlugin"));
    }

    // Wraps FlutterSecureStorageWindowsPluginRegisterWithRegistrar (the
    // flutter_secure_storage_windows plugin's native registration entry point).
    private static native void flutterSecureStorageWindowsPluginRegisterWithRegistrar(
            Object registrar);
}
