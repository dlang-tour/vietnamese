# Mảng

Mảng trong D có thể là **mảng động** hoặc **mảng tĩnh**.
Việc sử dụng mảng luôn phải đảm bảo các chặn trên dưới được đảm bảo,
về bản chất là ngăn chặn truy cập ra ngoài vùng nhớ đang được
cấp phát cho mảng.
Việc truy cập ngoài chặn (trên, dưới) sẽ phát sinh lỗi `RangeError`
và làm chương trình dừng lại. Nếu đủ dũng cảm, bạn có thể yêu cầu trình
biên dịch bỏ qua việc kiểm tra chặn bằng chỉ thị `-boundscheck=off`:
việc này có thể giúp chương trình chạy nhanh hơn với cái giá phải trả
là sự mất an toàn :)

#### Mảng tĩnh

Vùng nhớ cấp phát cho mảng tĩnh bên trong một hàm nằm trên bộ nhớ `stack`,
còn cho các mảng tĩnh khác thì thuộc về vùng nhớ tĩnh.
Lý do là mảng tĩnh có kích thước _(bộ nhớ)_ cố định mà trình
biên dịch có thể biết được ngay. Ví dụ với khai báo

    int[8] arr;

thì `arr` kiểu `int[8]`. Trái với C/++, kích thước được chỉ ra ngay sau
kiểu của từng phần tử trong mảng.

#### Mảng động

Vùng nhớ cấp phát cho mảng động nằm trên `heap`, và có thể co dãn
lúc chương trình đang chạy. Mảng động được khai báo với `new`

    int size = 8; // biến thay đổi lúc chạy
    int[] arr = new int[size];

Kiểu của `arr` là `int[]`, là một _lát cắt_ trên bộ nhớ.
Chi tiết về lát cắt có trong [phần sau](basics/slices);
tạm thời bạn hiểu đó là một khối liên tục trên bộ nhớ máy tính.

Mảng nhiều chiều được khai báo như trong ví dụ `auto arr = new int[3][3]`.

#### Phép toán và thuộc tính trên mảng

Dùng `~` để nối hai mảng với nhau, kết quả là mảng động mới.

Các phép toán cơ bản như cộng, trừ, ... có thể áp dụng trên toàn bộ mảng
có cú pháp đơn giản như ví dụ  `c[] = a[] + b[]`; trong ví dụ này,
kết quả là mảng `c` sao cho
`c[0] = a[0] + b[0]`, `c[1] = a[1] + b[1]`, v.v...
Bạn cũng có thể dùng cú pháp sau

    a[] *= 2; // nhân mỗi phần tử với 2
    a[] %= 26; // chia mô-đun-lô mỗi phần từ cho 26

Các phép toán kiểu này có thể được trình biên dịch lựa chọn dịch qua
các mã máy sử dụng các chỉ thị đặc biệt của bộ vi xử lý có hỗ trợ
tính toán trên mảng.

Cả mảng động và tĩnh đều có thuộc tính `.length` chỉ kích thước
(số phần tử) của mảng. Đối với mảng tĩnh, thuộc tính đó chỉ để đọc,
không thể thay đổi. Với mảng động, có thể dùng `.length` để co dãn mảng.

Thuộc tính `.dup` sao chép một mảng (việc sao chép trên bộ nhớ thực sự diễn ra nhé!)

Mỗi phần tử của mảng được truy cập nhờ cú pháp chỉ số  `arr[idx]`.
Thay cho `.length` bạn có thể dùng ký hiệu tắt `$`, ví dụ `arr[$ - 1]`
tương đương với `arr[arr.length - 1]` là phần tử cuối cùng bên phải của mảng.

### Bài tập

Hoàn thiện hàm `encrypt` để mã hóa tin đầu vào theo kiểu [*Caesar*](https://vi.wikipedia.org/wiki/M%E1%BA%ADt_m%C3%A3_Caesar).
Để đơn giản, ta giả định rằng tin đầu vào chỉ gồm các ký tự trong dải từ `a` tới `z`.

Lời giải tham khảo [có ở đây](https://github.com/dlang-tour/core/issues/227).

### Đọc thêm

- [Mảng trong sách _Programming in D_](http://ddili.org/ders/d.en/arrays.html)
- [Lát cắt trong D](https://dlang.org/d-array-article.html)
- [Đặc tả mảng](https://dlang.org/spec/arrays.html)

## {SourceCode:incomplete}

```d
import std.stdio : writeln;

/**
Dịch chuyển mỗi ký tự đầu `shift` vị trí.
Đầu vào chỉ gồm ký tự trong dải `a-z`.
Khi dịch chuyển tới `z` thì quay lại
từ đầu (đến `a`)

Tham số:
    input = mảng cần dịch
    shift = số vị trí cần dịch chuyển
Trả về:
    Mảng với mỗi phần từ đã được dịch chuyển
*/
char[] encrypt(char[] input, char shift)
{
    auto result = input.dup;
    // TODO: dịch chuyển từng phần tử của mảng
    return result;
}

void main()
{
    // Mã hóa kiểu Caesar, dịch 16 vị trí
    char[] toBeEncrypted = [ 'w','e','l','c',
      'o','m','e','t','o','d',
      // Dấu phảy , cuối cùng được
      // trình biên dịch bỏ qua
    ];
    writeln("Before: ", toBeEncrypted);
    auto encrypted = encrypt(toBeEncrypted, 16);
    writeln("After: ", encrypted);

    // Kiểm tra lại xem kết quả
    // có đúng như mong đợi không.
    assert(encrypted == [ 'm','u','b','s','e',
            'c','u','j','e','t' ]);
}
```
