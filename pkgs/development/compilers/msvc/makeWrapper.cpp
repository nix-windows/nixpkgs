#define _CRT_SECURE_NO_DEPRECATE
#include <assert.h>
#include <windows.h>
#include <map>
#include <vector>
#include <utility>
#include <string>
#include <iostream>
#include <strstream>
#include <fstream>

using namespace std;

// hello -> L"hello"
string wliteral(const wstring & ws) {
    string rc = "L\"";
    for (int i=0; i<ws.size(); i++) {
        wchar_t c = ws[i];
        if (' ' <= c && c <= '~') {
            if (c == '"' || c == '\\')
                rc += '\\';
            rc += c;
        } else {
            char sz[7];
            sprintf(sz, "\\u%04X", c);
            rc += sz;
        }
    }
    rc += '"';
    return rc;
}

// hello -> "hello"
string utf8literal(const wstring & ws) {
    string rc = "\"";
    for (int i=0; i<ws.size(); i++) {
        unsigned int c = ws[i];
        if (' ' <= c && c <= '~') {
            if (c == '"' || c == '\\')
                rc += '\\';
            rc += c;
        } else if (c < 0x0080) {
            char sz[5];
            sprintf(sz, "\\x%02X", c);
            rc += sz;
        } else if (c < 0x0800) {
            char sz[9];
            sprintf(sz, "\\x%02X\\x%02X", 0xC0|(c>>6), 0x80|(c&0x3F));
            rc += sz;
        } else if (0xD800 <= c && c < 0xDC00 && i+1 < ws.size() && 0xDC00 <= ws[i+1] && ws[i+1] < 0xE000) { // surrogate
            c = 0x00010000 + ((c-0xD800)<<10) + (ws[i+1]-0xDC00);
            char sz[17];
            sprintf(sz, "\\x%02X\\x%02X\\x%02X\\x%02X", 0xF0|(c>>18), 0x80|((c>>12)&0x3F), 0x80|((c>>6)&0x3F), 0x80|(c&0x3F));
            rc += sz;
            i++;
        } else {
            char sz[13];
            sprintf(sz, "\\x%02X\\x%02X\\x%02X", 0xE0|(c>>12), 0x80|((c>>6)&0x3F), 0x80|(c&0x3F));
            rc += sz;
        }
    }
    rc += '"';
    return rc;
}

int wmain(int argc, const wchar_t** argv) {
    assert(argc >= 3);
    const wchar_t* original_exe = argv[1]; // it could be .bat
    const wchar_t* wrapper_exe = argv[2];

    vector<wstring>                               env_unset;
    vector<pair<wstring, wstring>>                env_set;
    vector<pair<wstring, wstring>>                env_set_default;
    vector<pair<wstring, pair<wstring, wstring>>> env_prefix;
    vector<pair<wstring, pair<wstring, wstring>>> env_suffix;
    vector<wstring>                               add_flags;
    const wchar_t*                                subsystem = L"CONSOLE";

    for (int i=3; i<argc; ) {
        const wchar_t* verb = argv[i++];
             if (0==wcscmp(verb, L"--set"            ) && i+2 <= argc) env_set.push_back(make_pair(argv[i], argv[i+1])), i+=2;
        else if (0==wcscmp(verb, L"--set-default"    ) && i+2 <= argc) env_set_default.push_back(make_pair(argv[i], argv[i+1])), i+=2;
        else if (0==wcscmp(verb, L"--unset"          ) && i+1 <= argc) env_unset.push_back(argv[i++]);
        else if (0==wcscmp(verb, L"--run"            ) && i+1 <= argc) assert(!"TODO");
        else if (0==wcscmp(verb, L"--prefix"         ) && i+3 <= argc) env_prefix.push_back(make_pair(argv[i], make_pair(argv[i+1], argv[i+2]))), i+=3;
        else if (0==wcscmp(verb, L"--suffix"         ) && i+3 <= argc) env_suffix.push_back(make_pair(argv[i], make_pair(argv[i+1], argv[i+2]))), i+=3;
        else if (0==wcscmp(verb, L"--suffix-each"    ) && i+3 <= argc) assert(!"TODO");
        else if (0==wcscmp(verb, L"--prefix-contents") && i+3 <= argc) assert(!"TODO");
        else if (0==wcscmp(verb, L"--suffix-contents") && i+3 <= argc) assert(!"TODO");
        else if (0==wcscmp(verb, L"--add-flags"      ) && i+1 <= argc) add_flags.push_back(argv[i++]);
        else if (0==wcscmp(verb, L"--argv0"          ) && i+1 <= argc) assert(!"TODO");
        else if (0==wcscmp(verb, L"--gui"            )               ) subsystem = L"WINDOWS";
        else if (0==wcscmp(verb, L"--console"        )               ) subsystem = L"CONSOLE";
        else {
          wcerr << L"unknown verb '" << verb << L"'" << endl;
          exit(1);
        }
    }

    // TODO: generate plain C code, without C++ and STL (and build with /NODEFAULTLIBS), it could end up in very small wrapper executables
    ostrstream code;
    code << "#define _CRT_SECURE_NO_DEPRECATE\n";
    code << "#include <windows.h>\n";
    code << "#include <assert.h>\n";
    code << "#include <iostream>\n";
    code << "#include <string>\n";
    code << "#include <vector>\n";
    code << "#include <map>\n";
    code << "#pragma comment(lib, \"shell32.lib\")\n";
    code << "using namespace std;\n";
    code << "\n";
    code << "bool isAbsolute(const wchar_t* path) {\n";
    code << "    return (path[0] == '\\\\') || (('a' <= (path[0]|0x20) && (path[0]|0x20) <= 'z') && path[1] == ':');\n";
    code << "}\n";
    code << "\n";
    code << "// copy-paste from Nix's libutil/util.cc\n";
    code << "wstring windowsEscapeW(const wstring & s)\n";
    code << "{\n";
    code << "    if (s.empty() || s.find_first_of(L\"&()<>[]{}^=;!'+,`!\\\"\\t \") != std::wstring::npos) {\n";
    code << "        std::wstring r = L\"\\\"\";\n";
    code << "        for (int i=0; i < s.length(); ) {\n";
    code << "            if (s[i] == L'\"') {\n";
    code << "                r += L'\\\\';\n";
    code << "                r += s[i++];\n";
    code << "            } else if (s[i] == L'\\\\') {\n";
    code << "                for (int j = 1; ; j++) {\n";
    code << "                    if (i+j == s.length()) {\n";
    code << "                        while (j--) { r += L'\\\\'; r += L'\\\\'; i++; };\n";
    code << "                        break;\n";
    code << "                    } else if (s[i+j] == L'\"') {\n";
    code << "                        while (j--) { r += L'\\\\'; r += L'\\\\'; i++; }\n";
    code << "                        r += L'\\\\';\n";
    code << "                        r += s[i++];\n";
    code << "                        break;\n";
    code << "                    } else if (s[i+j] != L'\\\\') {\n";
    code << "                        while (j--) { r += L'\\\\'; i++; };\n";
    code << "                        r += s[i++];\n";
    code << "                        break;\n";
    code << "                    }\n";
    code << "                }\n";
    code << "            } else {\n";
    code << "                r += s[i++];\n";
    code << "            }\n";
    code << "        }\n";
    code << "        r += L'\"';\n";
    code << "        return r;\n";
    code << "    } else\n";
    code << "        return s;\n";
    code << "}\n";
    code << "struct no_case_compare {\n";
    code << "    bool operator() (const wstring & s1, const wstring & s2) const {\n";
    code << "        return wcsicmp(s1.c_str(), s2.c_str()) < 0;\n";
    code << "    }\n";
    code << "};\n";

         if (0 == wcscmp(subsystem, L"WINDOWS")) code << "int WINAPI wWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, PWSTR pCmdLine, int nCmdShow) {\n";
    else if (0 == wcscmp(subsystem, L"CONSOLE")) code << "void main() {\n";
    else {
      wcerr << L"unknown subsystem '" << subsystem << L"'" << endl;
      assert(0);
    }

    code << "map<wstring, wstring, no_case_compare> env;\n";
    code << "{\n";
    code << "    const wchar_t* pw = GetEnvironmentStringsW();\n";
    code << "    assert(pw);\n";
    code << "    while (*pw) {\n";
    code << "        size_t len = wcslen(pw);\n";
    code << "        const wchar_t* peq = wcschr(pw+1, L'=');\n";
    code << "        if (peq < pw + len) {\n";
    code << "            env[wstring(pw, peq-pw)] = wstring(peq+1, pw+len-(peq+1));\n";
    code << "        } else {\n";
    code << "            env[wstring(pw, len)] = L\"\";\n";
    code << "        }\n";
    code << "        pw += len + 1;\n";
    code << "    }\n";
    code << "}\n";
    code << "vector<wstring> args;\n";
    code << "{\n";
    code << "    int numArgs;\n";
    code << "    LPWSTR* wargv = CommandLineToArgvW(GetCommandLineW(), &numArgs);\n";
    code << "    assert(wargv);\n";
    code << "    for (int i=0; i<numArgs; i++) args.push_back(wargv[i]);\n";
    code << "    LocalFree(wargv);\n";
    code << "}\n";

    for (vector<pair<wstring, pair<wstring, wstring>>>::const_iterator t = env_prefix.begin(); t != env_prefix.end(); t++) {
        code << "{\n";
        code << "    map<wstring, wstring, no_case_compare>::const_iterator it = env.find(" << wliteral(t->first) << ");\n";
        code << "    env[" << wliteral(t->first) << "] = it == env.end() ? " << wliteral(t->second.second) << " : (" << wliteral(t->second.second) << " " << wliteral(t->second.first) << ") + it->second;\n";
        code << "}\n";
    }
    for (vector<pair<wstring, pair<wstring, wstring>>>::const_iterator t = env_suffix.begin(); t != env_suffix.end(); t++) {
        code << "{\n";
        code << "    map<wstring, wstring, no_case_compare>::const_iterator it = env.find(" << wliteral(t->first) << ");\n";
        code << "    env[" << wliteral(t->first) << "] = it == env.end() ? " << wliteral(t->second.second) << " : it->second + (" << wliteral(t->second.first) << " " << wliteral(t->second.second) << ");\n";
        code << "}\n";
    }
    for (vector<pair<wstring, wstring>>::const_iterator t = env_set.begin(); t != env_set.end(); t++) {
        code << "env[" << wliteral(t->first) << "] = " << wliteral(t->second) << "\n";
    }
    for (vector<pair<wstring, wstring>>::const_iterator t = env_set_default.begin(); t != env_set_default.end(); t++) {
        code << "if (env.find(" << wliteral(t->first) << ") == env.end())\n";
        code << "    env[" << wliteral(t->first) << "] = " << wliteral(t->second) << ";\n";
    }
    for (vector<wstring>::const_iterator t = env_unset.begin(); t != env_unset.end(); t++) {
        code << "env.erase(" << wliteral(*t) << ")\n";
    }

    code << "const wchar_t * original_exe = " << wliteral(original_exe) << ";\n";
    code << "\n";
    code << "// if `original_exe` is a relative path, it is relative to the the wrapper current location, not to the current working dir\n";
    code << "if (!isAbsolute(original_exe)) {\n";
    code << "    wchar_t self_exe[0x9000];\n";
    code << "    DWORD dw = GetModuleFileNameW(NULL, self_exe, 0x9000);\n";
    code << "    assert(0 < dw && dw < 0x9000);\n";
    code << "    const wchar_t *self_exe_last_slash = max( wcsrchr(self_exe, L'\\\\'), wcsrchr(self_exe, L'/') );\n";
    code << "    assert(self_exe_last_slash != NULL);\n";
    code << "\n";
    code << "    size_t len1 = self_exe_last_slash - self_exe + 1, len2 = wcslen(original_exe) + 1;\n";
    code << "    wchar_t *buf1 = new wchar_t[len1 + len2];\n";
    code << "    assert(buf1);\n";
    code << "    memcpy(buf1,        self_exe,     len1 * sizeof(wchar_t));\n";
    code << "    memcpy(buf1 + len1, original_exe, len2 * sizeof(wchar_t));\n";
    code << "    wchar_t buf2[0x9000]; /* more than enough, 32768 is the max length */\n";
    code << "    dw = GetFullPathNameW(buf1, 0x9000, buf2, NULL); /* take care on \\..\\ */\n";
    code << "    assert(0 < dw && dw < 0x9000);\n";
    code << "    original_exe = buf2;\n";
    code << "}\n";
    code << "\n";
    code << "args[0] = original_exe;\n";

    for (vector<wstring>::const_iterator t = add_flags.begin(); t != add_flags.end(); t++) {
        code << "args.push_back()" << wliteral(*t) << ");\n";
    }

    code << "     wstring ucmdline, uenvline;\n";
    code << "     for (int i=0; i<args.size(); i++) {\n";
    code << "         if (!ucmdline.empty()) ucmdline += L' ';\n";
    code << "         ucmdline += windowsEscapeW(args[i]);\n";
    code << "     }\n";
    code << "     for (map<wstring, wstring, no_case_compare>::const_iterator i = env.begin(); i != env.end(); i++)\n";
    code << "         uenvline += i->first + L'=' + i->second + L'\\0';\n";
    code << "     uenvline += L'\\0';\n";
    code << "\n";
    code << "     STARTUPINFOW si = {sizeof(STARTUPINFOW)};\n";
    code << "     PROCESS_INFORMATION pi = {0};\n";
    code << "     if (!CreateProcessW(NULL,                                       // LPCWSTR               lpApplicationName\n";
    code << "                         const_cast<wchar_t*>(ucmdline.c_str()),     // LPWSTR                lpCommandLine\n";
    code << "                         NULL,                                       // LPSECURITY_ATTRIBUTES lpProcessAttributes\n";
    code << "                         NULL,                                       // LPSECURITY_ATTRIBUTES lpThreadAttributes\n";
    code << "                         TRUE,                                       // BOOL                  bInheritHandles\n";
    code << "                         CREATE_UNICODE_ENVIRONMENT,                 // DWORD                 dwCreationFlags\n";
    code << "                         const_cast<wchar_t*>(uenvline.c_str()),     // LPVOID                lpEnvironment\n";
    code << "                         NULL,                                       // LPCWSTR               lpCurrentDirectory\n";
    code << "                         &si,                                        // LPSTARTUPINFOW        lpStartupInfo\n";
    code << "                         &pi)) {                                     // LPPROCESS_INFORMATION lpProcessInformation\n";
    code << "         wcerr << L\"CreateProcessW(\" << ucmdline << \") failed lastError=\" << GetLastError() << endl;\n";
    code << "         ExitProcess(1);\n";
    code << "     }\n";
    code << "     CloseHandle(pi.hThread);\n";
    code << "\n";
    code << "     if (WaitForSingleObject(pi.hProcess, INFINITE) != WAIT_OBJECT_0) {\n";
    code << "         wcerr << L\"WaitForSingleObject failed lastError=\" << GetLastError() << endl;\n";
    code << "         ExitProcess(1);\n";
    code << "     }\n";
    code << "     DWORD dwExitCode;\n";
    code << "     if (!GetExitCodeProcess(pi.hProcess, &dwExitCode)) {\n";
    code << "         wcerr << L\"GetExitCodeProcess failed lastError=\" << GetLastError() << endl;\n";
    code << "         ExitProcess(1);\n";
    code << "     }\n";
    code << "     CloseHandle(pi.hProcess);\n";
    code << "     ExitProcess(dwExitCode);\n";
    code << " }\n";
    code << "\n";

    code << " // Nix's `scanForReferences' does not scan for Unicode strings (yet),\n";
    code << " // so add all the string constants again as UTF-8.\n";
    code << " // __declspec(dllexport) prevents the string from being optimized out.\n";
    code << " __declspec(dllexport) char* dummy[] = {\n";
    for (vector<pair<wstring, pair<wstring, wstring>>>::const_iterator t = env_prefix.begin(); t != env_prefix.end(); t++) {
        code << utf8literal(t->first        ) << ",\n";
        code << utf8literal(t->second.first ) << ",\n";
        code << utf8literal(t->second.second) << ",\n";
    }
    for (vector<pair<wstring, pair<wstring, wstring>>>::const_iterator t = env_suffix.begin(); t != env_suffix.end(); t++) {
        code << utf8literal(t->first        ) << ",\n";
        code << utf8literal(t->second.first ) << ",\n";
        code << utf8literal(t->second.second) << ",\n";
    }
    for (vector<pair<wstring, wstring>>::const_iterator t = env_set.begin(); t != env_set.end(); t++) {
        code << utf8literal(t->first ) << ",\n";
        code << utf8literal(t->second) << ",\n";
    }
    for (vector<pair<wstring, wstring>>::const_iterator t = env_set_default.begin(); t != env_set_default.end(); t++) {
        code << utf8literal(t->first ) << ",\n";
        code << utf8literal(t->second) << ",\n";
    }
    for (vector<wstring>::const_iterator t = env_unset.begin(); t != env_unset.end(); t++) {
        code << utf8literal(*t) << ",\n";
    }
    for (vector<wstring>::const_iterator t = add_flags.begin(); t != add_flags.end(); t++) {
        code << utf8literal(*t) << ",\n";
    }
    code << utf8literal(original_exe) << "};";

//  cerr << code.str() << endl;

    ofstream src("_wrapper.cpp", ofstream::out);
    src << code.str() << endl;
    src.close();

    #define L0(x)  L#x
    #define L1(x)  L0(x)
    if (!SetEnvironmentVariableW(L"INCLUDE", L1(INCLUDE))) {
        wcerr << L"SetEnvironmentVariableW(INCLUDE, " << L1(INCLUDE) << L") failed lastError=" << GetLastError() << endl;
        ExitProcess(1);
    }
    if (!SetEnvironmentVariableW(L"LIB", L1(LIB))) {
        wcerr << L"SetEnvironmentVariableA(LIB, " << L1(LIB) << L") failed lastError=" << GetLastError() << endl;
        ExitProcess(1);
    }

    wcerr << L"CreateProcessW(" << L1(CC) << L" /EHsc /Fe_wrapper.exe _wrapper.cpp /link /SUBSYSTEM:" << subsystem << L")..." << endl;
    STARTUPINFOW si = {sizeof(STARTUPINFOW)};
    PROCESS_INFORMATION pi = {0};
    if (!CreateProcessW(NULL, const_cast<wchar_t*>((wstring(L1(CC) L" /EHsc /Fe_wrapper.exe _wrapper.cpp /link /SUBSYSTEM:") + subsystem).c_str()), NULL, NULL, TRUE, 0, NULL, NULL, &si, &pi)) {
        wcerr << L"CreateProcessW(" << L1(CC) << L" /EHsc /Fe_wrapper.exe _wrapper.cpp /link /SUBSYSTEM:" << subsystem << L") failed lastError=" << GetLastError() << endl;
        ExitProcess(1);
    }

    if (WaitForSingleObject(pi.hProcess, INFINITE) != WAIT_OBJECT_0) {
        wcerr << L"WaitForSingleObject failed lastError=" << GetLastError() << endl;
        ExitProcess(1);
    }
    DWORD dwExitCode;
    if (!GetExitCodeProcess(pi.hProcess, &dwExitCode)) {
        wcerr << L"GetExitCodeProcess failed lastError=" << GetLastError() << endl;
        ExitProcess(1);
    }
    if (dwExitCode != 0) {
        wcerr << L"cl.exe exited with code=" << dwExitCode << endl;
        ExitProcess(1);
    }

    DeleteFileW(L"_wrapper.cpp");
    if (!CopyFileW(L"_wrapper.exe", wrapper_exe, /*bFailIfExists*/ TRUE)) {
        wcerr << L"CopyFile(_wrapper.exe," << wrapper_exe << ") failed lastError=" << GetLastError() << endl;
        ExitProcess(1);
    }
    DeleteFileW(L"_wrapper.exe");
    DeleteFileW(L"_wrapper.lib");
    DeleteFileW(L"_wrapper.exp");

    ExitProcess(dwExitCode);
}

