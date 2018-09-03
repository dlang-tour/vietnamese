# Mảng liên hợp

*ND:* Ta dùng mảng liên hợp cho từ gốc *Associative Array*. Nếu không
  có gì nhầm lẫn, ta chỉ gọi tắt là *mảng*.

D hỗ trợ  *mảng liên hợp* hay còn gọi là ánh xạ băm (`hash map`).
Ví dụ mảng với khóa kiểu chuỗi và giá trị kiểu số nguyên được khai báo
như sau:

    int[string] arr;

Lấy ví dụ về việc gán giá trị phần tử theo khóa của mảng:

    arr["key1"] = 10;

Dùng chỉ thị `in` để biết một khóa có trong mảng hay không:

    if ("key1" in arr)
        writeln("Có");

Biểu thức `in` trả về con trỏ tới giá trị  của khóa, hoặc trả về `null`
nếu không tìm thấy khóa đã chỉ ra. Ta có thể tìm phần tử theo khóa
rồi gán giá trị mới cho nó như sau:

    if (auto val = "key1" in arr)
        *val = 20;

Nếu khóa chưa có trong mảng, việc truy cập phần tử theo khóa đó làm
phát sinh lỗi `RangeError` và chương trình lập tức dừng lại.
Để tránh trường hợp này, có thể chỉ ra giá trị mặc định nếu khóa chưa có:

    get(key, defaultValue)

Mảng liên hợp cũng có kích thước cho bởi `.length`, có thể bỏ đi phần tử
bằng phép `.remove(key)`. Bạn có thể tự tìm hiểu thêm về `.byKey` và `.byValue`
là hai phép duyệt qua mảng liên hợp.

### Đọc thêm

- [Mảng liên hợp trong sách _Programming in D_](http://ddili.org/ders/d.en/aa.html)
- [Đặc tả của mảng liên hợp](https://dlang.org/spec/hash-map.html)
- [std.array.byPair](http://dlang.org/phobos/std_array.html#.byPair)

## {SourceCode}

```d
import std.array : assocArray;
import std.algorithm.iteration: each, group,
    splitter, sum;
import std.string: toLower;
import std.stdio : writefln, writeln;

void main()
{
    string text = "Rock D with D";

    // Quét các từ và đếm mỗi từ một lần.
    int[string] words;
    text.toLower()
        .splitter(" ")
        .each!(w => words[w]++);

    foreach (key, value; words)
        writefln("key: %s, value: %d",
                       key, value);

    // `.keys` và .values` trả về các mảng
    writeln("Words: ", words.keys);

    // Dải lười được trả về từ `.byKey`,
    // q`.byValue` hay `.byKeyValue`
    writeln("# Words: ", words.byValue.sum);

    // Mảng liên hợp mới có thể được tạo
    // bởi `assocArray` bằng dải
    // các cặp key/value.
    auto array = ['a', 'a', 'a', 'b', 'b',
                  'c', 'd', 'e', 'e'];

    // `.group` cho ứng với mỗi phần tử số
    // lần xuất hiện liên tiếp của nó.
    // (Xem kết quả sẽ dễ hiểu hơn.)
    auto keyValue = array.group;
    writeln("Key/Value range: ", keyValue);
    writeln("Associative array: ",
             keyValue.assocArray);
}
```
