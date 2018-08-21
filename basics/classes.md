# Lớp

D cũng có lớp và giao diện như trong Java hay C++.

Lớp bất kỳ thừa kế từ  lớp [`Object`](https://dlang.org/phobos/object.html),
hay nói cách khác `Object` là mẹ của tất cả các lớp khác trong D.

    class Foo { } // thừa kế từ Object
    class Bar : Foo { } // Bar cũng là Foo

Lớp được khởi tạo trên bộ nhớ `heap` nhờ `new`:

    auto bar = new Bar;

Đối tượng trong lớp luôn là kiểu tham chiếu, nên không có chuyện
sao chép giá trị như kiểu ghép `struct`.

    Bar bar = foo; // bar là con trỏ tới foo

Bộ dọn rác giải phóng bộ nhớ khi không còn tham chiếu nào trỏ tới
đối tượng của lớp.

### Thừa kế

Chỉ thị `override` dùng khi cần định nghĩa lại hàm từ lớp mẹ.
Việc ép buộc dùng từ khóa là để hạn chế các lỗi do vô ý.

    class Bar : Foo {
        override functionFromFoo() {}
    }

Trong D một lớp chỉ thừa kế từ đúng một lớp khác.

### Hàm trừu tượng và hàm hoàn chỉnh

- Khi một hàm được đánh dấu `final`, nó được xem là hoàn chỉnh
  và các lớp thừa kế không thể định nghĩa lại hàm đó.
- Hàm trừu tượng được đánh dấu bởi `abstract`, là các hàm
  bắt buộc phải được định nghĩa lại trong các lớp thừa kế.
- Một lớp trừu tượng được đánh dấu với `abstract`, là lớp
  không được khởi tạo trên bộ nhớ.
- `super(..)` dùng để gọi đến hàm khởi tạo của lớp mẹ.

### Phép so sánh

Phép so sánh `==` và `!=` dùng cho nội dung đối tượng của lớp.
Vì `null` không có nội dung nào, việc dùng hai phép so sánh này với `null`
là không hợp lệ; bạn cần dùng `is` như ví dụ sau:

```d
MyClass c;
if (c == null)  // lỗi
    ...
if (c is null)  // tốt
    ...
```

Với lớp ghép (`struct`) việc so sánh đối tượng diễn ra ở từng bit thông tin.

### Đọc thêm

- [Lớp trong sách _Programming in D_](http://ddili.org/ders/d.en/class.html)
- [Thừa kế trong sách _Programming in D_](http://ddili.org/ders/d.en/inheritance.html)
- [Đối tượng lớp trong sách _Programming in D_](http://ddili.org/ders/d.en/object.html)
- [Đặc tả về lớp](https://dlang.org/spec/class.html)

## {SourceCode}

```d
import std.stdio : writeln;

/*
Lớp này có thể dùng cho mọi việc...
*/
class Any {
    // protected có thể thấy từ lớp con
    protected string type;

    this(string type) {
        this.type = type;
    }

    // public là mặc định, nên không cần chỉ ra.
    // Ngăn việc định nghĩa lại trong lớp con
    final string getType() {
        return type;
    }

    // This needs to be implemented!
    // trừu tượng quá, nên hàm này buộc
    // phải định nghĩa lại  trong lớp con
    abstract string convertToString();
}

class Integer : Any {
    // just seen by Integer
    private {
        int number;
    }

    // khởi tạo
    this(int number) {
        // gọi hàm khởi tạo ở lớp mẹ
        super("integer");
        this.number = number;
    }

    // public là thuộc tính mặc định
    public:

    override string convertToString() {
        import std.conv : to;
        // đổi tất cả qua chuỗi
        return to!string(number);
    }
}

class Float : Any {
    private float number;

    this(float number) {
        super("float");
        this.number = number;
    }

    override string convertToString() {
        import std.string : format;
        // điều chỉnh sai số
        return format("%.1f", number);
    }
}

void main()
{
    Any[] anys = [
        new Integer(10),
        new Float(3.1415f)
    ];

    foreach (any; anys) {
        writeln("any's type = ", any.getType());
        writeln("Content = ",
            any.convertToString());
    }
}
```
