# Dải

**ND:** Trong phần này, `range` được dịch là `dải`, thay vì `dãy`.
Trong Dlang, `dãy` hay `mảng` chỉ là trường hợp đặc biệt của `dải`.
Khi dùng `dải`, ta quan tâm tính tính toàn vẹn của đối tượng hơn
là các thành phần riêng lẽ.

Trình biên dịch Dlang chuyển mã nguồn `foreach`

```
foreach (element; range)
{
    // Loop body...
}
```

sang dạng như sau

```
for (auto __rangeCopy = range;
     !__rangeCopy.empty;
     __rangeCopy.popFront())
 {
    auto element = __rangeCopy.front;
    // thân vòng lặp...
}
```

Tổng quát hơn, đối tượng `dải` (hay `dải đầu vào` `InputRange`)
có cấu trúc tương tự như sau đều có thể dùng với phép `lặp`:

```
    interface InputRange(E)
    {
        bool empty();
        E front();
        void popFront();
    }
```

Khó hiểu? Hãy xem thêm vài ví dụ trong mã nguồn đi kèm phần này.

## Gọi theo nhu cầu

Phần tử của dải được tính toán chỉ khi việc đó thật sự cần.
Tính chất này gọi là `lazy` (lười), hay `call-by-need` (gọi theo nhu cầu),
gặp nhiều trong các ngôn ngữ lập trình hàm.

```d
42.repeat.take(3).writeln; // [42, 42, 42]
```

## Tham chiếu con trỏ hoặc giá trị

Nếu dải gồm các giá trị, việc sử dụng dải sẽ được thực hiện trên bản sao
của các giá trị đó:

```d
auto r = 5.iota;
r.drop(5).writeln; // []
r.writeln; // [0, 1, 2, 3, 4]
```

Nếu dải gồm các tham chiếu, ví dụ là các `lớp`
hoặc [dải tham chiếu](https://dlang.org/phobos/std_range.html#refRange),
thì việc sử dụng dải có thể ảnh hưởng, thay đổi giá trị các phần tử trong dải:

```d
auto r = 5.iota;
auto r2 = refRange(&r);
r2.drop(5).writeln; // []
r2.writeln; // []
```

### Dải chuyển tiếp `ForwardRanges`

Hầu hết các dải trong thư viện Dlang tiêu chuẩn là kiểu ghép (`struct`)
và việc dùng `foreach` sẽ không thay đổi hay hủy hoại dải, nhưng điều này
không được đảm bảo. Nếu cần chắc chắn dải đầu vào (`InputRange`) không
bị suy chuyển, bạn có thể dùng dải chuyển tiếp với hàm `.save`:

```
interface ForwardRange(E) : InputRange!E
{
    typeof(this) save();
}
```

```d
// theo giá trị (Structs)
auto r = 5.iota;
auto r2 = refRange(&r);
r2.save.drop(5).writeln; // []
r2.writeln; // [0, 1, 2, 3, 4]
```

### Dải chuyển tiếp với truy cập hai chiều hoặc ngẫu nhiên

Có thể mở rộng dải chuyển tiếp để truy cập hai chiều, hoặc truy cập ngẫu nhiên:

Với truy cập hai chiều, có thể duyệt _(tuần tự)_ các phần từ của dải từ cuối;

```d
interface BidirectionalRange(E) : ForwardRange!E
{
     E back();
     void popBack();
}
```

```d
5.iota.retro.writeln; // [4, 3, 2, 1, 0]
```

Với truy cập ngẫu nhiên, dải cần có chiều dài `length` xác định

```d
interface RandomAccessRange(E) : ForwardRange!E
{
     E opIndex(size_t i);
     size_t length();
}
```

Ví dụ tốt nhất cho dải truy cập ngẫu nhiên là các dãy trong Dlang:

```d
auto r = [4, 5, 6];
r[1].writeln; // 5
```

### Thuật toán gọi-theo-nhu-cầu

Thư viện [`std.range`](http://dlang.org/phobos/std_range.html) và
[`std.algorithm`](http://dlang.org/phobos/std_algorithm.html) đưa ra
cấu trúc vận dụng thuật toán gọi-theo-nhu-cầu. Thêm nữa, dải cho phép
tạo ra các đối tượng **lười** với giá trị của chúng được tính toán
chỉ khi nào thật sự cần đến trong phép lặp.
Các thuật toán liên quan tới dải được mô tả nhiều hơn trong phần
[Viên ngọc của D](gems/range-algorithms).

### Đọc thêm

- [`std.algorithm`](http://dlang.org/phobos/std_algorithm.html)
- [`std.range`](http://dlang.org/phobos/std_range.html)

## {SourceCode}

```d
import std.stdio : writeln;

struct FibonacciRange
{
    // Khởi đầu của dải Fibonacci
    int a = 1, b = 1;

    // Dải Fibonacci không bao giờ kết thúc
    enum empty = false;

    // Trả về phần tử đầu tiên
    int front() const @property
    {
        return a;
    }

    // Bỏ đi phần tử đầu tiên
    void popFront()
    {
        auto t = a;
        a = b;
        b = t + b;
    }
}

void main()
{
    FibonacciRange fib;

    import std.range : drop, generate, take;
    import std.algorithm.iteration :
        filter, sum;

    // Lấy 10 phần tử đầu tiên của dải Fibonacci
    auto fib10 = fib.take(10);
    writeln("Fib 10: ", fib10);

    // rồi bỏ đi phần tử thứ 5
    auto fib5 = fib10.drop(5);
    writeln("Fib 5: ", fib5);

    // chọn các phần tử chẵn
    auto fibEven = fib5.filter!(x => x % 2);
    writeln("FibEven : ", fibEven);

    // Tính tổng các phần tử đã chọn
    writeln("Tổng của FibEven: ", fibEven.sum);

    // Phiên bản ngắn gọn:
    fib.take(10)
         .drop(5)
         .filter!(x => x % 2)
         .sum
         .writeln;
}
```
