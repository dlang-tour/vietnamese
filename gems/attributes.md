# Thuộc tính của hàm

Các hàm trong D có thể mang thêm thuộc tính theo vài cách khác nhau,
kể cả các thuộc tính do người dùng định nghĩa. Ba thuộc tính mà D định
nghĩa sẵn là `@safe`, `@system` và `@trusted` đã được đề cập trong
các phần trước

### `@property`

Hàm đánh dấu bởi `@property` trông như một (biến) thành phần bình thường
khi được sử dụng ở ngoài kiểu lớp hay kiểu ghép:

    struct Foo {
        @property bar() { return 10; }
        @property bar(int x) { writeln(x); }
    }

    Foo foo;
    writeln(foo.bar); // cú pháp chuẩn là foo.bar()
    foo.bar = 10; // phép gọi hàm thực sự là foo.bar(10);

### `@nogc`

Các hàm đánh dấu với `@nogc` để đảm bảo rằng không xảy ray bất kỳ phép
cấp phát bộ nhớ nào xảy ra bên trong thân hàm. Một hàm `@nogc` vì thế
chỉ có thể gọi tới các hàm `@nogc` khác.

    void foo() @nogc {
      // Lỗi ngay, vì `new` yêu cầu
      // cấp phát vùng nhớ mới
        auto a = new A;
    }

### Người dùng tự định nghĩa thuộc tính (UDA)

Trong D lập trình viên có thể tự định nghĩa các thuộc tính mới cho hàm.
Các thuộc tính này tên chung tiếng Anh là `User-defined attribute` (UDA).

Ví dụ, hàm `foo` sau đây:

    struct Bar { this(int x) {} }

    struct Foo {
      @("Hello") {
          @Bar(10) void foo() {
            ...
          }
      }
    }

Ở ví dụ này, hàm `foo()` được đánh dấu bởi thuộc tính `"Hello"` (kiểu `string`)
và thuộc tính `Bar` (kiểu `Bar` với giá trị `10`).

Để lấy các thuộc tính của hàm, có thể dùng *traits`, ví dụ
`__traits(getAttributes, Foo)`, kết quả trả về là dãy các alias
[`AliasSeq`](https://dlang.org/phobos/std_meta.html#AliasSeq).

UDAs allow to enhance generic code by giving user-defined
types another dimension that helps compile time
generators to adapt to that specific type.

Việc dùng `UDA` mang lại thêm khả năng tinh chỉnh trình biên dịch khi
làm việc với các kiểu do người dùng định nghĩa.

### Nâng cao

- [UDA trong sách _Programming in D_](http://ddili.org/ders/d.en/uda.html)
- [Đặc tả thuộc tính hàm trong D](https://dlang.org/spec/attribute.html)
