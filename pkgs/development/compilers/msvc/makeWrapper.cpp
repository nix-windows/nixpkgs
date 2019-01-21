﻿#include <assert.h>
#include <windows.h>
#include <map>
#include <vector>
#include <tuple>
#include <iostream>
#include <fstream>
#include <codecvt>

using namespace std;

// hello -> L"hello"
string wliteral(const wstring & ws) {
    string rc = "L\"";
    for (wchar_t c : ws) {
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
    wstring_convert<codecvt_utf8_utf16<wchar_t>> converter;
    string rc = "\"";
    for (char c : converter.to_bytes(ws)) {
        if (' ' <= c && c <= '~') {
            if (c == '"' || c == '\\')
                rc += '\\';
            rc += c;
        } else {
            char sz[5];
            sprintf(sz, "\\x%02X", c);
            rc += sz;
        }
    }
    rc += '"';
    return rc;
}

int wmain(int argc, const wchar_t** argv) {
    assert(argc >= 3);
    const wstring original_exe = argv[1];
    const wstring wrapper_exe = argv[2];

    vector<wstring>                          env_unset;
    vector<tuple<wstring, wstring>>          env_set;
    vector<tuple<wstring, wstring>>          env_set_default;
    vector<tuple<wstring, wstring, wstring>> env_prefix;
    vector<tuple<wstring, wstring, wstring>> env_suffix;
    vector<wstring>                          add_flags;

    for (int i=3; i<argc; ) {
        const wstring verb = argv[i++];
             if (verb == L"--set"             && i+2 <= argc) env_set.push_back(make_tuple(argv[i], argv[i+1])), i+=2;
        else if (verb == L"--set-default"     && i+2 <= argc) env_set_default.push_back(make_tuple(argv[i], argv[i+1])), i+=2;
        else if (verb == L"--unset"           && i+1 <= argc) env_unset.push_back(argv[i++]);
        else if (verb == L"--run"             && i+1 <= argc) assert(!"TODO");
        else if (verb == L"--prefix"          && i+3 <= argc) env_prefix.push_back(make_tuple(argv[i], argv[i+1], argv[i+2])), i+=3;
        else if (verb == L"--suffix"          && i+3 <= argc) env_suffix.push_back(make_tuple(argv[i], argv[i+1], argv[i+2])), i+=3;
        else if (verb == L"--suffix-each"     && i+3 <= argc) assert(!"TODO");
        else if (verb == L"--prefix-contents" && i+3 <= argc) assert(!"TODO");
        else if (verb == L"--suffix-contents" && i+3 <= argc) assert(!"TODO");
        else if (verb == L"--add-flags"       && i+1 <= argc) add_flags.push_back(argv[i++]);
        else if (verb == L"--argv0"           && i+1 <= argc) assert(!"TODO");
        else {
          wcerr << L"unknown verb '" << verb.c_str() << L"'" << endl;
          exit(1);
        }
    }

    // TODO: generate plain C code, without C++ and STL (and build with /NODEFAULTLIBS), it could end up in very small wrapper executables
    string code = R"(
        #include <windows.h>
        #include <assert.h>
        #include <iostream>
        #include <vector>
        #include <map>
        #pragma comment(lib, "shell32.lib")
        using namespace std;
        // copy-paste from Nix's libutil/util.cc
        wstring windowsEscapeW(const wstring & s)
        {
            if (s.empty() || s.find_first_of(L"&()<>[]{}^=;!'+,`!\"\t ") != std::wstring::npos) {
                std::wstring r = L"\"";
                for (auto i=0; i < s.length(); ) {
                    if (s[i] == L'"') {
                        r += L'\\';
                        r += s[i++];
                    } else if (s[i] == L'\\') {
                        for (int j = 1; ; j++) {
                            if (i+j == s.length()) {
                                while (j--) { r += L'\\'; r += L'\\'; i++; };
                                break;
                            } else if (s[i+j] == L'"') {
                                while (j--) { r += L'\\'; r += L'\\'; i++; }
                                r += L'\\';
                                r += s[i++];
                                break;
                            } else if (s[i+j] != L'\\') {
                                while (j--) { r += L'\\'; i++; };
                                r += s[i++];
                                break;
                            }
                        }
                    } else {
                        r += s[i++];
                    }
                }
                r += L'"';
                return r;
            } else
                return s;
        }
        struct no_case_compare {
            bool operator() (const wstring & s1, const wstring & s2) const {
                return wcsicmp(s1.c_str(), s2.c_str()) < 0;
            }
        };
        void main() {
            map<wstring, wstring, no_case_compare> env;
            {
                const wchar_t* pw = GetEnvironmentStringsW();
                assert(pw);
                while (*pw) {
                    size_t len = wcslen(pw);
                    const wchar_t* peq = wcschr(pw+1, L'=');
                    if (peq < pw + len) {
                        env[wstring(pw, peq-pw)] = wstring(peq+1, pw+len-(peq+1));
                    } else {
                        env[wstring(pw, len)] = L"";
                    }
                    pw += len + 1;
                }
            }
            vector<wstring> args;
            {
                int numArgs;
                LPWSTR* wargv = CommandLineToArgvW(GetCommandLineW(), &numArgs);
                assert(wargv);
                for (int i=0; i<numArgs; i++) args.push_back(wargv[i]);
                LocalFree(wargv);
            }
    )";
    for (auto & t : env_prefix) {
        code += R"(
            {
                auto it = env.find()" + wliteral(get<0>(t)) + R"();
                env[)" + wliteral(get<0>(t)) + "] = it == env.end() ? " + wliteral(get<2>(t)) + " : (" + wliteral(get<2>(t)) + " " + wliteral(get<1>(t)) + R"() + it->second;
            }
        )";
    }
    for (auto & t : env_suffix) {
        code += R"(
            {
                auto it = env.find()" + wliteral(get<0>(t)) + R"();
                env[)" + wliteral(get<0>(t)) + "] = it == env.end() ? " + wliteral(get<2>(t)) + " : it->second + (" + wliteral(get<1>(t)) + " " + wliteral(get<2>(t)) + R"();
            }
        )";
    }
    for (auto & t : env_set) {
        code += R"(
            env[)" + wliteral(get<0>(t)) + "] = " + wliteral(get<1>(t)) + R"(;
        )";
    }
    for (auto & t : env_set_default) {
        code += R"(
            if (env.find()" + wliteral(get<0>(t)) + R"() == env.end())
                env[)" + wliteral(get<0>(t)) + "] = " + wliteral(get<1>(t)) + R"(;
        )";
    }
    for (auto & t : env_unset) {
        code += R"(
            env.erase()" + wliteral(t) + R"();
        )";
    }
    code += R"(
        args[0] = )" + wliteral(original_exe) + R"(;
    )";
    for (auto & t : add_flags) {
        code += R"(
            args.push_back()" + wliteral(t) + R"();
        )";
    }

    code += R"(
            wstring ucmdline, uenvline;
            for (const auto & v : args) {
                if (!ucmdline.empty()) ucmdline += L' ';
                ucmdline += windowsEscapeW(v);
            }
            for (auto & i : env)
                uenvline += i.first + L'=' + i.second + L'\0';
            uenvline += L'\0';

            STARTUPINFOW si = {sizeof(STARTUPINFOW)};
            PROCESS_INFORMATION pi = {0};
            if (!CreateProcessW(NULL,                                       // LPCWSTR               lpApplicationName
                                const_cast<wchar_t*>(ucmdline.c_str()),     // LPWSTR                lpCommandLine
                                NULL,                                       // LPSECURITY_ATTRIBUTES lpProcessAttributes
                                NULL,                                       // LPSECURITY_ATTRIBUTES lpThreadAttributes
                                TRUE,                                       // BOOL                  bInheritHandles
                                CREATE_UNICODE_ENVIRONMENT,                 // DWORD                 dwCreationFlags
                                const_cast<wchar_t*>(uenvline.c_str()),     // LPVOID                lpEnvironment
                                NULL,                                       // LPCWSTR               lpCurrentDirectory
                                &si,                                        // LPSTARTUPINFOW        lpStartupInfo
                                &pi)) {                                     // LPPROCESS_INFORMATION lpProcessInformation
                wcout << L"CreateProcessW(" << ucmdline.c_str() << ") failed lastError=" << GetLastError() << endl;
                ExitProcess(1);
            }
            CloseHandle(pi.hThread);

            if (WaitForSingleObject(pi.hProcess, INFINITE) != WAIT_OBJECT_0) {
                wcout << L"WaitForSingleObject failed lastError=" << GetLastError() << endl;
                ExitProcess(1);
            }
            DWORD dwExitCode = 777;
            if (!GetExitCodeProcess(pi.hProcess, &dwExitCode)) {
                wcout << L"GetExitCodeProcess failed lastError=" << GetLastError() << endl;
                ExitProcess(1);
            }
            CloseHandle(pi.hProcess);
            ExitProcess(dwExitCode);
        }
    )";

    // Nix's scanForReferences does not scan for Unicode strings (yet), so add all the string constants again as UTF-8
    code += R"(const char* dummy[] = { )";
    for (auto & t : env_prefix) {
        code += utf8literal(get<0>(t)) + ",\n";
        code += utf8literal(get<1>(t)) + ",\n";
        code += utf8literal(get<2>(t)) + ",\n";
    }
    for (auto & t : env_suffix) {
        code += utf8literal(get<0>(t)) + ",\n";
        code += utf8literal(get<1>(t)) + ",\n";
        code += utf8literal(get<2>(t)) + ",\n";
    }
    for (auto & t : env_set) {
        code += utf8literal(get<0>(t)) + ",\n";
        code += utf8literal(get<1>(t)) + ",\n";
    }
    for (auto & t : env_set_default) {
        code += utf8literal(get<0>(t)) + ",\n";
        code += utf8literal(get<1>(t)) + ",\n";
    }
    for (auto & t : env_unset) {
        code += utf8literal(t) + ",\n";
    }
    for (auto & t : add_flags) {
        code += utf8literal(t) + ",\n";
    }
    code += R"( ""};)";

//  cout << code.c_str() << endl;

    ofstream src("_wrapper.cpp", ofstream::out);
    src << code.c_str() << endl;
    src.close();

    #define L0(x)  L#x
    #define L1(x)  L0(x)
    if (!SetEnvironmentVariableW(L"INCLUDE", L1(INCLUDE))) {
        wcout << L"SetEnvironmentVariableW(INCLUDE, " << L1(INCLUDE) << L") failed lastError=" << GetLastError() << endl;
        ExitProcess(1);
    }
    if (!SetEnvironmentVariableW(L"LIB", L1(LIB))) {
        wcout << L"SetEnvironmentVariableA(LIB, " << L1(LIB) << L") failed lastError=" << GetLastError() << endl;
        ExitProcess(1);
    }

    STARTUPINFOW si = {sizeof(STARTUPINFOW)};
    PROCESS_INFORMATION pi = {0};
    if (!CreateProcessW(NULL, const_cast<wchar_t*>(((L1(CC) L" /EHsc /Fe:") + wrapper_exe + L" _wrapper.cpp").c_str()), NULL, NULL, TRUE, 0, NULL, NULL, &si, &pi)) {
        wcout << L"CreateProcessW(" << L1(CC) << L" _wrapper.cpp) failed lastError=" << GetLastError() << endl;
        ExitProcess(1);
    }

    if (WaitForSingleObject(pi.hProcess, INFINITE) != WAIT_OBJECT_0) {
        wcout << L"WaitForSingleObject failed lastError=" << GetLastError() << endl;
        ExitProcess(1);
    }
    DWORD dwExitCode = 777;
    if (!GetExitCodeProcess(pi.hProcess, &dwExitCode)) {
        wcout << L"GetExitCodeProcess failed lastError=" << GetLastError() << endl;
        ExitProcess(1);
    }
    DeleteFile("_wrapper.cpp");
//  wcout << L"exitCode=" << dwExitCode << endl;
    ExitProcess(dwExitCode);
}
