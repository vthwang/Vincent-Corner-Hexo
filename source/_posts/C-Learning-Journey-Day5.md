---
title: C++ Learning Journey Day5
thumbnail:
  - /images/learning/cplusplus/CPlusPlusDay05.jpg
toc: true
date: 2021-10-19 18:41:00
categories: Study Note
tags: C++
---
<img src="/images/learning/cplusplus/CPlusPlusDay05.jpg">

***
# Section 10: String
## Class String
1. You need to include string library to use string. Also, you can use getline to get the string from the user input.
    ```
    #include <iostream>
    #include <string>

    using namespace std;

    int main()
    {
        string str = "Hello";

        cout << "Enter a string ";
        getline(cin, str);

        cout << str << endl;

        return 0;
    }
    ```
2. You can use `cin` to get the string directly and it won't get the line break. For example, output1 typed "Hi" and then enter to type "World", it will show two separate strings respectively. Also, output 2 types "Hello World", it will print Hello World separately. Not like char, you need to use `cin.ignore()` to ignore the line break.
    ```
    string str;
    cout << "Enter a string ";
    cin >> str;
    cout << str << endl;

    cin >> str;
    cout << str << endl;
    ====OUTPUT====
    Enter a string `Hi`
    Hi
    `World`
    World
    ====OUTPUT====
    Enter a string `Hello World`
    Hello
    World
    ```
## Basic Functions of Class String
1. Basic functions of class string.
    - s.length()
    - s.size()
    - s.capacity()
    - s.resize(30)
    - s.max_size()
    - s.clear()
    - s.empty()
2. Example
    ```
    string str = "Hello";

    cout << str.length() << endl;
    cout << str.size() << endl;
    cout << str.capacity() << endl;

    str.resize(50);
    cout << str.capacity() << endl;

    cout << str.max_size() << endl;

    str.clear();

    if (str.empty())
        cout << "String is empty" << endl;
    else
        cout << "String is " << str << endl;
    ====OUTPUT====
    5
    5
    22
    63
    18446744073709551599
    String is empty
    ```
## Class String - Append and Insert Functions
1. Append and insert functions
    - s.append("Bye")
    - s.insert(3, "kk")
    - s.replace(3, 5, "aa")
    - s.erase()
    - s.push_back('z')
    - s.pop_back()
    - s1.swap(s2)
2. append() example.
    ```
    string str = "Hello";

    cout << str.capacity() << endl;
    str.append(" How are you all? Hope all are fine");
    cout << str.capacity() << " " << str.length() << endl;

    cout << str << endl;
    ====OUTPUT====
    22
    47 40
    Hello How are you all? Hope all are fine
    ```
3. insert() example, the third parameters is word number you like to insert.
    ```
    string str = "How you";

    str.insert(3, " area", 4);

    cout << str << endl;
    ====OUTPUT====
    How are you
    ```
4. replace() example, the first parameter is the position start to replace and the second parameters is how many characters you want to replace with.
    ```
    string str = "programming";

    str.replace(3, 6, "H");

    cout << str << endl;
    ====OUTPUT====
    proHng
    ```
5. push_back() example, the parameter can only be char type.
    ```
    string str = "programming";

    str.push_back('H');

    cout << str << endl;
    ====OUTPUT====
    programmingH
    ```
6. pop_back() example, it removes the last character.
    ```
    string str = "programming";

    str.pop_back();

    cout << str << endl;
    ====OUTPUT====
    programmin
    ```
7. swap() example.
    ```
    string str1 = "programming";
    string str2 = "Language";

    str1.swap(str2);

    cout << str1 << endl;
    cout << str2 << endl;
    ====OUTPUT====
    Language
    programming
    ```
## String Class - Copy and Find Functions
1. Copy and Find Functions.
    - s.copy(char desp[])
    - s.find(str) or char
    - s.rfind(str)
    - s.find_first_of()
    - s.find_last_of()
    - s.substr(start, number)
    - s.compare(str)
2. copy() example.
    ```
    string s = "Welcome";

    char str[10];

    s.copy(str, 3);
    str[3] = '\0';

    cout << str << endl;
    ====OUTPUT====
    Wel
    ```
3. In default, find() finds the words from the left. rfind() finds the words from the right. If the words can't be found, it will return large number.
    ```
    string str = "How are you";

    cout << str.find("are") << endl;
    cout << str.find("yo") << endl;
    cout << str.find("is") << endl;
    cout << str.rfind('o') << endl;
    ====OUTPUT====
    4
    8
    18446744073709551615
    9
    ```
4. find_first_of() and find_last_of() examples. The second parameter is the position that you want to start your search. You can also put more than one letter as the first parameter, it will find one of the letter and return the position. find_last_of() will find from the back and return the last position of your parameter.
    ```
    string str = "Hello World";

    cout << str.find_first_of('l') << endl;
    cout << str.find_first_of('l', 3) << endl;
    cout << str.find_first_of('l', 4) << endl;
    cout << str.find_first_of("le") << endl;
    cout << str.find_last_of('l') << endl;
    ====OUTPUT====
    2
    3
    9
    1
    9
    ```
5. substr() example. The second parameter is the length of return string.
    ```
    string str = "Programming";

    cout << str.substr(3) << endl;
    cout << str.substr(3, 4) << endl;
    ====OUTPUT====
    gramming
    gram
    ```
6. compare() example.
    ```
    string str1 = "Hello";
    string str2 = "Hello";
    string str3 = "World";
    string str4 = "hello";

    cout << str1.compare(str2) << endl;
    cout << str1.compare(str3) << endl;
    cout << str1.compare(str4) << endl;
    cout << str4.compare(str1) << endl;
    ====OUTPUT====
    0
    -15
    -32
    32
    ```
7. Example of string operator.
    ```
    string str = "Holiday";
    string str2 = "World";

    cout << str.at(4) << endl;

    str[4] = 'M';
    cout << str << endl;

    str = str + str2;
    cout << str << endl;

    str = str + " How are you?";
    cout << str << endl;

    str = str2;
    cout << str << endl;
    ====OUTPUT====
    d
    HoliMay
    HoliMayWorld
    HoliMayWorld How are you?
    World
    ```
## String Class - Iterator
1. Iterator
    - string::iterator
    - begin()
    - end()
    - reverse_iterator
    - rbegin()
    - rend()
2. String iterator example.
    ```
    string str = "today";

    string::iterator it;
    for (it = str.begin(); it != str.end(); it++) {
        *it = *it -32;
    }

    cout << str << endl;

    string str1 = "today";

    string::reverse_iterator rit;
    for (rit = str.rbegin(); rit != str.rend(); rit++) {
        cout << *rit;
    }

    cout << endl;

    string str2 = "today";

    for (int i = 0; str2[i] != '\0'; i++) {
        str2[i] = str2[i] - 32;
    }

    cout << str2 << endl;
    ====OUTPUT====
    TODAY
    YADOT
    TODAY
    ```
## Find Length of a String
1. There are two ways to find the length of a string, use `str[i] != '\0'` or iterator.
    ```
    string str = "test";

    int count = 0;

    for (int i = 0; str[i] != '\0'; i++) {
        count++;
    }

    cout << count << endl;

    int iteratorCount = 0;

    string::iterator it;
    for (it = str.begin(); it != str.end(); it++) {
        iteratorCount++;
    }

    cout << iteratorCount << endl;
    ====OUTPUT====
    4
    4
    ```
## Practice Problem: Change Cases of Letters
1. Change to lowercase example.
    ```
    string str = "WELCOmE";

    for (int i = 0; str[i] != '\0'; i++) {
        if (str[i] >= 65 && str[i] <= 90) {
            str[i] += 32;
        }
    }

    cout << str << endl;
    ====OUTPUT====
    welcome
    ```
2. Change to uppercase example.
    ```
    string str = "welcome5";

    for (int i = 0; str[i] != '\0'; i++) {
        if (str[i] >= 97 && str[i] <= 122) {
            str[i] -= 32;
        }
    }

    cout << str << endl;
    ```
## Practice Problem: Count Vowels and Words in a String
1. Example.
    ```
    string str = "how Many wOrds";
    int vowels = 0, consonant = 0, space = 0;

    for (int i = 0; str[i] != '\0'; i++) {
        if (str[i] == 'A' || str[i] == 'E' || str[i] == 'I' || str[i] == 'O' || str[i] == 'U' || str[i] == 'a' || str[i] == 'e' || str[i] == 'i' || str[i] == 'o' || str[i] == 'u')
            vowels++;
        else if (str[i] == ' ')
            space++;
        else
            consonant++;
    }

    cout << "Vowels " << vowels << endl;
    cout << "Consonants " << consonant << endl;
    cout << "Words " << space + 1 << endl;
    ====OUTPUT====
    Vowels 3
    Consonants 9
    Words 3
    ```
## Practice Problem: Checking Palindrome
1. Example.
    ```
    string str = "MADAM";
    string rev = "";

    int len = (int) str.length();

    rev.resize(len);

    for (int i = 0, j = len - 1; i < len; i++, j--) {
        rev[i] = str[j];
    }
    rev[len] = '\0';

    cout << rev << endl;

    if (str.compare(rev) == 0)
        cout << "Palindrome" << endl;
    else
        cout << "Not a Palindrome" << endl;
    ====OUTPUT====
    MADAM
    Palindrome
    ```
## Practice Problem: Find username from email address
1. Example.
    ```
    string email = "john123@gmail.com";

    int i = (int) email.find('@');

    string uname = email.substr(0, i);

    cout << "User Name is " << uname << endl;
    ====OUTPUT====
    User Name is john123
    ```

# Disclaimer
> I took this course from Udemy, which is [Learn C++ Programming -Beginner to Advance- Deep Dive in C++](https://www.udemy.com/course/cpp-deep-dive). I only took some notes of this amazing course for my personal future uses and share my thoughts with my peers. If you like it, you should take the course from Udemy too.