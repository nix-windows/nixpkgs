#include <assert.h>
#include <windows.h>
#include <map>
#include <vector>
#include <tuple>
#include <iostream>
#include <fstream>

using namespace std;

string wliteral(const wstring ws) {
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

    // TODO: generate plain C code (and build with /NODEFAULTLIBS), it could end up in very small wrapper executables
    string code;
    code += "#include <windows.h>\n";
    code += "#include <assert.h>\n";
    code += "#include <iostream>\n";
    code += "#include <vector>\n";
    code += "#include <map>\n";
    code += "#pragma comment(lib, \"shell32.lib\")\n";
    code += "using namespace std;\n";
    code += "wstring windowsEscapeW(const wstring & s) {\n";
    code += "    if (!s.empty() && s.find_first_of(L\"&()[]{}^=;!'+,`!\\\" \") == wstring::npos)\n";
    code += "        return s;\n";
    code += "    wstring r;\n";
    code += "    for (auto & i : s) {\n";
    code += "        if (i == '\"') r += L\"\\\"\\\"\\\"\"; else r += i;\n";
    code += "    }\n";
    code += "    return L'\"' + r + L'\"';\n";
    code += "}\n";
    code += "struct no_case_compare {\n";
    code += "    bool operator() (const wstring & s1, const wstring & s2) const {\n";
    code += "        return wcsicmp(s1.c_str(), s2.c_str()) < 0;\n";
    code += "    }\n";
    code += "};\n";
    code += "void main() {\n";
    code += "    map<wstring, wstring, no_case_compare> env;\n";
    code += "    {\n";
    code += "        const wchar_t* pw = GetEnvironmentStringsW();\n";
    code += "        assert(pw);\n";
    code += "        while (*pw) {\n";
    code += "            size_t len = wcslen(pw);\n";
    code += "            const wchar_t* peq = wcschr(pw+1, L'=');\n";
    code += "            if (peq < pw + len) {\n";
    code += "                env[wstring(pw, peq-pw)] = wstring(peq+1, pw+len-(peq+1));\n";
    code += "            } else {\n";
    code += "                env[wstring(pw, len)] = L\"\";\n";
    code += "            }\n";
    code += "            pw += len + 1;\n";
    code += "        }\n";
    code += "    }\n";
    code += "    vector<wstring> args;\n";
    code += "    {\n";
    code += "        int numArgs;\n";
    code += "        LPWSTR* wargv = CommandLineToArgvW(GetCommandLineW(), &numArgs);\n";
    code += "        assert(wargv);\n";
    code += "        for (int i=0; i<numArgs; i++) args.push_back(wargv[i]);\n";
    code += "        LocalFree(wargv);\n";
    code += "    }\n";

    for (auto & t : env_prefix) {
        code += "auto it = env.find(" + wliteral(get<0>(t)) + ");\n";
        code += "env[" + wliteral(get<0>(t)) + "] = it == env.end() ? " + wliteral(get<2>(t)) + " : (" + wliteral(get<2>(t)) + " " + wliteral(get<1>(t)) + ") + it->second;\n";
    }
    for (auto & t : env_suffix) {
        code += "auto it = env.find(" + wliteral(get<0>(t)) + ");\n";
        code += "env[" + wliteral(get<0>(t)) + "] = it == env.end() ? " + wliteral(get<2>(t)) + " : it->second + (" + wliteral(get<1>(t)) + " " + wliteral(get<2>(t)) + ");\n";
    }
    for (auto & t : env_set) {
        code += "env[" + wliteral(get<0>(t)) + "] = " + wliteral(get<1>(t)) + ";\n";
    }
    for (auto & t : env_set_default) {
        code += "if (env.find(" + wliteral(get<0>(t)) + ") == env.end())\n";
        code += "    env[" + wliteral(get<0>(t)) + "] = " + wliteral(get<1>(t)) + ";\n";
    }
    for (auto & t : env_unset) {
        code += "env.erase(" + wliteral(t) + ");\n";
    }

    code += "args[0] = " + wliteral(original_exe) + ";\n";
    for (auto & t : add_flags) {
        code += "args.push_back(" + wliteral(t) + ");\n";
    }

    code += "    wstring ucmdline, uenvline;\n";
    code += "    for (const auto & v : args) {\n";
    code += "        if (!ucmdline.empty()) ucmdline += L' ';\n";
    code += "        ucmdline += windowsEscapeW(v);\n";
    code += "    }\n";
    code += "    for (auto & i : env)\n";
    code += "        uenvline += i.first + L'=' + i.second + L'\\0';\n";
    code += "    uenvline += L'\\0';\n";

    code += "    STARTUPINFOW si = {sizeof(STARTUPINFOW)};\n";
    code += "    PROCESS_INFORMATION pi = {0};\n";
    code += "    if (!CreateProcessW(NULL,\n";                                   // LPCWSTR               lpApplicationName
    code += "                        const_cast<wchar_t*>(ucmdline.c_str()),\n"; // LPWSTR                lpCommandLine
    code += "                        NULL,\n";                                   // LPSECURITY_ATTRIBUTES lpProcessAttributes
    code += "                        NULL,\n";                                   // LPSECURITY_ATTRIBUTES lpThreadAttributes
    code += "                        TRUE,\n";                                   // BOOL                  bInheritHandles
    code += "                        CREATE_UNICODE_ENVIRONMENT,\n";             // DWORD                 dwCreationFlags
    code += "                        const_cast<wchar_t*>(uenvline.c_str()),\n"; // LPVOID                lpEnvironment
    code += "                        NULL,\n";                                   // LPCWSTR               lpCurrentDirectory
    code += "                        &si,\n";                                    // LPSTARTUPINFOW        lpStartupInfo
    code += "                        &pi)) {\n";                                 // LPPROCESS_INFORMATION lpProcessInformation
    code += "        wcout << L\"CreateProcessW(\" << ucmdline.c_str() << \") failed lastError=\" << GetLastError() << endl;\n";
    code += "        ExitProcess(1);\n";
    code += "    }\n";
    code += "    CloseHandle(pi.hThread);\n";

    code += "    if (WaitForSingleObject(pi.hProcess, INFINITE) != WAIT_OBJECT_0) {\n";
    code += "        cout << \"WaitForSingleObject failed lastError=\" << GetLastError() << endl;\n";
    code += "        ExitProcess(1);\n";
    code += "    }\n";
    code += "    DWORD dwExitCode = 777;\n";
    code += "    if (!GetExitCodeProcess(pi.hProcess, &dwExitCode)) {\n";
    code += "        cout << \"GetExitCodeProcess failed lastError=\" << GetLastError() << endl;\n";
    code += "        ExitProcess(1);\n";
    code += "    }\n";
    code += "    CloseHandle(pi.hProcess);\n";
    code += "    ExitProcess(dwExitCode);\n";
    code += "}\n";

    ofstream src("_wrapper.cpp", ofstream::out);
    src << code.c_str() << endl;
    src.close();

    STARTUPINFOW si = {sizeof(STARTUPINFOW)};
    PROCESS_INFORMATION pi = {0};
    if (!CreateProcessW(NULL, const_cast<wchar_t*>((L"cl /EHsc /Fe:" + wrapper_exe + L" _wrapper.cpp").c_str()), NULL, NULL, TRUE, 0, NULL, NULL, &si, &pi)) {
        cout << "CreateProcessW(cl _wrapper.cpp) failed lastError=" << GetLastError() << endl;
        ExitProcess(1);
    }

    if (WaitForSingleObject(pi.hProcess, INFINITE) != WAIT_OBJECT_0) {
        cout << "WaitForSingleObject failed lastError=" << GetLastError() << endl;
        ExitProcess(1);
    }
    DWORD dwExitCode = 777;
    if (!GetExitCodeProcess(pi.hProcess, &dwExitCode)) {
        cout << "GetExitCodeProcess failed lastError=" << GetLastError() << endl;
        ExitProcess(1);
    }
    DeleteFile("_wrapper.cpp");
//  cout << "exitCode=" << dwExitCode << endl;
    ExitProcess(dwExitCode);
}
