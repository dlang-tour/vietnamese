# Kiểu số cơ bản

D có các kiểu số cơ bản với kích cỡ bộ nhớ cần thiết là như nhau bất kể
hệ điều hành đang chạy là gì, ngoại trừ kiểu số thực `real` với dấu chấm động.
Cụ thể hơn, dù bạn đang chạy ứng dụng D trên máy 32 hay 64 bit, thì
mỗi biến của các kiểu sau vẫn chiếm cùng số bít trên bộ nhớ.

| kiểu                          | cỡ
|-------------------------------|------------
|`bool`                         | 8-bit
|`byte`, `ubyte`, `char`        | 8-bit
|`short`, `ushort`, `wchar`     | 16-bit
|`int`, `uint`, `dchar`         | 32-bit
|`long`, `ulong`                | 64-bit

#### Kiểu số thực với dấu chấm động

| kiểu    | cỡ
|---------|--------------------------------------------------
|`float`  | 32-bit
|`double` | 64-bit
|`real`   | >= 64-bit (thường là 64-bit, hoặc 80-bit trên Intel x86 32-bit)

Kiểu bắt đầu bởi `u` để kiểu không nhận giá trị âm (không dấu).
Kiểu `char` thực sự được nhúng trong UTF-8, trong khi `wchar`
dùng ký tự UTF-16, còn `dchar` là UTF-32.

Trình biên dịch D chỉ thực hiện chuyển đổi kiểu nếu đảm bảo được sự toàn vẹn
giá trị con số. Tuy nhiên, việc chuyển đổi giữa các kiểu số thực chấm động
thì được thực hiện thoải mái.

Việc chuyển đổi có thể  mang tính cưỡng chép bằng chỉ thị
`cast(KIỂU) tên_biến`. Việc này cần phải làm hết sức cẩn thận.

Từ khóa `auto` để khai báo biến và nội suy kiểu của nó từ biểu thức
bên phải. Ví dụ, `auto myVar = 7` sẽ xác định kiểu `int` cho biến `myVar`.
Việc nội suy này được thực hiện lúc biên dịch, và sau đó kết quả không thể
thay đổi.

### Giới hạn của các kiểu số

_(... hay là thuộc tính của kiểu.)_

Biến kiểu số cũng là đối tượng với các thuộc tính riêng, ví dụ

    int.init

xác định giá trị khởi đầu mặc định cho mỗi biến số kiểu `int`.
Với các kiểu số nguyên, giá trị này là `0`; với kiểu số chấm động, đó là `nan`.

Giá trị `kiểu.max` và `kiểu.min` xác định giới hạn trên, dưới hay là khoảng
các giá trị mà `kiểu` có thể biểu diễn. Ví dụ,

    int.max # 2147483647
    int.min # -2147483648

Với kiểu số chấm động, `kiểu.min_normal` là giá trị  nhỏ nhất khác `0`
biểu diễn được trong kiểu, còn `.nan` chỉ giá trị không xác định,
`.infinity` chỉ vô cùng, `.dig` chỉ số chữ số sau dấu phấy thập phân,
`.mant_dig` là số bit trong phần [Mantissa](https://www.doc.ic.ac.uk/~eedwards/compsys/float/), v.v...

Chỉ thị `kiểu.stringof` là chuỗi ký tự  biểu diễn tên của kiểu.

### Đánh số thứ tự

Để đánh số thứ tự, ví dụ cho các phần tử trong một mảng, ta có thể dùng
kiểu `size_t`, mà giới hạn của nó đủ lớn để đánh dấu tất cả các địa chỉ
trên bộ nhớ. Kiểu `size_t` thực ra là tên khác của kiểu `uint` trên máy
32 bit, hay của `ulong` trên máy 64 bit.

### Biểu thức chặn

Khi chương trình chạy ở chế độ dò lỗi (`debug`), biểu thức `assert` kiểm tra
một số điều kiện nào đó, và khi chúng bị vi phạm, biểu thức sẽ chặn không
cho chương trình chạy tiếp, và trả về lỗi `AssertionError`.

Chặn `assert(0)` đảm bảo toàn bộ đoạn mã sau đó không bao giờ được thi hành.

### Đọc tiếp

#### Phần cơ bản

- [Phép gán](http://ddili.org/ders/d.en/assignment.html)
- [Biến](http://ddili.org/ders/d.en/variables.html)
- [Số học](http://ddili.org/ders/d.en/arithmetic.html)
- [Số chấm động](http://ddili.org/ders/d.en/floating_point.html)
- [Phần Kiểu cơ bản trong sách _Programming in D_](http://ddili.org/ders/d.en/types.html)

#### Phần nâng cao

- [Tổng quan về các kiểu cơ bản trong D](https://dlang.org/spec/type.html)
- [Phần `auto` `typeof` trong sách _Programming in D_](http://ddili.org/ders/d.en/auto_and_typeof.html)
- [Tính chất của các kiểu](https://dlang.org/spec/property.html)
- [Biểu thức chặn](https://dlang.org/spec/expression.html#AssertExpression)

## {SourceCode}

```d
import std.stdio : writeln;

void main()
{
    // Để dễ đọc, dùng "_"
    // để tách các phần của số
    int b = 7_000_000;
    short c = cast(short) b; // cần đổi kiểu
    uint d = b; // không vấn đề gì
    int g;
    assert(g == 0);

    auto f = 3.1415f; // f là số thực

    // typeid(VAR) cho thông tin về kiểu.
    writeln("kiểu của f là ", typeid(f));
    double pi = f; // đổi kiểu được
    // vì đây là các số chấm động
    float demoted = pi;

    // xem thuộc tính của kiểu
    assert(int.init == 0);
    assert(int.sizeof == 4);
    assert(bool.max == 1);
    writeln(int.min, " ", int.max);
    writeln(int.stringof); // int
}
```
