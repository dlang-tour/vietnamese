# opDispatch và opApply

Trong [kiểu ghép hay lớp](https://dlang.org/spec/operatoroverloading.html),
D cho phép bạn định nghĩa lại các toán tử
`+`, `-`, phép gọi hàm `()`. Liên quan đến khả năng này, ta sẽ bàn kỹ hơn
về hai hàm `opDispatch` và `opApply`.

### opDispatch

Các kiểu ghép hay lớp có thể định nghĩa hàm thành phần `opDispatch`
để thay cho bất kỳ hàm thành phần nào chưa được định nghĩa tường minh.
`opDispatch` nhận tên hàm thành phần chưa biết như là _tham số mẫu_, ở dạng chuỗi.
Ta còn nói `opDispatch` là hàm *catch-all*; nó cho phép một mức khác
của việc lập trình tổng quát (`generic programming`) tại lúc biên dịch mã nguồn.

    struct C {
        void callA(int i, int j) { ... }
        void callB(string s) { ... }
    }
    struct CallLogger(C) {
        C content;
        void opDispatch(string name, T...)(T vals) {
            writeln("called ", name);
            mixin("content." ~ name)(vals);
        }
    }
    CallLogger!C l;
    l.callA(1, 2);
    l.callB("ABC");

### opApply

Thay vì định nghĩa kiểu dải (*range*) riêng để dùng với phép lặp `foreach`,
ta có thể định nghĩa toán tử `opApply` như là hành thành phần. Khi duyệt
với `foreach`, hàm `opApply` sẽ được gọi với tham số là một ủy nhiệm hàm đặc biệt:

    class Tree {
        Tree lhs;
        Tree rhs;
        int opApply(int delegate(Tree) dg) {
            if (lhs && lhs.opApply(dg)) return 1;
            if (dg(this)) return 1;
            if (rhs && rhs.opApply(dg)) return 1;
            return 0;
        }
    }
    Tree tree = new Tree;
    foreach(node; tree) {
        ...
    }

Trình biên dịch chuyển hóa thân của `foreach` thành một ủy nhiệm hàm đặc biệt,
trở thành đối tượng dùng như tham số của `opApply`. Tham số duy nhất của
ủy nhiệm hàm chứa giá trị hiện tại của phép lặp. Kiểu trả về là `int`,
và nếu nó không phải là `0`, phép lặp sẽ phải dừng lại.

### In-depth

- [Định nghĩa lại toán tử trong sách _Programming in D_](http://ddili.org/ders/d.en/operator_overloading.html)
- [`opApply` trong sách _Programming in D_](http://ddili.org/ders/d.en/foreach_opapply.html)
- [Đặc tả về định nghĩa lại toán tử](https://dlang.org/spec/operatoroverloading.html)

## {SourceCode}

```d
/*
Variant có thể chứa bát kỳ kiểu nào khác.
https://dlang.org/phobos/std_variant.html
*/

import std.variant : Variant;

/*
Nhờ `opDispatch` kiểu `var` sau đây
có thể có tùy ý thành thầnh,
giống `var` trong JavaScript.
*/
struct var {
    private Variant[string] values;

    @property
    Variant opDispatch(string name)() const {
        return values[name];
    }

    @property
    void opDispatch(string name, T)(T val) {
        values[name] = val;
    }
}

void main() {
    import std.stdio : writeln;

    var test;
    test.foo = "test";
    test.bar = 50;
    writeln("test.foo = ", test.foo);
    writeln("test.bar = ", test.bar);
    test.foobar = 3.1415;
    writeln("test.foobar = ", test.foobar);
    // Dòng sau phát sinh lỗi, vì
    // test.notthere chưa từng xuất hiện
    // trước dòng này.
    // writeln("test.notthere = ",
    //   test.notthere);
}
```
