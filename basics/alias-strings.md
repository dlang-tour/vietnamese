# Chuỗi và Tên thân mật

Trong các phần trước bạn được biết về mảng, bất biến, các kiểu cơ bản.
Giờ bạn đoán xem mã sau nhắn gửi điều gì:

    alias string = immutable(char)[];

Trong `D`, chính xác là kiểu chuỗi (`string`) chỉ là tên khác, hay tên
thân mật, của kiểu `immutable(char)[]`, diễn giải ra là một bất biến
mảng các ký tự, hay cũng vậy, một lát cắt gồm các ký tự.

Vì là bất biến, một chuỗi được hình thành sẽ không thể thay đổi
(bất kỳ thay đổi nào cũng làm phát sinh vùng nhớ mới là bản sao của chuỗi ban đầu.)
Ứng dụng rất cụ thể của thiết kế này là các chuỗi có thể chia sẻ giữa
các luồng xử lý khác nhau.

Vì thực chất chuỗi là lát cắt, bạn có thể làm việc qua các "lăng kính"
mà không phát sinh tốn kém bộ nhớ.
Ví dụ hàm [`std.algorithm.splitter`](https://dlang.org/phobos/std_algorithm_iteration.html#.splitter)
tách chuỗi ban đầu thành các phần, nhưng nó kết quả thực tế là nó tạo
ra các lăng kính nhỏ hơn chứ không yêu cầu cấp phát thêm bất kỳ vùng nhớ nào.

Lưu ý là kiểu chuỗi `string` chỉ thích hợp cho chuỗi `UTF-8`.
Với các bảng mã phức tạp hơn, bạn cần `wstring` hoặc `dstring`:

    alias wstring = immutable(wchar)[]; // UTF-16
    alias dstring = immutable(dchar)[]; // UTF-32

Việc chuyển đổi giữa các kiểu chuỗi này được thực hiện qua hàm `to`:

    import std.conv: to;
    dstring myDstring = to!dstring(myString);
    string myString   = to!string(myDstring);

### Chuỗi ký tự Unicode

Kiểu chuỗi `string` có thể xem như là mảng gồm các phần tử 8 bit
[code unit](http://unicode.org/glossary/#code_unit). Các hàm tác động trên
chuỗi như thế cũng có tác dụng đối với chuỗi, nhưng ở mức tối thiểu
là `code unit` chứ không phải ở mức _ký tự_. Ồ, phân biệt _ký tự_
và _code unit_ là việc khó mà bạn cần đọc kỹ hơn nhé.

Cũng vậy, các thuật toán tiêu chuẩn trong D xem `string` như dải các
[code point](http://unicode.org/glossary/#code_point),
hoặc [grapheme](http://unicode.org/glossary/#grapheme)
(xem thư viện [`std.uni.byGrapheme`](https://dlang.org/library/std/uni/by_grapheme.html).)

Ví dụ minh họa cho các cách nhìn khác nhau này:

    string s = "\u0041\u0308"; // Ä

    writeln(s.length); // 3

    import std.range : walkLength;
    writeln(s.walkLength); // 2

    import std.uni : byGrapheme;
    writeln(s.byGrapheme.walkLength); // 1

Mảng `s` có chiều dài thật sự là 3, và gồm 3 `code unit`
`0x41`, `0x03` và `0x08`.
Hai `code unit` cuối có thể gộp là thành `code point` (bạn có nhớ ký tự unicode tổ hợp?),
và hàm
[`walkLength`](https://dlang.org/library/std/range/primitives/walk_length.html)
(thuộc bộ thư viện tiêu chuẩn xử lý các dải) hiểu được điều này, nên
gộp chúng thành 1 và nhìn mảng `s` có chiều dài 2.
Cùng lúc đó, `byGrapheme` lại hiểu hai `code point` như thành phần một ký tự
nên chỉ trả về kết quả 1.

Xử lý hợp lý đầu vào Unicode là việc phức tạp, nhưng hầu hết trường hợp
bạn chỉ cần quan tâm tới kiểu chuỗi `string`. Nếu cần quan tâm chi tiết
tới từng `code unit`, bạn có thể xem
[`byCodeUnit`](http://dlang.org/phobos/std_utf.html#.byCodeUnit).

Việc xử lý các kiểu Unicode khác nhau được mô tả trong
[FIXME/Unicode gems chapter](/FIXME/gems/unicode).

### Chuỗi nhiều dòng

Một chuỗi có thể gồm nhiều dòng

    string multiline = "
    This
    may be a
    long document
    ";

Khi cần phải thể hiện dấu nháy (`"`), bạn để ý tới chuỗi `Wysiwyg`
và [heredoc](http://dlang.org/spec/lex.html#delimited_strings).

### Chuỗi Wysiwyg

Tốt nhất phần này được hiểu qua các minh họa:

    string raw  =  `raw "string"`; // chuỗi "string"
    string raw2 = r"raw `string`"; // chuỗi `string`

Còn nhiều cách khác để biểu diễn chuỗi [bạn có thể xem ở đây](https://dlang.org/spec/lex.html#string_literals).

### Đọc thêm

- [FIXME/Unicode gem](/FIXME/gems/unicode)
- [Ký tự trong sách _Programming in D_](http://ddili.org/ders/d.en/characters.html)
- [Chuỗi trong sách _Programming in D_](http://ddili.org/ders/d.en/strings.html)
- [std.utf](http://dlang.org/phobos/std_utf.html) - UTF en-/decoding algorithms
- [std.uni](http://dlang.org/phobos/std_uni.html) - Unicode algorithms
- [Đặc tả biểu diễn chuỗi](http://dlang.org/spec/lex.html#string_literals)

## {SourceCode}

```d
import std.stdio : writeln, writefln;
import std.range : walkLength;
import std.uni : byGrapheme;
import std.string : format;

void main() {
    // format dùng cú pháp tương tự printf
    // Chuỗi UTF được hỗ trợ mặc định.
    string str = format("%s %s", "Hellö",
        "Wörld");
    writeln("Chuỗi của bạn: ", str);
    writeln("Độ dài mảng (tính theo code unit)"
        ~ ": ", str.length);
    writeln("Đội dài dải (tính theo code point)"
        ~ ": ", str.walkLength);
    writeln("Đếm ký tự (đếm theo grapheme)"
        ~ ": ",
        str.byGrapheme.walkLength);

    // Chuỗi chỉ là mảng, nên cứ dùng
    // các hàm đã biết cho mảng là được
    import std.array : replace;
    writeln(replace(str, "lö", "lo"));
    import std.algorithm : endsWith;
    writefln("Chuỗi %s kết thúc bởi 'rld'? %s",
        str, endsWith(str, "rld"));

    import std.conv : to;
    // Đổi qua UTF-32
    dstring dstr = to!dstring(str);
    // ... kết quả dường như không đổi!
    writeln("Chuỗi của bạn: ", dstr);
}
```
