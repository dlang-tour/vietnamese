# Mixin chuỗi

Biểu thức `mixin` thoạt nhìn tựa như `eval` trong `JavaScript`:
nó biến đổi chuỗi đầu vào thành mã nguồn. Nhưng trong `D`, `mixin`
chỉ xảy ra lúc biên dịch, và nó chỉ nhận đầu vào là chuỗi:

    mixin("int b = 5");
    assert(b == 5); // b bằng 5 đúng như mong đợi

`mixin` cũng có thể nhận đầu vào là các chuỗi được ghép hay phát sinh từ
các biểu thức phức hợp, miễn là chuỗi kết quả không phụ thuộc vào các giá trị
lúc chạy chương trình (`runtime`).

`mixin` cùng với `CTFE` trong phần kế tiếp giúp xây dựng các thư viện
ấn tượng như [Pegged](https://github.com/PhilippeSigaud/Pegged) là thư
viện giúp sinh ra bộ phân rã ngữ pháp (`grammar parser`)
từ chuỗi định nghĩa cú pháp trong mã nguồn.

### Nâng cao

- [Mixin trong D](https://dlang.org/spec/template-mixin.html)

## {SourceCode}

```d
import std.stdio : writeln;

auto calculate(string op, T)(T lhs, T rhs)
{
    return mixin("lhs " ~ op ~ " rhs");
}

void main()
{
    // Cách khác để in ra chuỗi Hello World.
    mixin(`writeln("Hello World");`);

    // tham số mẫu là toán tử cần dùng
    writeln("5 + 12 = ", calculate!"+"(5,12));
    writeln("10 - 8 = ", calculate!"-"(10,8));
    writeln("8 * 8 = ", calculate!"*"(8,8));
    writeln("100 / 5 = ", calculate!"/"(100,5));
}
```
