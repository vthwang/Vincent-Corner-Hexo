---
title: C++ Learning Journey Day11
thumbnail:
  - /images/learning/cplusplus/CPlusPlusDay11.jpg
toc: true
date: 2021-12-03 20:46:32
categories: Study Note
tags: C++
---
<img src="/images/learning/cplusplus/CPlusPlusDay11.jpg">

***
# Section 22: I/O Streams
## Streams
1. Stream is a flow of data or flow of characters. Streams are used for accessing the data from outside program.
2. Here are the types of stream.
    - istream: `cin >>`
    - ostream: `cout <<`
    - ifstream
    - ofstream
## Writing in a File
1. Example.
    ```
    #include <iostream>
    #include <fstream>

    using namespace std;

    int main()
    {
        ofstream ofs("My.txt", ios::trunc);
        ofs << "John" << endl;
        ofs << 25 << endl;
        ofs << "cs" << endl;
        ofs.close();

        return 0;
    }
    ```
## Reading From a File
1. Example.
    ```
    #include <iostream>
    #include <fstream>

    using namespace std;

    int main()
    {
        ofstream ofs("My.txt", ios::trunc);
        ofs << "John" << endl;
        ofs << 25;
        ofs.close();

        ifstream ifs;
        ifs.open("My.txt");
        if (!ifs.is_open())
            cout << "File can't be open" << endl;
        string str;
        int x;
        ifs >> str;
        ifs >> x;
        cout << str << " " << x << endl;

        if (ifs.eof())
            cout << "end of file reached";
        ifs.close();


        return 0;
    }
    ====OUTPUT====
    John 25
    end of file reached
    ```
## Serialization
1. Example.
    ```
    #include <iostream>
    #include <fstream>

    using namespace std;

    class Student
    {
    public:
        string name;
        int roll;
        string branch;
        friend ofstream & operator<<(ofstream &ofs, Student &s);
        friend ifstream & operator>>(ifstream &ifs, Student &s);
    };

    ofstream & operator<<(ofstream &ofs, Student &s)
    {
        ofs << s.name << endl;
        ofs << s.roll << endl;
        ofs << s.branch << endl;

        return ofs;
    }

    ifstream & operator>>(ifstream &ifs, Student &s)
    {
        ifs >> s.name >> s.roll >> s.branch;
        return ifs;
    }

    int main()
    {
        Student s1;
        s1.name = "Khan";
        s1.roll = 10;
        s1.branch = "CS";

        ofstream ofs("Student.txt", ios::trunc);
        ofs << s1;
        ofs.close();

        Student s2;
        ifstream ifs("Student.txt");
        ifs >> s2;
        cout << "Name " << s2.name << endl;
        cout << "Roll " << s2.roll << endl;
        cout << "Branch " << s2.branch << endl;

        return 0;
    }
    ====OUTPUT====
    Name Khan
    Roll 10
    Branch CS
    ```
## Text and Binary Files
1. Text files are human readable and binary files are a machine readable.
2. Binary file is faster and take less space.
## Manipulators
1. Manipulators are used for enhancing streams or formatting streams.
2. Manipulators for integer: `hex`, `oct`, `dec`, `fixed`, `scientific`. Example.
    ```
    cout << endl;
    cout << "\n";

    cout << hex << 163 << endl;

    cout << fixed << 125.731 << endl;
    cout << scientific << 125.731 << endl;
    ====OUTPUT====


    a3
    125.731000
    1.257310e+02
    ```

# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.