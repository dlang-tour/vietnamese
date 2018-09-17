# Ủy nhiệm hàm

### Hàm như tham số

Một hàm có thể làm tham số cho hàm khác:

    void doSomething(int function(int, int) doer) {
        // gọi hàm cho bởi tham số
        doer(5,5);
    }

    doSomething(&add); // dùng phép cộng `add`

Tham số `doer` có thể được gọi giống như bất kỳ hàm nào khác.

### Hàm địa phương với ngữ cảnh

Ví dụ trên dùng kiểu `function` là kiểu con trỏ, trỏ đến hàm toàn cục.
Khi một hàm thành phần (của một lớp), hoặc hàm địa phương được tham khảo,
ủy nhiệm hàm (`delegate`) sẽ được dùng đến. Ủy nhiệm hàm cũng là con trỏ
hàm, nhưng có thêm thông tin về ngữ cảnh được gọi (*enclosure*, hay còn
gọi là **closure** trong nhiều ngôn ngữ khác).
Ví dụ, ủy hiệm hàm thành phần của một lớp (class) chứa thêm con trỏ đến
đối tượng của lớp. Tuy nhiên, ủy nhiệm hàm tạo bởi hàm lồng nhau chỉ chứa
liên kết đến các ngữ cảnh bao bên ngoài, và trình biên dịch D có thể
tự động sao chép ngữ cảnh trên vùng `heap` khi cần thiết,
sau đó một ủy nhiệm hàm sẽ liên kết tới vùng `heap` đó.

    void foo() {
        void local() {
            writeln("local");
        }
        auto f = &local; // f là ủy nhiệm hàm
    }

Quay lại ví dụ đầu tiên, hàm `doSomething` có thể nhận tham số là ủy nhiệm hàm
như sau :

    void doSomething(int delegate(int,int) doer);

Ủy nhiệm hàm (`delegate`) không thể lẫn lộn với hàm (`function`).
Tuy nhiên, nhờ hàm tiêu chuẩn
[`std.functional.toDelegate`](https://dlang.org/phobos/std_functional.html#.toDelegate)
bạn có thể chuyển một hàm `function` thành một ủy nhiệm `delegate`.

### Hàm không tên và Lambda

Bởi hàm có thể dùng như biến để truyền tham số cho hàm khác, nên nhiều lúc
không cần thiết đặt tên cho hàm đó (như kiểu định nghĩa hàm thông thường).
D cho phép bạn định nghĩa các hàm không tên, và các hàm một dòng _lambda_:

    auto f = (int lhs, int rhs) {
        return lhs + rhs;
    };
    auto f = (int lhs, int rhs) => lhs + rhs; // Lambda

Trong D có thể dùng chuỗi như là mẫu tham số hàm truyền cho các hàm
trong thư viện tiêu chuẩn. Ví dụ, phép gộp `reducer` (hay `folding`)
có thể viết ngắn gọn như sau:

    [1, 2, 3].reduce!`a + b`; // 6

Tuy nhiên, cách tương tự chỉ áp dụng cho hàm có một hoặc hai tham số,
trong đó luôn luôn `a` chỉ tham số thứ nhất còn `b` chỉ tham số thứ hai.

### Nâng cao

- [Đặc tả của ủy nhiệm hàm](https://dlang.org/spec/function.html#closures)

## {SourceCode}

```d
import std.stdio : writeln;

enum IntOps {
    add = 0,
    sub = 1,
    mul = 2,
    div = 3
}

/**
Các phép tính toán học
Tham số:
    op = toán tử
Trả về: Ủy nhiệm hàm ứng với toán tử
*/
auto getMathOperation(IntOps op)
{
    // Bốn lambda ứng với bốn phép toán
    auto add = (int lhs, int rhs) => lhs + rhs;
    auto sub = (int lhs, int rhs) => lhs - rhs;
    auto mul = (int lhs, int rhs) => lhs * rhs;
    auto div = (int lhs, int rhs) => lhs / rhs;

    // Dùng switch để lựa chọn lambda
    // tùy vào tham số đầu vào op
    final switch (op) {
        case IntOps.add:
            return add;
        case IntOps.sub:
            return sub;
        case IntOps.mul:
            return mul;
        case IntOps.div:
            return div;
    }
}

void main()
{
    int a = 10;
    int b = 5;

    auto func = getMathOperation(IntOps.add);
    writeln("Kiểu của hàm ",
        typeof(func).stringof, "!");

    // Dùng ủy nhiệm hàm để thực hiện phép toán
    writeln("Kết quả: ", func(a, b));
}
```
