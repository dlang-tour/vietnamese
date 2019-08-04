# Thuật toán dải

Các mô-đun tiêu chuẩn [std.range](http://dlang.org/phobos/std_range.html)
và [std.algorithm](http://dlang.org/phobos/std_algorithm.html)
cung cấp nhiều hàm và phép hợp những hàm này cho phép diễn tả đơn giản
những phép tính toán phức tạp, với các _đơn vị_ là các dải (*range*).

Những thuật toán dải phát huy hiệu quả ngay cả với các (kiểu) dải do bạn
định nghĩa.

### std.algorithm

`filter` - Áp dụng phép lọc các phần tử của dải dựa vào
  hàm không tên (*lamda*) ở phần tham số mẫu:

    filter!"a > 20"(range);
    filter!(a => a > 20)(range);

`map` - Phát sinh dải mới nhờ vào hàm cung cấp ở phần tham số mẫu:

    [1, 2, 3].map!(x => to!string(x));

`each` - Một phiên bản khác của `foreach` áp dụng trên dải

    [1, 2, 3].each!(a => writeln(a));

### std.range

`take` - Tạo dải với *N* phần tử đầu tiên từ dải khác

    theBigBigRange.take(10);

`zip` - duyệt qua hai dải cùng lúc và tạo ra dải các cặp, mỗi cặp
  gồm phần từ thấy ở hai dải trong cùng phép duyệt

    assert(zip([1,2], ["hello","world"]).front
      == tuple(1, "hello"));

`generate` - phép *sinh* lấy một hàm, sinh ra một dải từ hàm đó, rồi
  dùng dải thu được làm đầu vào cho hàm trong bước tiếp theo:

    alias RandomRange = generate!(() => uniform(1, 1000));

`cycle` - dải vô tận có được bằng cách lặp đi lặp lại dải đầu vào

    auto c = cycle([1]);
    // không bao giờ rỗng
    assert(!c.empty);

### Xem thêm

Tài liệu về các thuật toán dải trong hai thư viện đã nêu.

### Nâng cao

- [Dải trong sách _Programming in D_](http://ddili.org/ders/d.en/ranges.html)
- [Nói nhiều hơn về dải trong sách _Programming in D_](http://ddili.org/ders/d.en/ranges_more.html)

## {SourceCode}

```d
// Lấy đủ món vũ khí ra thôi!
import std.algorithm : canFind, map,
  filter, sort, uniq, joiner, chunkBy, splitter;
import std.array : array, empty;
import std.range : zip;
import std.stdio : writeln;
import std.string : format;

void main()
{
    string text = q{Khúc dạo đầu về Dlang
giúp bạn có cái nhìn sơ lược về sức mạnh
và sự truyền cảm của ngôn ngữ D với khả năng
biên dịch mã nguồn thành mã máy hiệu quả.};

    // splitting predicate
    alias pred = c => canFind(" ,.\n", c);
    // thuật toán này tốt ở chỗ nó lười
    // không yêu cầu cấp thêm bộ nhớ
    auto words = text.splitter!pred
      .filter!(a => !a.empty);

    auto wordCharCounts = words
      .map!"a.count";

    // In ra số các ký tự của các từ,
    // bắt đầu với từ có số ký tự ít nhất
    zip(wordCharCounts, words)
      // đổi qua mảng để sắp xếp
      .array()
      .sort()
      // bỏ qua các từ trùng lặp
      .uniq()
      // đặt tất cả trên một hàng dựa vào
      // số ký tự trùng nhau. chunkBy giúp
      // sinh ra dải của dải dựa theo chiều dài
      .chunkBy!(a => a[0])
      // các thành phần được ghép lại một dòng
      .map!(chunk => format("%d -> %s",
          chunk[0],
          // chỉ các từ
          chunk[1]
            .map!(a => a[1])
            .joiner(", ")))
      // thực hiện ghép, theo kiểu lười biếng.
      // Ghép các dòng với dấu xuống hàng
      .joiner("\n")
      // in ra kết quả
      .writeln();
}
```
