# Dữ liệu ghép

_(hay kiểu Struct)_

Như trong `C` bạn có thể dùng `struct` để tạo ra kiểu dữ liệu mới
_ghép_ các kiểu dữ liệu cơ bản cùng nhau

    struct Person {
        int age;
        int height;
        float ageXHeight;
    }

Biến `struct` được khởi tạo trong vùng nhớ `stack` (trừ khi biến được
khai báo với `new`), và trong các phép gán hay truyền tham số cho hàm,
giá trị _(không phải tham chiếu con trỏ)_ của biến được sử dụng.
Thuật ngữ tiếng Anh là *copy-by-value*.

    auto p = Person(30, 180, 3.1415);
    auto t = p; // chép theo giá trị

Khi đối tượng kiểu ghép được tạo, mỗi thành phần được tạo theo thứ tự
đã chỉ ra khi định nghĩa kiểu ghép đó. Việc khởi tạo các thành phần này
cũng có thể được thực hiện bên trong hàm `this(...)`, nơi các thành phần
được gọi theo tên `BIẾN` hay theo kiểu tường minh `this.BIẾN`.

    struct Person {
        this(int age, int height) {
            this.age = age;
            this.height = height;
            this.ageXHeight = cast(float)age * height;
        }
            ...

    Person p = Person(30, 180); // khởi tạo
    p = Person(30, 180);  // gán cho nhân bản mới

Kiểu ghép cũng cho phép ghép các hàm. Hàm thành phần mặc định có thuộc
tính công cộng (`public`) nên có thể sử dụng trực tiếp từ bên ngoài
định nghĩa của kiểu ghép. Ngược lại, bạn cần dùng từ khóa `private`
để áp đặt sự riêng tư của hàm thành phần.

    struct Person {
        void doStuff() {
            ...
        private void privateStuff() {
            ...

    p.doStuff(); // thoải mái
    p.privateStuff(); // bị cấm

### Thành phần hàm hằng

Hàm thành phần trong kiểu ghép có thể được khai báo với từ khóa `const`
(hằng). Các hàm này không thể thay đổi các biến thành phần của kiểu ghép.
Hàm hằng có thể  gọi với đầu vào là đối tượng hằng hay bất biến khác,
nhưng chắc chắn hàm đó không thể thay đổi trạng thái của đối tượng.

### Thành phần hàm tĩnh

Khi hàm thành phần được khai báo với `static`, nó có thể được gọi thông
qua tên của kiểu ghép mà không cần thông qua đối tượng cụ thể của kiểu,
ví dụ `Person.myStatic()`.
Rõ ràng, hàm tĩnh không thể truy cập các biến không được khai báo tĩnh.
Có nhiều ứng dụng sử dụng hàm tĩnh, ví dụ khi triển khai các kiểu `Singleton`.

### Thừa kế

Không thể nói tới thừa kế với các kiểu ghép.
Thừa kế chỉ áp dụng đối với các lớp (`class`) mà ta đề cập sau.
Tuy nhiên, việc dùng `alias this` hoặc `mixins` có thể giúp
đạt được mức thừa kế đa hình.

### Đọc thêm

- [Kiểu ghép trong sách _Programming in D_](http://ddili.org/ders/d.en/struct.html)
- [Đặc tả kiểu ghép](https://dlang.org/spec/struct.html)

### Bài tập

Với kiểu ghép `struct Vector3`, hãy viết các hàm sau và đảm bảo ví dụ
chạy thành công:

* `length()` - trả về chiều dài vector
* `dot(Vector3)` - trả về tích chấm của hai vector
* `toString()` - biểu diễn vector ở dạng chuỗi
  Hàm [`std.string.format`](https://dlang.org/phobos/std_format.html)
  trả về chuỗi nhờ cú pháp tương tự  hàm `printf`:
  `format("MyInt = %d", myInt)`.
  Chuỗi sẽ được mô tả chi tiết trong các phần sau.

## {SourceCode:incomplete}

```d
struct Vector3 {
    double x;
    double y;
    double z;

    double length() const {
        import std.math : sqrt;
        // TODO: trả về chiều dài Vector3
        return 0.0;
    }

    // rhs will be copied
    double dot(Vector3 rhs) const {
        // TODO: triển khai tích chấm
        return 0.0;
    }
}

void main() {
    auto vec1 = Vector3(10, 0, 0);
    Vector3 vec2;
    vec2.x = 0;
    vec2.y = 20;
    vec2.z = 0;

    // Bỏ qua () khi hàm không nhận
    // tham số đầu vào
    assert(vec1.length == 10);
    assert(vec2.length == 20);

    // Kiểm tra tính đúng đắn của tích chấm
    assert(vec1.dot(vec2) == 0);

    // 1 * 1 + 2 * 1 + 3 * 1
    auto vec3 = Vector3(1, 2, 3);
    assert(vec3.dot(Vector3(1, 1, 1)) == 6);

    // 1 * 3 + 2 * 2 + 3 * 1
    assert(vec3.dot(Vector3(3, 2, 1)) == 10);
}
```
