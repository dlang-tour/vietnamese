# Hàm

Bạn đã thấy đâu đó hàm `main()`, là hàm bắt đầu của mọi ứng dụng D.
Hàm có thể trả về giá trị, hoặc không trả về giá trị nào (`void`),
còn đầu vào của hàm có thể có tùy ý tham số.

    int add(int lhs, int rhs) {
        return lhs + rhs;
    }

### `auto` tự xác định kiểu trả về

Kiểu trả về của hàm có thể được D nội suy từ biểu thức định nghĩa hàm.
Các biểu thức `return` khác nhau trong hàm phải trả về những kiểu giá trị
tương thích nhau.

    auto add(int lhs, int rhs) { // trả về kiểu `int`
        return lhs + rhs;
    }

    auto lessOrEqual(int lhs, int rhs) { // trả về kiểu `double`
        if (lhs <= rhs)
            return 0;
        else
            return 1.0;
    }

### Giá trị đầu vào mặc định

Tham số đầu vào của hàm có thể nhận giá trị mặc định,
nhờ cách này lập trình viên đỡ mất công định nghĩa chồng hàm.

    void plot(string msg, string color = "đỏ") {
        ...
    }
    plot("D tuyệt");
    plot("D tuyệt", "xanh");

Khi một tham số được chỉ ra giá trị mặc định, tất cả tham số theo sau nó
cũng phải được chỉ ra giá trị mặc định.

### Hàm cục bộ

Bạn có thể định nghĩa hàm bên trong hàm khác, chỉ để sử dụng bên trong ngữ
cảnh của hàm này, còn bên ngoài thì không thể truy cập được.
Tất nhiên, từ hàm bên trong có thể nhìn thấy các biến, đối tượng bên ngoài nó.

    void fun() {
        int local = 10;
        int fun_secret() {
            local++; // local ở ngoài nhé
        }
        ...


Hàm lồng nhau này được gọi là *ủy nhiệm* (delegate),
và sẽ được mô tả chi tiết hơn [ở đây](basics/delegates).

### Đọc thêm

- [Hàm trong sách _Programming in D_](http://ddili.org/ders/d.en/functions.html)
- [Tham số của hàm trong sách _Programming in D_](http://ddili.org/ders/d.en/function_parameters.html)
- [Đặc tả hàm](https://dlang.org/spec/function.html)

## {SourceCode}

```d
import std.stdio : writeln;
import std.random : uniform;

void randomCalculator()
{
    // Bốn hàm ứng với bốn phép toán
    auto add(int lhs, int rhs) {
        return lhs + rhs;
    }
    auto sub(int lhs, int rhs) {
        return lhs - rhs;
    }
    auto mul(int lhs, int rhs) {
        return lhs * rhs;
    }
    auto div(int lhs, int rhs) {
        return lhs / rhs;
    }

    int a = 10;
    int b = 5;

    // uniform chọn ra số ngẫu nhiên
    // trong khoảng (0, 4), nhưng trừ số 4
    // Ứng với kết quả là một phép toán.
    switch (uniform(0, 4)) {
        case 0:
            writeln(add(a, b));
            break;
        case 1:
            writeln(sub(a, b));
            break;
        case 2:
            writeln(mul(a, b));
            break;
        case 3:
            writeln(div(a, b));
            break;
        default:
            // Đặc biệt... có gì sai?
            assert(0);
    }
}

void main()
{
    randomCalculator();
    // Không thể truy cập add, sub, mul, div
    // từ bên ngoài randomCalculator()
    static assert(!__traits(compiles,
                            add(1, 2)));
}

```
