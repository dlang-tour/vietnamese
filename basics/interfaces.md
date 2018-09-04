# Giao tiếp

D cho phép định nghĩa giao tiếp `interface`, về kỹ thuật thì giống
như kiểu lớp `class`, nhưng các hàm của nó chỉ được khai báo như giao diện,
còn phần định nghĩa thực sự của hàm phải được thực hiện trong
các lớp thừa kế từ giao tiếp.

    interface Animal {
        void makeNoise();
    }

Trong giao tiếp `Animal`, hàm `makeNoise` chỉ được khai báo để đấy chứ
không có định nghĩa của hàm; lớp `Dog` thừa kế từ `Animal` sẽ định nghĩa
hàm như nó muốn.

    class Dog : Animal {
        override void makeNoise() {
            ...
        }
    }

    auto dog = new Dog;
    Animal animal = dog; // tự động chuyển kiểu
    animal.makeNoise();

Không có giới hạn cho số hàm giao tiếp một lớp định nghĩa,
tuy nhiên mỗi lớp chỉ thừa kế từ chỉ một lớp cơ sở.

### NVI (non virtual interface)

Ngoài các hàm ảo trong giao tiếp mà bạn phải định nghĩa lại trong lớp thừa kế,
D cũng cho phép chỉ ra các hàm không ảo (`non-virtual`) trong giao tiếp chung,
đó là các hàm được định nghĩa trong giao tiếp và không thể định nghĩa lại
trong các lớp thừa kế. Việc này hạn chế việc làm hỏng các hàm chung của
các lớp thừa kế từ giao diện.

Việc cho phép định nghĩa hàm không ảo này gọi là
[NVI](https://en.wikipedia.org/wiki/Non-virtual_interface_pattern),
và bạn dùng từ khóa `final` như ví dụ sau:

    interface Animal {
        void makeNoise();
        final doubleNoise() // NVI
        {
            makeNoise();
            makeNoise();
        }
    }

### Đọc thêm

- [Interfaces in _Programming in D_](http://ddili.org/ders/d.en/interface.html)
- [Interfaces in D](https://dlang.org/spec/interface.html)

## {SourceCode}

```d
import std.stdio : writeln;

interface Animal {
    /*
    Hàm ảo, cần phải được định nghĩa.
    */
    void makeNoise();

    /*
    Mẫu NVI.
    Dùng makeNoise để biến hóa tùy theo lớp

    Params:
        n =  number of repetitions
    */
    final void multipleNoise(int n) {
        for(int i = 0; i < n; ++i) {
            makeNoise();
        }
    }
}

class Dog: Animal {
    override void makeNoise() {
        writeln("Woof!");
    }
}

class Cat: Animal {
    override void makeNoise() {
        writeln("Meeoauw!");
    }
}

void main() {
    Animal dog = new Dog;
    Animal cat = new Cat;
    Animal[] animals = [dog, cat];
    foreach(animal; animals) {
        animal.multipleNoise(5);
    }
}
```
