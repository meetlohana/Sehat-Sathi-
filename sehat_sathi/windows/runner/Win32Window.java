package runner;

// Converted from runner/win32_window.h + runner/win32_window.cpp (header and
// source merged into a single class, as Java has no header files).
//
// A class abstraction for a high DPI-aware Win32 Window. Intended to be
// inherited from by classes that wish to specialize with custom
// rendering and input handling
public class Win32Window {

    // Window attribute that enables dark mode window decorations.
    //
    // Redefined in case the developer's machine has a Windows SDK older than
    // version 10.0.22000.0.
    // See: https://docs.microsoft.com/windows/win32/api/dwmapi/ne-dwmapi-dwmwindowattribute
    public static final int DWMWA_USE_IMMERSIVE_DARK_MODE = 20;

    // Window class name.
    public static final String WINDOW_CLASS_NAME = "FLUTTER_RUNNER_WIN32_WINDOW";

    // Registry key for app theme preference.
    //
    // A value of 0 indicates apps should use dark mode. A non-zero or missing
    // value indicates apps should use light mode.
    public static final String GET_PREFERRED_BRIGHTNESS_REG_KEY =
            "Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize";
    public static final String GET_PREFERRED_BRIGHTNESS_REG_VALUE = "AppsUseLightTheme";

    // Win32 constants used by this class (values from the Windows SDK).
    public static final int WM_NCCREATE = 0x0081;
    public static final int WM_DESTROY = 0x0002;
    public static final int WM_SIZE = 0x0005;
    public static final int WM_ACTIVATE = 0x0006;
    public static final int WM_DPICHANGED = 0x02E0;
    public static final int WM_DWMCOLORIZATIONCOLORCHANGED = 0x0320;
    public static final int CS_HREDRAW = 0x0002;
    public static final int CS_VREDRAW = 0x0001;
    public static final int MONITOR_DEFAULTTONEAREST = 2;
    public static final int WS_OVERLAPPEDWINDOW = 0x00CF0000;
    public static final int SW_SHOWNORMAL = 1;
    public static final int SWP_NOZORDER = 0x0004;
    public static final int SWP_NOACTIVATE = 0x0010;
    public static final int GWLP_USERDATA = -21;
    public static final int ERROR_SUCCESS = 0;
    public static final int RRF_RT_REG_DWORD = 0x0002;

    // The number of Win32Window objects that currently exist.
    private static int gActiveWindowCount = 0;

    public static class Point {
        public final int x; // unsigned int in the original C++
        public final int y; // unsigned int in the original C++

        public Point(int x, int y) {
            this.x = x;
            this.y = y;
        }
    }

    public static class Size {
        public final int width;  // unsigned int in the original C++
        public final int height; // unsigned int in the original C++

        public Size(int width, int height) {
            this.width = width;
            this.height = height;
        }
    }

    // Represents the Win32 RECT structure.
    public static class Rect {
        public long left;
        public long top;
        public long right;
        public long bottom;
    }

    // Represents the Win32 POINT structure.
    public static class PointL {
        public long x;
        public long y;
    }

    public Win32Window() {
        ++gActiveWindowCount;
    }

    // Java replacement for the C++ destructor.
    @SuppressWarnings("deprecation")
    @Override
    protected void finalize() throws Throwable {
        --gActiveWindowCount;
        destroy();
        super.finalize();
    }

    // Creates a win32 window with |title| that is positioned and sized using
    // |origin| and |size|. New windows are created on the default monitor. Window
    // sizes are specified to the OS in physical pixels, hence to ensure a
    // consistent size this function will scale the inputted width and height as
    // as appropriate for the default monitor. The window is invisible until
    // |show| is called. Returns true if the window was created successfully.
    public boolean create(String title, Point origin, Size size) {
        destroy();

        String windowClass = WindowClassRegistrar.getInstance().getWindowClass();

        // Locate the monitor nearest to the requested origin and derive the
        // DPI scale factor for it.
        PointL targetPoint = new PointL();
        targetPoint.x = origin.x;
        targetPoint.y = origin.y;
        long monitor = nativeMonitorFromPoint(targetPoint, MONITOR_DEFAULTTONEAREST);
        int dpi = nativeFlutterDesktopGetDpiForMonitor(monitor);
        double scaleFactor = dpi / 96.0;

        long window = nativeCreateWindow(
                windowClass, title, WS_OVERLAPPEDWINDOW,
                scale(origin.x, scaleFactor), scale(origin.y, scaleFactor),
                scale(size.width, scaleFactor), scale(size.height, scaleFactor),
                0, 0, nativeGetModuleHandle(null), this);

        if (window == 0) {
            return false;
        }

        updateTheme(window);

        return onCreate();
    }

    // Show the current window. Returns true if the window was successfully shown.
    public boolean show() {
        return nativeShowWindow(windowHandle, SW_SHOWNORMAL);
    }

    // Release OS resources associated with window.
    public void destroy() {
        onDestroy();

        if (windowHandle != 0) {
            nativeDestroyWindow(windowHandle);
            windowHandle = 0;
        }
        if (gActiveWindowCount == 0) {
            WindowClassRegistrar.getInstance().unregisterWindowClass();
        }
    }

    // Inserts |content| into the window tree.
    public void setChildContent(long content) {
        childContent = content;
        nativeSetParent(content, windowHandle);
        Rect frame = getClientArea();

        nativeMoveWindow(content, frame.left, frame.top, frame.right - frame.left,
                frame.bottom - frame.top, true);

        nativeSetFocus(childContent);
    }

    // Returns the backing Window handle to enable clients to set icon and other
    // window properties. Returns 0 if the window has been destroyed.
    public long getHandle() {
        return windowHandle;
    }

    // If true, closing this window will quit the application.
    public void setQuitOnClose(boolean quitOnClose) {
        this.quitOnClose = quitOnClose;
    }

    // Return a Rect representing the bounds of the current client area.
    public Rect getClientArea() {
        Rect frame = new Rect();
        nativeGetClientRect(windowHandle, frame);
        return frame;
    }

    // Processes and route salient window messages for mouse handling,
    // size change and DPI. Delegates handling of these to member overloads that
    // inheriting classes can handle.
    protected long messageHandler(long hwnd, int message, long wparam, long lparam) {
        switch (message) {
            case WM_DESTROY:
                windowHandle = 0;
                destroy();
                if (quitOnClose) {
                    nativePostQuitMessage(0);
                }
                return 0;

            case WM_DPICHANGED: {
                Rect newRectSize = nativeRectFromPointer(lparam);
                long newWidth = newRectSize.right - newRectSize.left;
                long newHeight = newRectSize.bottom - newRectSize.top;

                nativeSetWindowPos(hwnd, 0, newRectSize.left, newRectSize.top, newWidth,
                        newHeight, SWP_NOZORDER | SWP_NOACTIVATE);

                return 0;
            }
            case WM_SIZE: {
                Rect rect = getClientArea();
                if (childContent != 0) {
                    // Size and position the child window.
                    nativeMoveWindow(childContent, rect.left, rect.top, rect.right - rect.left,
                            rect.bottom - rect.top, true);
                }
                return 0;
            }

            case WM_ACTIVATE:
                if (childContent != 0) {
                    nativeSetFocus(childContent);
                }
                return 0;

            case WM_DWMCOLORIZATIONCOLORCHANGED:
                updateTheme(hwnd);
                return 0;
        }

        return nativeDefWindowProc(windowHandle, message, wparam, lparam);
    }

    // Called when create is called, allowing subclass window-related
    // setup. Subclasses should return false if setup fails.
    protected boolean onCreate() {
        // No-op; provided for subclasses.
        return true;
    }

    // Called when destroy is called.
    protected void onDestroy() {
        // No-op; provided for subclasses.
    }

    // OS callback called by message pump. Handles the WM_NCCREATE message which
    // is passed when the non-client area is being created and enables automatic
    // non-client DPI scaling so that the non-client area automatically
    // responds to changes in DPI. All other messages are handled by
    // MessageHandler.
    protected static long wndProc(long window, int message, long wparam, long lparam) {
        if (message == WM_NCCREATE) {
            Win32Window createdFrom = nativeWindowFromCreateStruct(lparam);
            nativeSetWindowLongPtr(window, GWLP_USERDATA,
                    nativePointerFromObject(createdFrom));

            nativeEnableFullDpiSupportIfAvailable(window);
            createdFrom.windowHandle = window;
        } else {
            Win32Window that = getThisFromHandle(window);
            if (that != null) {
                return that.messageHandler(window, message, wparam, lparam);
            }
        }

        return nativeDefWindowProc(window, message, wparam, lparam);
    }

    // Retrieves a class instance pointer for |window|.
    protected static Win32Window getThisFromHandle(long window) {
        return nativeObjectFromPointer(nativeGetWindowLongPtr(window, GWLP_USERDATA));
    }

    // Update the window frame's theme to match the system theme.
    protected static void updateTheme(long window) {
        int[] lightMode = new int[1];
        long result = nativeRegGetValueHkcu(GET_PREFERRED_BRIGHTNESS_REG_KEY,
                GET_PREFERRED_BRIGHTNESS_REG_VALUE,
                RRF_RT_REG_DWORD, lightMode);

        if (result == ERROR_SUCCESS) {
            int enableDarkMode = lightMode[0] == 0 ? 1 : 0;
            nativeDwmSetWindowAttribute(window, DWMWA_USE_IMMERSIVE_DARK_MODE,
                    enableDarkMode);
        }
    }

    // Scale helper to convert logical scaler values to physical using passed in
    // scale factor.
    private static int scale(int source, double scaleFactor) {
        return (int) (source * scaleFactor);
    }

    private boolean quitOnClose = false;

    // window handle for top level window.
    private long windowHandle = 0;

    // window handle for hosted content.
    private long childContent = 0;

    // ------------------------------------------------------------------
    // Native interop layer (Win32 / Flutter engine C API bindings).
    // These replace the direct Win32 calls made from the original C++ file.
    // ------------------------------------------------------------------

    // Wraps MonitorFromPoint.
    private static native long nativeMonitorFromPoint(PointL point, int flags);

    // Wraps FlutterDesktopGetDpiForMonitor.
    private static native int nativeFlutterDesktopGetDpiForMonitor(long monitor);

    // Wraps CreateWindow.
    private static native long nativeCreateWindow(String windowClass, String title,
            int style, int x, int y, int width, int height, long parent,
            long menu, long instance, Object createParams);

    // Wraps GetModuleHandle.
    private static native long nativeGetModuleHandle(Object module);

    // Wraps ShowWindow.
    private static native boolean nativeShowWindow(long hwnd, int showCommand);

    // Wraps DestroyWindow.
    private static native void nativeDestroyWindow(long hwnd);

    // Wraps SetParent.
    private static native void nativeSetParent(long child, long parent);

    // Wraps MoveWindow.
    private static native void nativeMoveWindow(long hwnd, long x, long y, long width,
            long height, boolean repaint);

    // Wraps SetFocus.
    private static native void nativeSetFocus(long hwnd);

    // Wraps GetClientRect (fills |rect|).
    private static native void nativeGetClientRect(long hwnd, Rect rect);

    // Wraps PostQuitMessage.
    private static native void nativePostQuitMessage(int exitCode);

    // Wraps SetWindowPos.
    private static native void nativeSetWindowPos(long hwnd, long insertAfter, long x,
            long y, long width, long height, int flags);

    // Wraps DefWindowProc.
    private static native long nativeDefWindowProc(long hwnd, int message, long wparam,
            long lparam);

    // Wraps SetWindowLongPtr.
    private static native void nativeSetWindowLongPtr(long hwnd, int index, long value);

    // Wraps GetWindowLongPtr.
    private static native long nativeGetWindowLongPtr(long hwnd, int index);

    // Wraps RegGetValue(HKEY_CURRENT_USER, ...) for a REG_DWORD value.
    private static native long nativeRegGetValueHkcu(String key, String valueName,
            int flags, int[] outValue);

    // Wraps DwmSetWindowAttribute for a BOOL attribute.
    private static native void nativeDwmSetWindowAttribute(long hwnd, int attribute,
            int value);

    // Wraps EnableNonClientDpiSupportIfAvailable: dynamically loads
    // |EnableNonClientDpiScaling| from the User32 module. This API is only
    // needed for PerMonitor V1 awareness mode.
    private static native void nativeEnableFullDpiSupportIfAvailable(long hwnd);

    // Extracts the Win32Window pointer from the CREATESTRUCT referenced by
    // |lparam| during WM_NCCREATE.
    private static native Win32Window nativeWindowFromCreateStruct(long lparam);

    // Converts a native Win32Window pointer into the managed instance.
    private static native long nativePointerFromObject(Object object);

    // Converts a native pointer previously stored via
    // |nativePointerFromObject| back into the managed instance.
    private static native Win32Window nativeObjectFromPointer(long pointer);

    // Converts a native pointer to a RECT structure (as passed with
    // WM_DPICHANGED) into a Rect instance.
    private static native Rect nativeRectFromPointer(long pointer);
}

// Manages the Win32Window's window class registration.
// (Defined in the original win32_window.cpp; kept in the same file for design
// parity. Package-private so it is only visible within the runner.)
class WindowClassRegistrar {

    private static WindowClassRegistrar instance;

    private boolean classRegistered = false;

    private WindowClassRegistrar() {
        // Singleton.
    }

    // Returns the singleton registrar instance.
    public static WindowClassRegistrar getInstance() {
        if (instance == null) {
            instance = new WindowClassRegistrar();
        }
        return instance;
    }

    // Returns the name of the window class, registering the class if it hasn't
    // previously been registered.
    public String getWindowClass() {
        if (!classRegistered) {
            nativeRegisterClass(Win32Window.WINDOW_CLASS_NAME,
                    Win32Window.CS_HREDRAW | Win32Window.CS_VREDRAW);
            classRegistered = true;
        }
        return Win32Window.WINDOW_CLASS_NAME;
    }

    // Unregisters the window class. Should only be called if there are no
    // instances of the window.
    public void unregisterWindowClass() {
        nativeUnregisterClass(Win32Window.WINDOW_CLASS_NAME);
        classRegistered = false;
    }

    // Wraps RegisterClass (loads the arrow cursor, the app icon from
    // ResourceIds.IDI_APP_ICON, and registers Win32Window.wndProc as the
    // window procedure).
    private static native void nativeRegisterClass(String className, int style);

    // Wraps UnregisterClass.
    private static native void nativeUnregisterClass(String className);
}
