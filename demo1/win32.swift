let className = "SwiftWindow"
var classNamePtr: UnsafePointer<Int8>?

_ = className.utf8CString.withUnsafeBufferPointer { ptr in
    classNamePtr = ptr.baseAddress!
}

let windowName = "Learn to Program Windows in Swift"
var windowNamePtr: UnsafePointer<Int8>?

_ = windowName.utf8CString.withUnsafeBufferPointer { ptr in
    windowNamePtr = ptr.baseAddress!
}

let hInstance = GetModuleHandleA(nil)

var wc = WNDCLASSA()
wc.hInstance = hInstance
wc.lpszClassName = classNamePtr
wc.lpfnWndProc = { hwnd, uMsg, wParam, lParam in
    switch Int32(uMsg) {
    case WM_DESTROY:
        PostQuitMessage(0);
    case WM_PAINT:
        var ps = PAINTSTRUCT()
        let hdc = BeginPaint(hwnd, &ps)
        FillRect(hdc, &ps.rcPaint, UnsafeMutablePointer<HBRUSH__>(bitPattern: Int(COLOR_WINDOW) + 1))
        EndPaint(hwnd, &ps)
    default:
        break
    }
    return DefWindowProcA(hwnd, uMsg, wParam, lParam)
}

RegisterClassA(&wc)

let WS_OVERLAPPEDWINDOW = UInt32(WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_THICKFRAME | WS_MINIMIZEBOX | WS_MAXIMIZEBOX)

// CW_USEDEFAULT == 0x80000000 == 1 << 31
// Use CW_USEDEFAULT will report integer overflows.
let hwnd = CreateWindowExA(0, classNamePtr, windowNamePtr, WS_OVERLAPPEDWINDOW, 1 << 31, 1 << 31, 1 << 31, 1 << 31, nil, nil, hInstance, nil)
if hwnd != nil {
    ShowWindow(hwnd, SW_SHOWNORMAL)
    var msg = MSG()
    while GetMessageA(&msg, nil, 0, 0) != 0 {
        TranslateMessage(&msg)
        DispatchMessageA(&msg)
    }
}
