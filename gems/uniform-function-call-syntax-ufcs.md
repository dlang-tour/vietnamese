# UFCS hay cú pháp thống nhất gọi hàm

**UFCS** (Uniform Function Call Syntax) là một trong những
tính năng chìa khóa của D,
cho phép sử dụng lại hoặc mở rộng (scalability) mã nguồn
thông qua các đóng gói được định nghĩa tốt.

Với UFCS, phép gọi hàm `fun(a)` có thể viết thành `a.fun()`,
khiến hàm `fun` trông như là hàm thành phần của đối tượng `a`.

Nếu trình biên dịch xác nhận được rằng kiểu của đối tượwng `a`
không có hàm thành phần `fun()`, trình biên dịch sẽ thử tìm hàm
toàn cục mà tham số đầu tiên của nó khớp với `a`.

UFCS đặc biệt hữu ích khi gọi các hàm hợp. Thay vì viết

    foo(bar(a))

bạn có thể ghi đơn giản hơn

    a.bar().foo()

Hơn nữa, việc dùng cặp dấu ngoặc trống `()` là không cần thiết,
nghĩa là bạn chỉ việc ghi `a.bar.foo`: Khi đó, tên hàm cũng tựa như
là một thuộc tính của đối tượng. Ví dụ khác:

    import std.uni : toLower;
    "D rocks".toLower; // "d rocks"

UFCS đặc biệt quan trọng khi xử lý các dải (**range**) với phép hợp
các hàm / thuật toán liên tục, làm cho mã nguồn đơn giản, dễ bảo trì hơn:

    import std.algorithm : group;
    import std.range : chain, retro, front, retro;
    [1, 2].chain([3, 4]).retro; // 4, 3, 2, 1
    [1, 1, 2, 2, 2].group.dropOne.front; // tuple(2, 3u)

### Nâng cao

- [UFCS in _Programming in D_](http://ddili.org/ders/d.en/ufcs.html)
- [_Uniform Function Call Syntax_](http://www.drdobbs.com/cpp/uniform-function-call-syntax/232700394) by Walter Bright
- [`std.range`](http://dlang.org/phobos/std_range.html)

## {SourceCode}

```d
import std.stdio : writefln, writeln;
import std.algorithm.iteration : filter;
import std.range : iota;

void main()
{
    "Hello, %s".writefln("World");

    10.iota // returns numbers from 0 to 9
      // filter for even numbers
      .filter!(a => a % 2 == 0)
      .writeln(); // Ghi ra màn hình

    // Traditional style:
    writeln(filter!(a => a % 2 == 0)
                   (iota(10)));
}
```
