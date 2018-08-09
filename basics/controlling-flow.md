# Mạch logic

_(hay `luồng điều khiển`, `Control Flow`)_

Mạch logic trong ứng dụng được thể hiện nhờ `if` `else`

    if (a == 5) {
        writeln("Điều kiện thỏa mãn");
    } else if (a > 10) {
        writeln("Điều kiện khác thỏa mãn");
    } else {
        writeln("Không khớp trường hợp nào!");
    }

Cặp dấu ngoặc `{ }` có thể bỏ qua nếu theo sau `if` hoặc `else` chỉ
có đúng một biểu thức đơn.

D có các toán tử so sánh giống như trong C/C++ hay Java:

* `==` và `!=` để so sánh bằng hoặc khác nhau
* `<`, `<=`, `>` và `>=` để so sánh nhỏ hơn, nhỏ hơn hoặc bằng, lớn hơn, lớn hơn hoặc bằng.

Kết hợp các toán tử bằng `||` (phép toán logic *OR*) hoặc `&&`
(phép toán logic *AND*.)

Trong D còn có biểu thức `switch`..`case` để thi hành biểu thức ứng
với giá trị của biến. `switch` thích hợp với các kiểu cơ bản và kiểu chuỗi,
và nó chấp nhận một khoảng giá trị `case BẮT_ĐẦU: .. case KẾT_THÚC:`
Bạn xem thêm phần mã nguồn của ví dụ để rõ hơn.

### Đọc thêm

#### Cơ bản

- [Biểu thức logic trong sách _Programming in D_](http://ddili.org/ders/d.en/logical_expressions.html)
- [Biểu thức `if` trong sách _Programming in D_](http://ddili.org/ders/d.en/if.html)
- [Biểu thức cặp ba trong sách _Programming in D_](http://ddili.org/ders/d.en/ternary.html)
- [`switch` và `case` trong sách _Programming in D_](http://ddili.org/ders/d.en/switch_case.html)

#### Nâng cao

- [Expressions in detail](https://dlang.org/spec/expression.html)
- [If Statement specification](https://dlang.org/spec/statement.html#if-statement)

## {SourceCode}

```d
import std.stdio : writeln;

void main()
{
    if (1 == 1)
        writeln("D làm toán đúng mà!");

    int c = 5;
    switch(c) {
        case 0: .. case 9:
            writeln(c, " trong khoảng 0-9");
            break; // cần thiết!
        case 10:
            writeln("Đó là mười!");
            break;
        default: // Không khớp trường hợp nào
            writeln("Không khớp cái gì cả");
            break;
    }
}
```
