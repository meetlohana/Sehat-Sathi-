package runner;

import java.util.List;

// Converted from runner/main.cpp.
//
// Note: the original C++ entry point was wWinMain (the Win32 wide-char entry
// point); in Java the equivalent entry point is public static void main.
public final class Main {

    public static final int EXIT_SUCCESS = 0;
    public static final int EXIT_FAILURE = 1;

    // ATTACH_PARENT_PROCESS, as used with AttachConsole.
    public static final int ATTACH_PARENT_PROCESS = -1;

    // COINIT_APARTMENTTHREADED, as used with CoInitializeEx.
    public static final int COINIT_APARTMENTTHREADED = 0x2;

    private Main() {
        // Entry point class; no instances.
    }

    public static void main(String[] args) {
        // Attach to console when present (e.g., 'flutter run') or create a
        // new console when running with a debugger.
        if (!nativeAttachConsole(ATTACH_PARENT_PROCESS) && nativeIsDebuggerPresent()) {
            RunnerUtils.createAndAttachConsole();
        }

        // Initialize COM, so that it is available for use in the library and/or
        // plugins.
        nativeCoInitializeEx(0, COINIT_APARTMENTTHREADED);

        FlutterWindow.DartProject project = new FlutterWindow.DartProject("data");

        List<String> commandLineArguments = RunnerUtils.getCommandLineArguments();

        // (std::move in the original C++; Java references are passed directly.)
        project.setDartEntryPointArguments(commandLineArguments);

        FlutterWindow window = new FlutterWindow(project);
        Win32Window.Point origin = new Win32Window.Point(10, 10);
        Win32Window.Size size = new Win32Window.Size(1280, 720);
        if (!window.create("Sehat Sathi", origin, size)) {
            System.exit(EXIT_FAILURE);
        }
        window.setQuitOnClose(true);

        // Message pump: while (::GetMessage(&msg, nullptr, 0, 0)) {
        //   ::TranslateMessage(&msg); ::DispatchMessage(&msg); }
        Msg msg = new Msg();
        while (nativeGetMessage(msg, 0, 0, 0)) {
            nativeTranslateMessage(msg);
            nativeDispatchMessage(msg);
        }

        nativeCoUninitialize();
        System.exit(EXIT_SUCCESS);
    }

    // Represents the Win32 MSG structure used by the message pump.
    public static final class Msg {
        // Opaque native message structure (filled in by getMessage).
        long address;
    }

    // Wraps AttachConsole.
    private static native boolean nativeAttachConsole(int consoleId);

    // Wraps IsDebuggerPresent.
    private static native boolean nativeIsDebuggerPresent();

    // Wraps CoInitializeEx.
    private static native void nativeCoInitializeEx(long reserved, int coInit);

    // Wraps CoUninitialize.
    private static native void nativeCoUninitialize();

    // Wraps GetMessage.
    private static native boolean nativeGetMessage(Msg msg, long hwnd, int min, int max);

    // Wraps TranslateMessage.
    private static native void nativeTranslateMessage(Msg msg);

    // Wraps DispatchMessage.
    private static native void nativeDispatchMessage(Msg msg);
}
