# Mẫu

**D** cho phép định nghĩa các hàm mẫu tương tự như trong C++ hay Java,
đó là các hàm **tổng quát** hay đối tượng của bất kỳ kiểu nào tương thích
với các biểu thức của hàm:

    auto add(T)(T lhs, T rhs) {
        return lhs + rhs;
    }

Tham số `T` được chỉ ra trong cặp dấu ngoặc trước phần tham số hàm,
và trình biên dịch sẽ thay thế nó bởi kiểu thực sự nhờ toán tử `!` như ví dụ sau:

    add!int(5, 10);
    add!float(5.0f, 10.0f);
    add!Animal(dog, cat); // Animal không có phép +
                          // nên trình biên dịch báo lỗi ở đây

### Nội suy tham số của mẫu

Các hàm mẫu chấp nhận hai kiểu tham số, một kiểu dùng cho lúc biên dịch,
và kiểu dùng dùng cho lúc chạy chương trình. (Với các hàm không phải là
hàm mẫu, chúng chỉ có các tham số lúc chạy `run-time`.)
Các tham số cho lúc biên dịch không được chỉ ra tường minh, trình biên dịch
sẽ cố nội suy ra kiểu từ các tham số `run-time`

    int a = 5; int b = 10;
    add(a, b); // Tương đương với add!int(a,b)
    float c = 5.0;
    add(a, c); // T bây giờ là `float`

### Các tính chất của mẫu

Một hàm có thể có nhiều tham số mẫu, ví dụ `func!(T1, T2 ..)`.
Những tham số này thuộc về một trong các kiểu cơ bản, bao gồm kiểu chuỗi
và số thực chấm động.

Không như trong Java, mẫu của D chỉ sử dụng vào lúc biên dịch, và nó sẽ
làm phát sinh các mã tối ưu cho các kiểu khác nhau lúc hàm thật sự được gọi.

Các kiểu `struct`, `class`, `interface` cũng có thể dùng với mẫu:

    struct S(T) {
        // ...
    }

### Đọc thêm

- [Tutorial to D Templates](https://github.com/PhilippeSigaud/D-templates-tutorial)
- [Templates in _Programming in D_](http://ddili.org/ders/d.en/templates.html)

#### Nâng cao

- [D Templates spec](https://dlang.org/spec/template.html)
- [Templates Revisited](http://dlang.org/templates-revisited.html):  Walter Bright writes about how D improves upon C++ templates.
- [Variadic templates](http://dlang.org/variadic-function-templates.html): Articles about the D idiom of implementing variadic functions with variadic templates

## {SourceCode}

```d
import std.stdio : writeln;

/**
Lớp mẫu với định nghĩa
đại khái của động vật.
Tham số:
    noise = tiếng kêu của con vật
*/
class Animal(string noise) {
    void makeNoise() {
        writeln(noise ~ "!");
    }
}

class Dog: Animal!("Woof") {
}

class Cat: Animal!("Meeoauw") {
}

/**
Hàm mẫu kiểu T sẽ định nghĩa lại hàm makeNoise.
Tham số:
    animal = con vật phát tiếng kêu
    n = số lần kêu
*/
void multipleNoise(T)(T animal, int n) {
    for (int i = 0; i < n; ++i) {
        animal.makeNoise();
    }
}

void main() {
    auto dog = new Dog;
    auto cat = new Cat;
    multipleNoise(dog, 5);
    multipleNoise(cat, 5);
}
```
