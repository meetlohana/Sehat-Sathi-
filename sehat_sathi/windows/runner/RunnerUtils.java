package runner;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

// Converted from runner/utils.h + runner/utils.cpp (header and source merged
// into a single class, as Java has no header files).
public final class RunnerUtils {

    // UNICODE_STRING_MAX_CHARS (32767) is the maximum length of a UNICODE_STRING.
    private static final int UNICODE_STRING_MAX_CHARS = 32767;

    private RunnerUtils() {
        // Static utility class; no instances.
    }

    // Creates a console for the process, and redirects stdout and stderr to
    // it for both the runner and the Flutter library.
    public static void createAndAttachConsole() {
        nativeCreateAndAttachConsole();
    }

    // Native implementation: wraps AllocConsole + freopen_s("CONOUT$") +
    // _dup2 + FlutterDesktopResyncOutputStreams.
    private static native void nativeCreateAndAttachConsole();

    // Gets the command line arguments passed in as a List<String>,
    // encoded in UTF-8. Returns an empty List<String> on failure.
    public static List<String> getCommandLineArguments() {
        // Convert the UTF-16 command line arguments to UTF-8 for the Engine to use.
        List<String> argv = nativeCommandLineToArgvUtf16();
        if (argv == null) {
            return new ArrayList<>();
        }

        List<String> commandLineArguments = new ArrayList<>();

        // Skip the first argument as it's the binary name.
        for (int i = 1; i < argv.size(); i++) {
            commandLineArguments.add(utf8FromUtf16(argv.get(i)));
        }

        return commandLineArguments;
    }

    // Native implementation: wraps CommandLineToArgvW(GetCommandLineW(), &argc)
    // (plus LocalFree of the returned buffer). Returns null on failure.
    private static native List<String> nativeCommandLineToArgvUtf16();

    // Takes a UTF-16 string (as a Java String) and returns a String
    // encoded in UTF-8. Returns an empty String on failure.
    public static String utf8FromUtf16(String utf16String) {
        if (utf16String == null) {
            return "";
        }
        // First, find the length of the string with a safe upper bound (CWE-126).
        // UNICODE_STRING_MAX_CHARS (32767) is the maximum length of a UNICODE_STRING.
        int inputLength = Math.min(utf16String.length(), UNICODE_STRING_MAX_CHARS);
        String bounded = utf16String.substring(0, inputLength);

        byte[] utf8Bytes;
        try {
            // Equivalent of WideCharToMultiByte(CP_UTF8, WC_ERR_INVALID_CHARS, ...):
            // an empty/invalid conversion yields no bytes.
            utf8Bytes = bounded.getBytes(StandardCharsets.UTF_8);
        } catch (RuntimeException error) {
            return "";
        }
        if (utf8Bytes.length == 0) {
            return "";
        }
        return new String(utf8Bytes, StandardCharsets.UTF_8);
    }
}
