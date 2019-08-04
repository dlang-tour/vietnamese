# Lập trình mẫu meta

Nếu bạn từng làm quen với *template meta programming*
(lập trình mẫu meta) trong C++ bạn sẽ thấy trong D mọi việc còn dễ dàng
hơn nữa. Lập trình mẫu meta là kỹ thuật cho phép đưa ra các quyết định
dựa vào kiểu của mẫu, nhờ đó làm cho các kiểu tổng quát uyển chuyển hơn.

### `static if` và `is`

Giống như `if`, nhưng `static if` được kiểm tra lúc biên dịch chương trình:

    static if(is(T == int))
        writeln("T kiểu int");
    static if (is(typeof(x) :  int))
        writeln("Biến x được ép qua kiểu int");

[Biểu thức `is`](http://wiki.dlang.org/Is_expression) giúp xác định các
điều kiện lúc biên dịch chương trình:

    static if(is(T == int)) { // T là tham số mẫu
        int x = 10;
    }

Dấu ngoặc được bỏ qua nếu điều kiện là `true` - không có khỗi mã nào
được tạo ra.  `{ {` và `} }` tạo ra các khối mã một cách tường minh.

`static if` có thể được dùng khắp nơi trong chương trình, trong các hàm,
ở phạm vi toàn cục hay trong định nghĩa của kiểu.

### Mẫu `mixin`

Khi nào bạn thấy *boiler plate*, thì mẫu `mixin` có thể giúp:

    mixin template Foo(T) {
        T foo;
    }
    ...
    mixin Foo!int; // Foo kiểu int có hiệu lực từ đây.

Mẫu `mixin` có thể gồm các biểu thức phức tạp được chèn vào nơi mẫu
được gọi đến. Bạn không cần phép tiền xử lý từ C nữa.

### Ràng buộc mẫu

Một mẫu có thể được định nghĩa với số lượng tùy ý các ràng buộc cần có
cho các thuộc tính của kiểu:

    void foo(T)(T value)
      if (is(T : int)) { // foo!T chỉ áp dụng được
                         // khi T ép qua kiểu int được
    }

Ràng buộc có thể được viết bằng kết hợp biểu thức Boolean hay thậm chí
các hàm có thể định giá lúc biên dịch. Ví dụ, hàm
`std.range.primitives.isRandomAccessRange`
kiểm tra xem một kiểu có phải là một dải hỗ trợ toán tử `[]` không.

### Nâng cao

### Tham khảo cơ bản

- [Tutorial to D Templates](https://github.com/PhilippeSigaud/D-templates-tutorial)
- [Conditional compilation](http://ddili.org/ders/d.en/cond_comp.html)
- [std.traits](https://dlang.org/phobos/std_traits.html)
- [More templates  _Programming in D_](http://ddili.org/ders/d.en/templates_more.html)
- [Mixins in  _Programming in D_](http://ddili.org/ders/d.en/mixin.html)

### Tham khảo nâng cao

- [Conditional compilation](https://dlang.org/spec/version.html)
- [Traits](https://dlang.org/spec/traits.html)
- [Mixin templates](https://dlang.org/spec/template-mixin.html)
- [D Templates spec](https://dlang.org/spec/template.html)

## {SourceCode}

```d
import std.traits : isFloatingPoint;
import std.uni : toUpper;
import std.string : format;
import std.stdio : writeln;

/*
A Vector that just works for
numbers, integers or floating points.
*/
struct Vector3(T)
  if (is(T: real))
{
private:
    T x,y,z;

    /*
    Generator for getter and setter because
    we really hate boiler plate!

    var -> T getVAR() and void setVAR(T)
    */
    mixin template GetterSetter(string var) {
        // Use mixin to construct function
        // names
        mixin("T get%s() const { return %s; }"
          .format(var.toUpper, var));

        mixin("void set%s(T v) { %s = v; }"
          .format(var.toUpper, var));
    }

    /*
    Easily generate getX, setX etc.
    functions with a mixin template.
    */
    mixin GetterSetter!"x";
    mixin GetterSetter!"y";
    mixin GetterSetter!"z";

public:
    /*
    The dot function is only available
    for floating points types
    */
    static if (isFloatingPoint!T) {
        T dot(Vector3!T rhs) {
            return x * rhs.x + y * rhs.y +
                z * rhs.z;
        }
    }
}

void main()
{
    auto vec = Vector3!double(3,3,3);
    // That doesn't work because of the template
    // constraint!
    // Vector3!string illegal;

    auto vec2 = Vector3!double(4,4,4);
    writeln("vec dot vec2 = ", vec.dot(vec2));

    auto vecInt = Vector3!int(1,2,3);
    // doesn't have the function dot because
    // we statically enabled it only for float's
    // vecInt.dot(Vector3!int(0,0,0));

    // generated getter and setters!
    vecInt.setX(3);
    vecInt.setZ(1);
    writeln(vecInt.getX, ",",
      vecInt.getY, ",", vecInt.getZ);
}
```
