# Unicode trong D

Unicode là tiêu chuẩn phổ quát để biểu diễn text trên máy tính.
Unicode được hỗ trợ đầy đủ trong ngôn ngữ D và các thư viện chuẩn của D.

## Cái gì và Tại sao

Xét ở tầng thấp nhất máy tính chỉ làm việc với các con số chứ không có
khái niệm về text (văn bản). Kết quả là cần đến các mã máy tính để
đọc và chuyển hóa thông tin từ text sang dạng biểu diễn nhị phân và
ngược lại. Cách thức chuyển hóa này được gọi là *encoding scheme*
và Unicode chỉ là một trong số cách.

Để xem biểu diễn số hóa của các chuỗi trong phần ví dụ, bạn hãy chọn
chạy các mã.

Unicode độc đáo ở chỗ thiết kế của nó cho phép biểu diexn tất cả các
ngôn ngữ (văn vản) trên thế giới theo cùng một cách. Trước Unicode,
máy tính được sản xuất bởi các hãng khác nhau hay được thiết kế cho các
vùng địa lý khác nhau khó mà giao tiếp thông suốt lẫn nhau, và một số
máy tính còn không hỗ trợ *encoding scheme* dẫn đến việc không thể xem
văn bản (text) trên máy.


Thông tin thêm về Unicode cùng với các chi tiết kỹ thuật có thể tìm
thấy trên trang Wikipedia được dẫn link ở phần Nâng cao.

## Thế nào

Unicode khắc phục hầu hết các vấn đề hiển thị và giao tiếp, và được hỗ
trợ trên các máy tính hiện đại. Học được bài học từ các ngôn ngữ cũ hơn,
D dùng unicode cho mọi chuỗi (trong C hay C++, chuỗi chỉ là mảng các byte).

Trong D, có các kiểu chuỗi `string`, `wstring`, và `dstring` ứng với
các bảng mã UTF-8, UTF-16, và UTF-32. Kiểu ký tự tương ứng với mỗi kiểu
chuỗi đó là `char`, `wchar`, và `dchar`.

Theo đặc tả của D, bạn không thể lưu các thông tin không đúng Unicode
vào các chuỗi. Chương trình của bạn sẽ bị lỗi theo các cách khác nhau
nếu chuỗi của bạn được mã hóa không đúng cách.

Để hỗ trợ các kiểu mã hóa khác, hay để làm giống như C/C++, bạn cần dùng
kiểu `ubyte[]` hoặc `char*`.

## Chuỗi trong các thuật toán liên quan tới dải

*Bạn có thể cần đọc qua phần về [thuật toán dải](gems/range-algorithms)
trước khi tiếp tục xem ở đây.*

Có vài điều quan trọng luôn phải nghĩ đến khi dùng Unicode trong D.

Trước hết, như là tính năng tiện lợi, khi duyệt qua chuỗi dùng các
thuật toán dải, Phobos mã hóa các ký tự của chuỗi `string` hay `wstring`
thành code-point trong UTF-32. Cách này, được biết đến với tên
**auto decoding**, có nghĩa là

```
static assert(is(typeof(utf8.front) == dchar));
```

Thiết kế này có nhiều hệ quả, và một trong số chúng gây bối rối cho nhiều
người, là biểu thức `std.traits.hasLength!(string)` trả về `False`.
Tại sao? Bởi theo tiêu chuẩn các thuật toán dải, hàm `length` dành cho
chuỗi trả về số ký tự trong một chuỗi, chứ không phải số phần từ mà
thuật toán dải sẽ duyệt qua.

Trong phần ví dụ, bạn sẽ thấy tại sao hai đối tượng có thể không luôn
bằng khớp nhau. Thuật toán dải trong Photos hoạt động theo cách mà các
chuỗi lại không có thông tin về chiều dài qua hàm `length`.

Để xem chi tiết kỹ thuật về **auto decoding**, và ảnh hưởng của nó tới
chương trình của bạn, hãy lần theo các liên kết trong phần Nâng cao.

### Nâng cao

- [Unicode on Wikipedia](https://en.wikipedia.org/wiki/Unicode)
- [Các hàm Unicode cơ bản trong Phobos](https://dlang.org/phobos/std_uni.html)
- [Công cụ để mã hóa và giải mã Unicode trong Phobos](https://dlang.org/phobos/std_utf.html)
- [Một bài viết sâu hơn về Auto Decoding](https://jackstouffer.com/blog/d_auto_decoding_and_you.html)
- [Lợi ích của việc dùng UTF-8 khắp nơi](http://utf8everywhere.org/)

## {SourceCode}

```d
import std.range.primitives : empty,
    front, popFront;
import std.stdio : write, writeln;

void main()
{
    string utf8 = "å ø ∑ 😦";
    wstring utf16 = "å ø ∑ 😦";
    dstring utf32 = "å ø ∑ 😦";

    writeln("utf8 length: ", utf8.length);
    writeln("utf16 length: ", utf16.length);
    writeln("utf32 length: ", utf32.length);

    foreach (item; utf8)
    {
        auto c = cast(ubyte) item;
        write(c, " ");
    }
    writeln();

    // Because the specified the element type is
    // dchar, look-ahead is used to encode the
    // string to UTF-32 code points.
    // For non-strings, a simple cast is used
    foreach (dchar item; utf16)
    {
        auto c = cast(ushort) item;
        write(c, " ");
    }
    writeln();

    // a result of auto-decoding
    static assert(
        is(typeof(utf8[0]) == immutable(char))
    );
    static assert(
        is(typeof(utf8.front) == dchar)
    );
}
```
