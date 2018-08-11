# Lát cắt

Cần hiểu là **lát cắt** và **mảng động** là một.

Lát cắt được khai báo ở dạng `T[]` với `T` là bất kỳ kiểu nào.
Lát cắt có thể xem như một phần (hay toàn bộ) của mảng,
luôn bao gồm hai yếu tố: con trỏ đến nơi bắt đầu,
và chiều dài của lát cắt (hay điểm kết thúc).
Như thế, lát cắt là khối bộ nhớ liên tục:

    T* ptr;
    size_t length; // trên máy 32 bit, là kiểu không dấu 32 bit
                   // trên máy 64 bit, là kiểu không dấu 64 bit

### Lát cắt trên vùng nhớ mới cấp

Khi mảng động được tạo ra, kết quả trả về thực chất là lát cắt

    auto arr = new int[5];
    assert(arr.length == 5); // địa chỉ bắt đầu cho bởi arr.ptr

Bộ dọn rác sẽ quản lý việc cấp phát bộ nhớ cho các lát cắt.
Kết quả trả về giống như là "lăng kính" nhìn vào ô nhớ.

### Lát cắt trên vùng nhớ đã cấp

"Lăng kính" có thể trỏ vào bất kỳ chỗ nào, cụ thể là vào vùng nhớ đã cấp
(dù nó là động hay tĩnh); tổng quát hơn, trong D, các đối tượng nào có
thế áp dụng toán tử `opSlice` đều có thể xem qua "lăng kính", hay "lát cắt".

Lát cắt hay có dạng tường minh `TÊN_NÀO_ĐÓ[bắt đầu .. kết thúc]`:

    auto newArr = arr[1 .. 4]; // thành phần thứ 4 không được tính
    assert(newArr.length == 3);
    newArr[0] = 10; // thay đổi newArr[0] hay arr[1]

Vì chỉ là "lăng kính", việc tạo lăng kính mới, hay xem qua "lăng kính"
không làm thay đổi thực chất, hay nói cách khác không có thay đổi nào trên
vùng nhớ đã cấp; cũng như vậy, việc thay đổi (nếu có) không chỉ diễn ra hời
hợt trên "lăng kính", mà thay đổi vùng nhớ thật sự và tất cả các "lăng kính"
cùng trỏ tới một vùng nhớ sẽ ngay lập tức thay sự thay đổi.

Nếu không có "lăng kính" nào cùng xem một vùng nhớ, nghĩa là vùng nhớ đó
bị bỏ rơi, không ai quan tâm, và sẽ được bộ dọn rác tóm lấy và giải phóng.

Việc dùng lát cắt có hiệu quả khi bạn cần thay đổi trên một phần bộ nhớ
trong dải (liên tục) đã được cấp phát, với ý ghi trong đầu rằng sẽ
không phải cấp phát thêm phần bộ nhớ nào cho các đối tượng sẵn có.

Trong phần giới thiệu [về các mảng](basics/arrays), dấu tắt `[$]`
chỉ độ dài của mảng, ví dụ `arr.length`. Với các lát cắt cũng vậy, `arr[$]`
trỏ vào vùng nhớ ngay sau phần đã cấp cho toàn bộ mảng. Truy xuất như vậy
sẽ phát sinh lỗi  `RangeError` như đã nói đến.

### Đọc thêm

- [Giới thiệu về lát cắt trong D](http://dlang.org/d-array-article.html)
- [Lát cắt trong sách _Programming in D_](http://ddili.org/ders/d.en/slices.html)

## {SourceCode}

```d
import std.stdio : writeln;

void main()
{
    int[] test = [ 3, 9, 11, 7, 2, 76, 90, 6 ];
    test.writeln;
    writeln("Phần tử đầu tiên: ", test[0]);
    writeln("Phần tử cuối cùng: ", test[$ - 1]);
    writeln("Bỏ qua hai phần tử đầu tiên: ",
        test[2 .. $]);

    writeln("Lát cắt chỉ là lăng kính:");
    auto test2 = test;
    auto subView = test[3 .. $];
    test[] += 1; // thêm 1 vào phần tử đầu tiên
    test.writeln;
    test2.writeln;
    subView.writeln;

    // Lăng kính nghèo nàn, chẳng có gì để xem
    assert(test[2 .. 2].length == 0);
}
```
