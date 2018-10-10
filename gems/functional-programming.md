# Lập trình hàm

D rất chú ý tới lập trình hàm (`functional programming`),
và xem các hàm như các biến thông thường (`first-class function`).

Một hàm trong D khi được khai báo với chỉ thị `pure` sẽ loại trừ các hiệu
ứng ngoài lề (`side effect`), nghĩa là đầu ra của hàm luôn luôn giống nhau
khi giá trị đầu vào của hàm không đổi. Các hàm `pure` không thể sử dụng
hay thay đổi các trạng thái toàn cục khả biến (`mutable`), và do đó
bên trong định nghĩa của một hàm `pure` bạn chỉ có thể gọi tới các hàm
`pure` khác.


    int add(int lhs, int rhs) pure {
        impureFunction(); // LỖI: không thể gọi tới hàm không pure
        return lhs + rhs;
    }

Phiên bản `add` này thực sự được gọi là phiên bản mạnh, bởi nó không
thay đổi đầu vào. Phiên bản yếu hơn cho phép đầu vào là các tham chiếu
(con trỏ):

    void add(ref int result, int lhs, int rhs) pure {
        result = lhs + rhs;
    }

Phiên bản sau này vẫn được xem là `pure` và nó cũng không thể sử dụng hay
thay đổi bất kỳ trạng thái toàn cục khả biến nào; tuy nhiên, đầu vào của
hàm có thể thay đổi do chúng là các con tham chiếu.

Do không phát sinh hiệu ứng bên lề mà các hàm `pure` rất lý tưởng khi
dùng trong lập trình đa luồng (`multi-thread`), bởi nó giúp hạn chế tình trạng
phá hủy dữ liệu (`data race`). Hơn nữa, kết quả đầu ra của hàm `pure` có
thể lưu đệm và nhờ đó mở rộng khả năng tinh chỉnh quá trình biên dịch.


Thuộc tính `pure` được nội suy tự động bởi trình biên dịch cho các hàm mẫu
và hàm được chỉ thị `auto`, nếu có thể. (Điều này cũng đúng với các chỉ thị
khác như `@safe`, `nothrow`, `@nogc`.)

### Nâng cao

- [Khu vườn lập trình hàm](https://garden.dlang.io/)

## {SourceCode}

```d
import std.bigint : BigInt;

/**
 * Tính lũy thừa
 *
 * Trả về:
 *     Số nguyên là lũy thừa theo cơ số base
 */
BigInt bigPow(uint base, uint power) pure
{
    BigInt result = 1;

    foreach (_; 0 .. power)
        result *= base;

    return result;
}

void main()
{
    import std.datetime.stopwatch : benchmark;
    import std.functional : memoize,
        reverseArgs;
    import std.stdio : writefln, writeln;

    // `memoize` dùng để lưu đệm kết quả của
    // hàm `pure` trên bộ nhớ.
    alias fastBigPow = memoize!(bigPow);

    void test()
    {
        writefln(".uintLength() = %s ",
               fastBigPow(5, 10000).uintLength);
    }

    foreach (_; 0 .. 10)
        ( benchmark!test(1)[0]
            .total!"usecs"/1000.0 )
            .reverseArgs!writefln
              (" thời gian: %.2f miliseconds");
}
```
