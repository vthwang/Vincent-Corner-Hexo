---
title: Java 快速學習自我挑戰 Day6
thumbnail:
  - /images/learning/java/JavaDay06.png
date: 2020-05-24 15:10:49
categories: Study Note
tags: Java
---
<img src="/images/learning/java/JavaDay06.png">

***
### 控制流陳述句
#### 數字和挑戰
- Write a method with the name **sumDigits** that has one **int** parameter called **number**.
- If parameter is **>= 10** then the method should process the number and return **sum of all digits**, otherwise return **-1** to indicate an invalid value.
- The number from **0-9** have 1 digit so we don't want to process them, also we don't want to process negative numbers, so also return **-1** for negative numbers.
- For example calling the method **sumDigits(125)** should return **8** since **1 + 2 + 5 = 8**.
- Calling the method **sumDigit(1)** should return **-1** as per requirements described above.
- Add some code to the main method to test out the **sumDigits** method to determine that it is working correctly for valid and invalid values passed as arguments.
- Hint
    - Use **n % 10** to extract the least-significant digit.
    - Use **n = n /10** to discard the least-significant digit.
    - The method needs to be static like other methods so far in the course.
- Tip
    - Create a project with the name **DigitSumChallenge**.
#### 數字和挑戰(解答)
```
public static void main(String[] args) {
    
    System.out.println(sumDigits(125));
    System.out.println(sumDigits(-125));
    System.out.println(sumDigits(5));
    System.out.println(sumDigits(23123));
}

private static int sumDigits(int number) {

    if (number < 10) {
        return -1;
    }

    int sum = 0;

    while (number > 0) {
        int digit = number % 10;
        sum += digit;
        number /= 10;
    }

    return sum;
}
```
#### 題目一
Write a method called isPalindrome with one int parameter called number.
The method needs to return a boolean.
It should return true if the number is a palindrome number otherwise it should return false.
Check the tips below for more info about palindromes.

```
Example Input/Output
isPalindrome(-1221); → should return true
isPalindrome(707); → should return true
isPalindrome(11212); → should return false because reverse is 21211 and that is not equal to 11212.
```

Tip: What is a Palindrome number?  A palindrome number is a number which when reversed is equal to the original number. For example: 121, 12321, 1001 etc.
Tip: Logic to check a palindrome number
Find the the reverse of the given number. Store it in some variable say reverse. Compare the number with reverse.
If both are the the same then the number is a palindrome otherwise it is not.
Tip: Logic to reverse a number
Declare and initialize another variable to store the reverse of a number, for example reverse = 0.

Extract the last digit of the given number by performing the modulo division (remainder).
Store the last digit to some variable say lastDigit = num % 10.
Increase the place value of reverse by one.
To increase place value multiply the reverse variable by 10 e.g. reverse = reverse * 10.
Add lastDigit to reverse.
Since the last digit of the number is processed, remove the last digit of num. To remove the last digit divide number by 10.
Repeat steps until number is not equal to (or greater than) zero. 

A while loop would be good for this coding exercise.

Tip: Be careful with negative numbers. They can also be palindrome numbers.
Tip: Be careful with reversing a number, you will need a parameter for comparing a reversed number with the starting number (parameter).

NOTE: The method isPalindrome needs to be defined as public static like we have been doing
#### 題目一(答案)
```
public class NumberPalindrome {
    public static boolean isPalindrome(int number) {

        int reverse = 0;
        int originalNumber = number;

        while (number != 0) {

            reverse *= 10;
            int lastDigit = number % 10;
            reverse += lastDigit;
            number /= 10;
        }

        return originalNumber == reverse;
    }
}
```









