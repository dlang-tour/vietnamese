# Xử lý trên bit

Phần này là ví dụ tuyệt vời cho khả năng sinh mã lúc biên dịch với mixin.
Đó là việc xử lý trên các bit thông tin.

### Xử lý bit cách đơn giản

D có các hàm cơ bản để xử lý bit:

- `&` phép `và` (and)
- `|` phép `hoặc` (or)
- `~` phép phủ định (negative)
- `<<`  phép dịch trái có dấu
- `>>`  phép dịch phải có dấu (giữ nguyên dấu của bit cao)
- `>>>` phép dịch phải không dấu

###  Ví dụ thực tế

Ví dụ phổ biến là đọc giá trị của một bit. Dù D có thư viện `core.bitop.bt`
cho hầu hết các nhu cầu, nhưng ta hãy tự bắt đầu theo cách riêng để làm
quên với việc xử lý theo bit

```d
enum posA = 1;
enum maskA = (1 << posA);
bool getFieldA()
{
    return _data & maskA;
}
```

Tổng quát hơn, ta có thể kiểm tra một khối gồm nhiều hơn một bit.
Ta sẽ cần biết chiều dài của khối, và đầu vào sẽ dịch chuyển tương ứng
trước khi gài mặt nạ bit:

```d
enum posA = 1;
enum lenA = 3;
enum maskA = (1 << lenA) - 1; // ...0111
uint getFieldA()
{
    return (_data >> posA) & maskA;
}
```

Cài giá trị cho một khối có thể hiểu là dùng mặt nạ phủ định và chỉ cho phép
thay đổi giá trị trong khối chỉ định:

```d
void setFieldA(bool b);
{
    return (_data & ~maskAWrite) | ((b << aPos) & maskAWrite);
}
```

## `std.bitmanip` có hết mọi thứ

Thư viện của D cung cấp mọi thứ để bạn xử lý các bit một cách hứng thú.
Nhưng trong hầu hết trường hợp, bạn không muốn chép và dán những phép
xử lý như trong ví dụ ở trên, vì cách đó dễ dẫn tới sai sót.
Hãy sử dụng thư viện `std.bitmapip` để viết các phép xử lý bit theo cách
đơn giản, dễ bảo trì, mà còn có thể dùng với mixin và không giảm đi hiệu năng
chương trình.

Hãy xem ví dụ ở phần sau. Một `BitVector` được định nghĩa, nhưng nó chỉ sử
dụng một số X bit, và hầu như không thể phân biệt với các cấu trúc thường.

Thư viện `std.bitmanip` và `core.bitop` gồm nhiều hàm tiện ích cho các
ứng dụng được viết với chủ đích giảm tối thiểu việc dùng bộ nhớ.

### Padding và alignment

Vì trình biên dịch thêm vào các biến một số bit để khớp với kiến trúc bộ
nhớ trên hệ thống (`size_t.sizeof`), ví dụ các biến kiểu `bool`, `byte`, `char`,
bạn được khuyên bắt đầu với các trường ở ngăn xếp cao (fields of high alignments.)

## Nâng cao

- [std.bitmanip](http://dlang.org/phobos/std_bitmanip.html) - Bit-level manipulation facilities
- [_Bit Packing like a Madman_](http://dconf.org/2016/talks/sechet.html)

## {SourceCode}

```d
struct BitVector
{
    import std.bitmanip : bitfields;
    // creates a private field with the
    // following proxies
    mixin(bitfields!(
        uint, "x",    2,
        int,  "y",    3,
        uint, "z",    2,
        bool, "flag", 1));
}

void main()
{
    import std.stdio : writefln, writeln;

    BitVector vec;
    vec.x = 2;
    vec.z = vec.x - 1;
    writefln("x: %d, y: %d, z: %d",
              vec.x, vec.y, vec.z);

    // only 8 bit - 1 byte are used
    writeln(BitVector.sizeof);

    struct Vector { int x, y, z; }
    // 4 bytes (int) per variable
    writeln(Vector.sizeof);

    struct BadVector
    {
        bool a;
        int x, y, z;
        bool b;
    }
    // due to padding,
    // 4 bytes are used for each field
    writeln(BadVector.sizeof);
}
```
