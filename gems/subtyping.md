# Định kiểu thế (subtyping)

Kiểu ghép `struct` không thể thừa kế từ kiểu ghép khác.
Nhưng với các kiểu ghép, D có một cách khác để mở rộng khả năng của nó
bằng cách định kiểu (thay) thế (`subtyping`).

Bên trong kiểu ghép bạn có thể định nghĩa một trong các thành phần của
nó bằng `alias this`:

    struct SafeInt {
        private int theInt;
        alias theInt this;
    }

Sau đó, bất kỳ hàm hay toán tử nào trên đối tượng kiểu `SafeInt`
mà không được định nghĩa bởi kiểu ghép `SafeInt` thì sẽ được _chuyển tiếp_
qua thành phần `alias this`, mà trong ví dụ trên, là chuyển qua đối tượng
kiểu `theInt`. Theo đó, các truy cập từ bên ngoài tới đối tượng `SafeInt`
vẫn như với số nguyên bình thường.

Cách định kiểu thế  cho phép mở rộng kiểu ghép mà không phải hao tốn thêm
tài nguyên bộ nhớ lúc chạy chương trình. Trình biên dịch sẽ đảm bảo tính
đúng đắn khi truy cập thành phần `alias this`.

`alias this` cũng có thể dùng với lớp (`class`).

## {SourceCode}

```d
import std.stdio : writeln;

struct Point
{
    private double[2] p;
    // p dùng bởi trình biên dịch để
    // chuyển tiếp các hàm nó chưa biết.
    alias p this;

    double dot(Point rhs)
    {
        return p[0] * rhs.p[0]
             + p[1] * rhs.p[1];
    }
}
void main()
{
    Point p1, p2;
    // Sử dụng double[2] như bình thường
    p1 = [2, 1], p2 = [1, 1];
    assert(p1[$ - 1] == 1);

    // và với tính năng mở rộng
    writeln("p1 dot p2 = ", p1.dot(p2));
}
```
