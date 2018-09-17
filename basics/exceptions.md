# Lỗi ngoại lệ

Phần này chỉ bàn về ngoại lệ (`Exception`) ở mức độ người dùng.
Các lỗi ngoại lệ có tính hệ thống thường là tai họa và không nên cố tránh né chúng.

### Bắt lỗi ngoại lệ

Trường hợp phổ biến là bắt lỗi ngoại lệ khi xử lý dữ liệu do người dùng nhập vào.
Khi phát sinh lỗi ngoại lệ, ngăn xếp (`stack`) chạy chương trình được nhả
ra cho tới khi bắt được lỗi ngoại lệ đầu tiên.

```d
try
{
    readText("dummyFile");
}
catch (FileException e)
{
    // ...
}
```

Bạn chủ động sinh ra lỗi ngoại lệ nhờ `throw`.
Có thể bắt nhiều lỗi ngoại lệ khác nhau,
và cũng có `finally` để thi hành phần mã dẫu trước đó có lỗi hoặc không.


```d
try
{
    throw new StringException("Lỗi rồi, không qua được nhé!");
}
catch (FileException e)
{
    // ...
}
catch (StringException e)
{
    // ...
}
finally
{
    // ...
}
```

Tuy nhiên, cần nhớ rằng việc dùng [khóa giới hạn](gems/scope-guards) thường tốt hơn là `try-finally`.

### Đặt lỗi ngoại lệ mới

Có thể đặt ra các kiểu lỗi ngoại lệ mới nhờ lớp thừa kế từ `Exception`:

```d
class UserNotFoundException : Exception
{
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
        super(msg, file, line);
    }
}
throw new UserNotFoundException("D-Man đang đi du lịch.");
```

### Cấm hoàn toàn việc phát sinh lỗi ngoại lệ

Trình biên dịch có thể đảm bảo hàm không gây ra các hiệu ứng phụ nguy hiểm nào.
Các hàm đánh dấu bởi `nothrow` được trình biên dịch đánh dấu
và ngăn nó phát sinh bất kỳ lỗi ngoại lệ nào.

```d
bool lessThan(int a, int b) nothrow
{
    writeln("thế giới nguy hiểm");
    // Chuỗi output có thể gây lỗi ngoại lệ, nhưng vì hàm này
    // được đánh dấu với `nothrow`, trình biên dịch sẽ không
    // cho phép bạn dùng writeln như ở trên. Nói cách khác,
    // bạn không thể biên dịch đoạn mã nguồn này.

    return a < b;
}
```

Lưu ý thêm là trình biên dịch có thể nội suy tính chất cho các mã mẫu
một cách tự động.

### std.exception

Điều quan trọng cần nhớ là cần tránh dùng `assert`
và cả [lập trình hợp đồng](gems/contract-programming) khi xử lý dữ liệu đầu vào
từ người dùng, bởi vì `assert` hay hợp đồng đều bị bỏ qua khi trình biên dịch
không bật cờ dò lỗi (`debug`). Bạn có thể dùng thư viện
[`std.exception`](https://dlang.org/phobos/std_exception.html)
trong đó hàm
[`enforce`](https://dlang.org/phobos/std_exception.html#enforce)
có vai trò tương tự `assert`, nhưng nó phát sinh lỗi ngoại lệ (`Exception`)
thay vì `AssertError`.

```d
import std.exception : enforce;
float magic = 1_000_000_000;
enforce(magic + 42 - magic == 42, "Dấu chấm động... vui nhỉ :)");

// throw custom exceptions
// quăng lỗi ngoại lệ do lập trình viên định nghĩa
enforce!StringException('a' != 'A', "Phân biệt hoa thường.");
```

Thư viện `std.exception` cũng có nhiều thứ khác. Ví dụ khi lỗi không đến
mức tai họa, bạn có thể bỏ qua nhờ
[collect](https://dlang.org/phobos/std_exception.html#collectException):

```d
import std.exception : collectException;
auto e = collectException(aDangerousOperation());
if (e)
    writeln("Hàm phát sinh lỗi ", e);
```

Khi viết mã kiểm tra mức độ đơn vị,
bạn giả lập các lỗi quăng ra với [`assertThrown`](https://dlang.org/phobos/std_exception.html#assertThrown).

### Nâng cao

- [An toàn với ngoại lệ](https://dlang.org/exception-safe.html)
- [std.exception](https://dlang.org/phobos/std_exception.html)
- system-level [core.exception](https://dlang.org/phobos/core_exception.html)
- [object.Exception](https://dlang.org/library/object/exception.html) - lớp cơ bản cho mọi lỗi ngoại lệ

## {SourceCode}

```d
import std.file : FileException, readText;
import std.stdio : writeln;

void main()
{
    try
    {
        readText("dummyFile");
    }
    catch (FileException e)
    {
        writeln("Message:\n", e.msg);
        writeln("File: ", e.file);
        writeln("Line: ", e.line);
        writeln("Stack trace:\n", e.info);

        // In ra lỗi với định dạng mặc định
        // writeln(e);
    }
}
```
