# Lập trình hợp đồng

Lập trình hợp đồng (`Contract programming`) là việc dùng một số cú pháp
để tăng chất lượng mã nguồn, đảm bảo mã tuân theo các _hợp đồng_ đã ước định.
Các hợp đồng được kiểm tra khi chương trình chạy ở chế độ kiểm thử hoặc dò lỗi,
nhưng chúng bị bỏ qua hoàn toàn trong chế độ biên dịch ra sản phẩm cuối (**-release**).
Vì vậy, các hợp đồng không nên được dùng để kiểm soát dữ liệu đầu vào
hoặc kiểm soát lỗi ngoại lệ

### Chặn `assert`

Phiên bản đơn giản nhất của lập trình hợp đồng là dùng các chặn
`assert(...)` để ước định một số điều kiện được thỏa mãn, hoặc thoát và
dừng chương trình với mã `AssertionError` trong các trường hợp khác.

    assert(sqrt(4) == 2);
    // có thể thêm thông báo lỗi vào cho dễ dò
    assert(sqrt(16) == 4, "không tính đúng căn bậc hai");

### Hợp đồng hàm

`in` và `out` để kiểm soát đầu vào và đầu ra của hàm bất kỳ:

    long square_root(long x)
    in {
        assert(x >= 0);
    } out (result) {
        assert((result * result) <= x
            && (result+1) * (result+1) > x);
    } do {
        return cast(long)std.math.sqrt(cast(real)x);
    }

Khối mã `in` cũng có thể đặt bên trong thân hàm, nhưng ý nghĩa của nó
sẽ rõ ràng khi đặt bên ngoài như trong ví dụ trên. Trong khi đó, khối
mã `out` có thể sử dụng giá trị trả về của hàm bằng cách chỉ ra biến, ví dụ
`out(result)`.

### Kiểm tra bất biến

`invariant()` là hàm đặc biệt của các kiểu `struct` và `class`, được dùng
để kiểm tra trạng thái đối tượng của kiểu trong suốt quá trình tồn tại
của đối tượng

* Hàm `invariant()` được gọi sau khi đối tượng được khởi tạo,
  và trước khi đối tượng bị hủy;
* Hàm đó cũng được gọi trước các hàm thành phần của đối tượng được gọi,
  và nó cũng được gọi sau khi hàm đó kết thúc.

### Kiểm tra đầu vào từ người dùng

Mọi hợp đồng được bỏ qua khi chương trình biên dịch với cờ `release`.
Vì thế, đầu vào từ người dùng không được kiểm tra bằng các hợp đồng.
Hơn nữa, chặn `assert` vẫn có thể được dùng trong các hàm `nothrow`
bởi chúng sẽ quăng lỗi `Error`.
Lúc chạy chương trình, thay vì dùng `assert` bạn có thể dùng
[`std.exception.enforce`](https://dlang.org/phobos/std_exception.html#.enforce),
để quăng ra các lỗi ngoại lệ (`Exception`) có thể bắt được.

### Nâng cao

- [`assert` và `enforce` trong sách _Programming in D_](http://ddili.org/ders/d.en/assert.html)
- [Lập trình hợp đồng trong sách _Programming in D_](http://ddili.org/ders/d.en/contracts.html)
- [Lập trình hợp đồng với kiểu ghép hay lớp, trong sách _Programming in D_](http://ddili.org/ders/d.en/invariant.html)
- [Đặc tả của lập trình hợp đồng](https://dlang.org/spec/contracts.html)
- [`std.exception`](https://dlang.org/phobos/std_exception.html)

## {SourceCode:incomplete}

```d
import std.stdio : writeln;

/**
Kiểu ngày tháng đơn giản.
Trong thực tế, hãy dùng std.datetime.
*/
struct Date {
    private {
        int year;
        int month;
        int day;
    }

    this(int year, int month, int day) {
        this.year = year;
        this.month = month;
        this.day = day;
    }

    invariant() {
        assert(year >= 1900);
        assert(month >= 1 && month <= 12);
        assert(day >= 1 && day <= 31);
    }

    /**
    Biến đổi chuỗi YYYY-MM-DD thành đối tượng
    của kiểu Date

    Đầu vào :
        date = chuỗi cần biến đổi

    Trả về: Đối tượng thuộc kiểu Date
    */
    void fromString(string date)
    in {
        assert(date.length == 10);
    }
    body {
        import std.format : formattedRead;
        // formattedRead đọc các biến
        // từ chuỗi đầu vào, theo định dạng và
        // thứ tự được chỉ ra
        // trong tham số thứ 2.
        formattedRead(date, "%d-%d-%d",
            &this.year,
            &this.month,
            &this.day);
    }

    /**
    Chuyển đối tượng kiểu Date
    thành chuỗi YYYY-MM-DD

    Trả về: Chuỗi hiển thị ngày tháng
    */
    string toString() const
    out (result) {
        import std.algorithm : all, count,
                              equal, map;
        import std.string : isNumeric;
        import std.array : split;

        // Chắc rằng kết quả trả về
        // có đúng định dạng YYYY-MM-DD
        assert(result.count("-") == 2);
        auto parts = result.split("-");
        assert(parts.map!`a.length`
                    .equal([4, 2, 2]));
        assert(parts.all!isNumeric);
    }
    body {
        import std.format : format;
        return format("%.4d-%.2d-%.2d",
                      year, month, day);
    }
}

void main() {
    auto date = Date(2016, 2, 7);

    // Phép kiểm tra bất biến sẽ
    // không thành công. Tuy nhiên,
    // không nên dùng hợp đồng để lọc đầu vào,
    // mà hãy dùng throw để quăng lỗi
    date.fromString("2016-13-7");

    date.writeln;
}
```
