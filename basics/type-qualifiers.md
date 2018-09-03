# Hằng và bất biến

_(tiêu đề nguyên thủy: Mutability)_

D là ngôn ngữ xác định kiểu tĩnh: kể từ lúc biến được khai báo, kiểu của nó
không thể thay đổi sang kiểu khác. Điều này hỗ trợ trình biên dịch
phát hiện sớm nhiều lỗi và thiết lập giới hạn của biến lúc biên dịch,
nhờ đó các chương trình đồ sộ sẽ an toàn hơn và dễ bảo trì hơn.

Trong khi đó, giá trị của biến có thể là hằng số (`const`),
bất biến (`immutable`)
hoặc có thể thay đổi (`mutable`).
Những tính chất này được xác định lúc khai báo biến.

### `bất biến`

Các biến được khai báo với `immutable` sẽ chỉ được gán giá trị đúng một lần,
và sau đó việc thay đổi bất kỳ sẽ phát sinh lỗi:

    immutable int err = 5;
    // hoặc: immutable err = 5
    // vì int được nội suy từ giá trị 5.
    err = 5; // lỗi biên dịch

Với thuộc tính `immutable`, biến có thể được chia sẻ an toàn giữa các
luồng (_thread_) xử lý, và giá trị của nó có thể được lưu trữ đệm (_cache_)
hiệu quả.

### `hằng`

Biến khai báo với `const` cũng không thể thay đổi giá trị, nhưng điều này
chỉ áp dụng trong giới hạn của ngữ cảnh hiện tại (_scope_). Ví dụ, một
biến được khai báo giá trị ở một nơi, và được dùng trong một hàm
với ràng buộc rằng biến không thể thay đổi giá trị bên trong hàm đó.
Điều này thường thấy khi thiết kế các giao diện ứng dụng (_API_), ở đó các
hàm nhận tham số nhưng không hề / không thể thay đổi giá trị của tham số đầu vào.

Chỉ thị `const` có thể áp dụng với biến đã được khai báo là `immutable`
hoặc `mutable`.

    void foo(const char[] s)
    {
        // bỏ đi thay đổi s như sau
        // sẽ phát sinh lỗi biên dịch
        // s[0] = 'x';

        import std.stdio : writeln;
        writeln(s);
    }

    // `foo` có thể dùng với hai kiểu biến
    foo("abcd"); // chuỗi "abcd" là mảng bất biến
    foo("abcd".dup); // .dup trả về mảng khả biến

Cả hai chỉ thị `immutable` và `const` đều có tính bắc cầu: chúng có tác dụng
với kiểu cùng với mọi thành phần con của kiểu đó. _(Khi coi về `Struct`
bạn sẽ hiểu rõ hơn ý này.)_

### Đọc thêm

#### Cơ bản

- [Bất biến trong sách _Programming in D_](http://ddili.org/ders/d.en/const_and_immutable.html)
- [Ngữ cảnh trong sách _Programming in D_](http://ddili.org/ders/d.en/name_space.html)

#### Nâng cao

- [const(FAQ)](https://dlang.org/const-faq.html)
- [Hằng và bất biến trong D](https://dlang.org/spec/const3.html)

## {SourceCode}

```d
import std.stdio : writeln;

void main()
{
    /**
    * Biến mới mặc định là `immutable`.
    */
    int m = 100; // mutable
    writeln("m: ", typeof(m).stringof);
    m = 10; // fine

    /**
    * Trỏ vào vùng nhớ khả biến:
    */
    // Con trỏ hằng, có thể trỏ vào vùng nhớ
    // mà nội dung vùng đó có thể thay đổi
    const int* cm = &m;
    writeln("cm: ", typeof(cm).stringof);
    // Dòng sau sẽ báo lỗi `const`
    // *cm = 100; // lỗi!

    // Điều tương tự không áp dụng với con trỏ
    // được khai báo `immutable` (bất biến)
    //
    // immutable int* im = &m; // lỗi!

    /**
    * Trỏ vào vùng nhớ chỉ đọc:
    */
    immutable v = 100;
    writeln("v: ", typeof(v).stringof);
    // v = 5; // lỗi!

    // `const` có thể trỏ vào vùng nhớ chỉ đọc
    // và biến hằng cũng chỉ có thể `để đọc`
    const int* cv = &v;
    writeln("cv: ", typeof(cv).stringof);
    // *cv = 10; // lỗi!
}
```
