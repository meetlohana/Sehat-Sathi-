package runner;

import java.util.List;

import flutter.GeneratedPluginRegistrant;

// Converted from runner/flutter_window.h + runner/flutter_window.cpp (header
// and source merged into a single class, as Java has no header files).
//
// A window that does nothing but host a Flutter view.
public class FlutterWindow extends Win32Window {

    public static final int WM_FONTCHANGE = 0x001D;

    // The project to run.
    private final DartProject project;

    // The Flutter instance hosted by this window.
    private FlutterViewController flutterController;

    // Creates a new FlutterWindow hosting a Flutter view running |project|.
    public FlutterWindow(DartProject project) {
        this.project = project;
    }

    @Override
    protected boolean onCreate() {
        if (!super.onCreate()) {
            return false;
        }

        Rect frame = getClientArea();

        // The size here must match the window dimensions to avoid unnecessary surface
        // creation / destruction in the startup path.
        flutterController = new FlutterViewController(
                (int) (frame.right - frame.left), (int) (frame.bottom - frame.top), project);
        // Ensure that basic setup of the controller was successful.
        if (!flutterController.hasEngine() || !flutterController.hasView()) {
            return false;
        }
        GeneratedPluginRegistrant.registerPlugins(flutterController.getEngine());
        setChildContent(flutterController.getView().getNativeWindow());

        flutterController.getEngine().setNextFrameCallback(new Runnable() {
            @Override
            public void run() {
                show();
            }
        });

        // Flutter can complete the first frame before the "show window" callback is
        // registered. The following call ensures a frame is pending to ensure the
        // window is shown. It is a no-op if the first frame hasn't completed yet.
        flutterController.forceRedraw();

        return true;
    }

    @Override
    protected void onDestroy() {
        if (flutterController != null) {
            flutterController = null;
        }

        super.onDestroy();
    }

    @Override
    protected long messageHandler(long hwnd, int message, long wparam, long lparam) {
        // Give Flutter, including plugins, an opportunity to handle window messages.
        if (flutterController != null) {
            Long result = flutterController.handleTopLevelWindowProc(hwnd, message,
                    wparam, lparam);
            if (result != null) {
                return result;
            }
        }

        switch (message) {
            case WM_FONTCHANGE:
                flutterController.getEngine().reloadSystemFonts();
                break;
        }

        return super.messageHandler(hwnd, message, wparam, lparam);
    }

    // ------------------------------------------------------------------
    // Equivalent of the flutter::DartProject C++ class, limited to the API
    // surface used by the runner (native engine handle behind the scenes).
    // ------------------------------------------------------------------
    public static class DartProject {

        private final String assetsPath;

        public DartProject(String assetsPath) {
            this.assetsPath = assetsPath;
        }

        public String getAssetsPath() {
            return assetsPath;
        }

        // Wraps flutter::DartProject::set_dart_entrypoint_arguments.
        public native void setDartEntryPointArguments(List<String> arguments);
    }

    // ------------------------------------------------------------------
    // Equivalent of the flutter::FlutterViewController C++ class, limited to
    // the API surface used by the runner (native engine handle behind the
    // scenes).
    // ------------------------------------------------------------------
    public static class FlutterViewController {

        private final long nativeHandle;

        public FlutterViewController(int width, int height, DartProject project) {
            this.nativeHandle = nativeCreate(width, height, project);
        }

        public FlutterEngine getEngine() {
            return nativeGetEngine(nativeHandle);
        }

        public FlutterView getView() {
            return nativeGetView(nativeHandle);
        }

        // Convenience checks equivalent to testing the engine()/view() pointers.
        public boolean hasEngine() {
            return nativeGetEngine(nativeHandle) != null;
        }

        public boolean hasView() {
            return nativeGetView(nativeHandle) != null;
        }

        // Wraps flutter::FlutterViewController::HandleTopLevelWindowProc.
        // Returns null when the engine did not handle the message (the C++
        // std::optional<LRESULT> empty case).
        public Long handleTopLevelWindowProc(long hwnd, int message, long wparam,
                long lparam) {
            return nativeHandleTopLevelWindowProc(nativeHandle, hwnd, message, wparam,
                    lparam);
        }

        // Wraps flutter::FlutterViewController::ForceRedraw.
        public void forceRedraw() {
            nativeForceRedraw(nativeHandle);
        }

        private static native long nativeCreate(int width, int height,
                DartProject project);

        private static native FlutterEngine nativeGetEngine(long handle);

        private static native FlutterView nativeGetView(long handle);

        private static native Long nativeHandleTopLevelWindowProc(long handle, long hwnd,
                int message, long wparam, long lparam);

        private static native void nativeForceRedraw(long handle);
    }

    // Equivalent of the flutter::FlutterEngine C++ class, limited to the API
    // surface used by the runner. In the original C++ engine header,
    // FlutterEngine implements flutter::PluginRegistry; the same relationship
    // is preserved here.
    public static class FlutterEngine implements GeneratedPluginRegistrant.PluginRegistry {

        private final long nativeHandle;

        public FlutterEngine(long nativeHandle) {
            this.nativeHandle = nativeHandle;
        }

        // Wraps flutter::FlutterEngine::SetNextFrameCallback.
        public native void setNextFrameCallback(Runnable callback);

        // Wraps flutter::FlutterEngine::ReloadSystemFonts.
        public native void reloadSystemFonts();

        @Override
        public native Object getRegistrarForPlugin(String pluginName);
    }

    // Equivalent of the flutter::FlutterView C++ class, limited to the API
    // surface used by the runner.
    public static class FlutterView {

        private final long nativeHandle;

        public FlutterView(long nativeHandle) {
            this.nativeHandle = nativeHandle;
        }

        // Wraps flutter::FlutterView::GetNativeWindow.
        public native long getNativeWindow();
    }
}
