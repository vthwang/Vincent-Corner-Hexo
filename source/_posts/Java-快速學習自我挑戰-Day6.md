---
title: Java 快速學習自我挑戰 Day6
thumbnail:
  - /images/learning/java/JavaDay06.png
date: 2020-05-24 15:10:49
categories: Study Note
tags: Java
toc: true
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
#### 題目二
Write a method named sumFirstAndLastDigit with one parameter of type int called number.
The method needs to find the first and the last digit of the parameter number passed to the method, using a loop and return the sum of the first and the last digit of that number.
If the number is negative then the method needs to return -1 to indicate an invalid value.

```
Example input/output
* sumFirstAndLastDigit(252); → should return 4, the first digit is 2 and the last is 2 which gives us 2+2 and the sum is 4.
* sumFirstAndLastDigit(257); → should return 9, the first digit is 2 and the last is 7 which gives us 2+7 and the sum is 9.
* sumFirstAndLastDigit(0); → should return 0, the first digit and the last digit is 0 since we only have 1 digit, which gives us 0+0 and the sum is 0.
* sumFirstAndLastDigit(5); → should return 10, the first digit and the last digit is 5 since we only have 1 digit, which gives us 5+5 and the sum is 10.
* sumFirstAndLastDigit(-10); → should return -1, since the parameter is negative and needs to be positive.
```

NOTE: The method sumFirstAndLastDigit needs to be defined as public static like we have been doing so far in the course.
NOTE: Do not add a main method to solution code.
#### 題目二(答案)
```
public class FirstLastDigitSum {
    public static int sumFirstAndLastDigit(int number) {

        if (number < 0) {
            return -1;
        }

        int lastDigit = number % 10;
        int firstDigit = 0;

        while (number > 0) {

            if (number < 10) {
                firstDigit = number;
                break;
            }
            number /= 10;
        }

        return lastDigit + firstDigit;
    }
}
```
#### 題目三
Write a method named getEvenDigitSum with one parameter of type int called number.
The method should return the sum of the even digits within the number.
If the number is negative, the method should return -1 to indicate an invalid value.

```
EXAMPLE INPUT/OUTPUT:
* getEvenDigitSum(123456789); → should return 20 since 2 + 4 + 6 + 8 = 20
* getEvenDigitSum(252); → should return 4 since 2 + 2 = 4
* getEvenDigitSum(-22); → should return -1 since the number is negative
```

NOTE: The method getEvenDigitSum should be defined as public static like we have been doing so far in the course.
NOTE: Do not add a main method to the solution code.
#### 題目三(答案)
```
public class EvenDigitSum {
    public static int getEvenDigitSum(int number) {

        if (number < 0) {
            return -1;
        }

        int sum = 0;

        while (number > 0) {

            int remainder = number % 10;

            if (remainder % 2 == 0) {
                sum += remainder;
            }

            number /= 10;
        }

        return sum;
    }
}
```
#### 題目四
Write a method named hasSharedDigit with two parameters of type int. 
Each number should be within the range of 10 (inclusive) - 99 (inclusive). If one of the numbers is not within the range, the method should return false.
The method should return true if there is a digit that appears in both numbers, such as 2 in 12 and 23; otherwise, the method should return false.

```
EXAMPLE INPUT/OUTPUT:
* hasSharedDigit(12, 23); → should return true since the digit 2 appears in both numbers
* hasSharedDigit(9, 99); → should return false since 9 is not within the range of 10-99
* hasSharedDigit(15, 55); → should return true since the digit 5 appears in both numbers
```

NOTE: The method hasSharedDigit should be defined as public static like we have been doing so far in the course.
NOTE: Do not add a main method to the solution code.
#### 題目四(答案)
```
public class SharedDigit {
    public static boolean hasSharedDigit(int firstNumber, int secondNumber) {

        if (firstNumber < 10 || firstNumber > 99 || secondNumber < 10 || secondNumber > 99) {
            return false;
        }

        int firstNumberLastDigit = firstNumber % 10;
        int firstNumberFirstDigit = firstNumber / 10;

        int secondNumberLastDigit = secondNumber % 10;
        int secondNumberFirstDigit = secondNumber / 10;

        return firstNumberLastDigit == secondNumberLastDigit || firstNumberLastDigit == secondNumberFirstDigit || firstNumberFirstDigit == secondNumberLastDigit || firstNumberFirstDigit == secondNumberFirstDigit;
    }
}
```
#### 題目五
Write a method named hasSameLastDigit with three parameters of type int. 
Each number should be within the range of 10 (inclusive) - 1000 (inclusive). If one of the numbers is not within the range, the method should return false.
The method should return true if at least two of the numbers share the same rightmost digit; otherwise, it should return false.

```
EXAMPLE INPUT/OUTPUT:
* hasSameLastDigit (41, 22, 71); → should return true since 1 is the rightmost digit in numbers 41 and 71
* hasSameLastDigit (23, 32, 42); → should return true since 2 is the rightmost digit in numbers 32 and 42
* hasSameLastDigit (9, 99, 999); → should return false since 9 is not within the range of 10-1000
```

Write another method named isValid with one parameter of type int.
The method needs to return true if the number parameter is in range of 10(inclusive) - 1000(inclusive), otherwise return false.

```
EXAMPLE INPUT/OUTPUT
* isValid(10); → should return true since 10 is within the range of 10-1000
* isValid(468); → should return true since 468 is within the range of 10-1000
* isValid(1051); → should return false since 1051 is not within the range of 10-1000
```

NOTE: All methods need to be defined as public static as we have been doing so far in the course.
NOTE: Do not add a main method to the solution code.
#### 題目五(答案)
```
public class LastDigitChecker {
    public static boolean hasSameLastDigit(int firstNumber, int secondNumber, int thirdNumber) {

        if (!isValid(firstNumber) || !isValid(secondNumber) || !isValid(thirdNumber)) {
            return false;
        }

        int firstNumberLastDigit = firstNumber % 10;
        int secondNumberLastDigit = secondNumber % 10;
        int thirdNumberLastDigit = thirdNumber % 10;

        return firstNumberLastDigit == secondNumberLastDigit || secondNumberLastDigit == thirdNumberLastDigit || thirdNumberLastDigit == firstNumberLastDigit;
    }

    public static boolean isValid(int number) {

        return number >= 10 && number <= 1000;
    }
}
```
#### 題目六
Write a method named getGreatestCommonDivisor with two parameters of type int named first and second. 
If one of the parameters is < 10, the method should return -1 to indicate an invalid value.
The method should return the greatest common divisor of the two numbers (int).
The greatest common divisor is the largest positive integer that can fully divide each of the integers (i.e. without leaving a remainder).

For example 12 and 30:
12 can be divided by 1, 2, 3, 4, 6, 12
30 can be divided by 1, 2, 3, 5, 6, 10, 15, 30

The greatest common divisor is 6 since both 12 and 30 can be divided by 6, and there is no resulting remainder.

```
EXAMPLE INPUT/OUTPUT:
* getGreatestCommonDivisor(25, 15); should return 5 since both can be divided by 5 without a remainder
* getGreatestCommonDivisor(12, 30); should return 6 since both can be divided by 6 without a remainder
* getGreatestCommonDivisor(9, 18); should return -1 since the first parameter is < 10
* getGreatestCommonDivisor(81, 153); should return 9 since both can be divided by 9 without a remainder
```

HINT: Use a while or a for loop and check if both numbers can be divided without a remainder.
HINT: Find the minimum of the two numbers.
NOTE: The method getGreatestCommonDivisor should be defined as public static like we have been doing so far in the course.
NOTE: Do not add a main method to the solution code.
#### 題目六(答案)
```
public class GreatestCommonDivisor {
    public static int getGreatestCommonDivisor(int first, int second) {

        if (first < 10 || second < 10) {
            return -1;
        }

        int largeNumber = 0;
        int smallNumber = 0;

        // 找出兩數中哪個數字大
        if (first > second) {
            largeNumber = first;
            smallNumber = second;
        } else {
            largeNumber = second;
            smallNumber = first;
        }

        // 找出數字小的因數，拿去給大數字除，如果可以整除，表示它也是大數的因數，也就是他們的共同最大公因數
        int i = smallNumber;
        int greatestCommonDivisor = 0;
        while (i >= 1) {

            if (smallNumber % i == 0 && largeNumber % i == 0) {
                greatestCommonDivisor = i;
                break;
            }

            i--;
        }

        return greatestCommonDivisor;
    }
}
```
#### 題目七
Write a method named printFactors with one parameter of type int named number. 
If number is < 1, the method should print "Invalid Value".
The method should print all factors of the number. A factor of a number is an integer which divides that number wholly (i.e. without leaving a remainder).
For example, 3 is a factor of 6 because 3 fully divides 6 without leaving a remainder. In other words 6 / 3 = 2.

```
EXAMPLE INPUT/OUTPUT:
* printFactors(6); → should print 1 2 3 6
* printFactors(32); → should print 1 2 4 8 16 32
* printFactors(10); → should print 1 2 5 10
* printFactors(-1); → should print "Invalid Value" since number is < 1
```

HINT: Use a while or for loop.
NOTE: When printing numbers, each number can be in its own line. They don't have to be separated by a space.
For example, the printout for printFactors(10); can be:
1
2
5
10
NOTE: The method printFactors should be defined as public static like we have been doing so far in the course.
NOTE: Do not add a main method to the solution code.
#### 題目七(答案)
```
public class FactorPrinter {
    public static void printFactors(int number) {

        if (number < 1) {
            System.out.println("Invalid Value");
        }
        
        for (int i = 1; i <= number; i++) {

            if (number % i == 0) {
                System.out.println(i);
            }
        }
    }
}
```
#### 題目八
What is the perfect number?
A perfect number is a positive integer which is equal to the sum of its proper positive divisors.
Proper positive divisors are positive integers that fully divide the perfect number without leaving a remainder and exclude the perfect number itself.
For example, take the number 6:
Its proper divisors are 1, 2, and 3 (since 6 is the value of the perfect number, it is excluded), and the sum of its proper divisors is 1 + 2 + 3 = 6. 
Therefore, 6 is a perfect number (as well as the first perfect number).
Write a method named isPerfectNumber with one parameter of type int named number. 
If number is < 1, the method should return false.
The method must calculate if the number is perfect. If the number is perfect, the method should return true; otherwise, it should return false.

```
EXAMPLE INPUT/OUTPUT:
* isPerfectNumber(6); should return true since its proper divisors are 1, 2, 3 and the sum is 1 + 2 + 3 = 6
* isPerfectNumber(28); should return true since its proper divisors are 1, 2, 4, 7, 14 and the sum is 1 + 2 + 4 + 7 + 14 = 28
* isPerfectNumber(5); should return false since its only proper divisor is 1 and the sum is 1 not 5
* isPerfectNumber(-1); should return false since the number is < 1
```

HINT: Use a while or for loop.
HINT: Use the remainder operator.
NOTE: The method isPerfectNumber should be defined as public static like we have been doing so far in the course.
NOTE: Do not add a main method to the solution code.
#### 題目八(答案)
```
public class PerfectNumber {
    public static boolean isPerfectNumber(int number) {

        if (number < 1) {
            return false;
        }

        int sum = 0;

        for (int i = 1; i < number; i++) {

            if (number % i == 0) {
                sum += i;
            }
        }

        return sum == number;
    }
}
```
#### 題目九
Write a method called numberToWords with one int parameter named number.
The method should print out the passed number using words for the digits.
If the number is negative, print "Invalid Value".
To print the number as words, follow these steps:

1. Extract the last digit of the given number using the remainder operator. 
2. Convert the value of the digit found in Step 1 into a word. There are 10 possible values for that digit, those being 0, 1, 2, 3, 4, 5, 6, 7, 8, 9. Print the corresponding word for each digit, e.g. print "Zero" if the digit is 0, "One" if the digit is 1, and so on.
3. Remove the last digit from the number.
4. Repeat Steps 2 through 4 until the number is 0.

The logic above is correct, but in its current state, the words will be printed in reverse order. For example, if the number is 234, the logic above will produce the output "Four Three Two" instead of "Two Three Four". To overcome this problem, write a second method called reverse.
The method reverse should have one int parameter and return the reversed number (int). For example, if the number passed is 234, then the reversed number would be 432. The method  reverse should also reverse negative numbers.
Use the method reverse within the method numberToWords in order to print the words in the correct order.
Another thing to keep in mind is any reversed number with leading zeroes (e.g. the reversed number for 100 is 001). The logic above for the method numberToWords will print "One", but that is incorrect. It should print "One Zero Zero". To solve this problem, write a third method called getDigitCount.
The method getDigitCount should have one int parameter called number and return the count of the digits in that number. If the number is negative, return -1 to indicate an invalid value.
For example, if the number has a value of 100, the method getDigitCount should return 3 since the number 100 has 3 digits (1, 0, 0).

```
Example Input/Output - getDigitCount method
* getDigitCount(0); should return 1 since there is only 1 digit
* getDigitCount(123); should return 3
* getDigitCount(-12); should return -1 since the parameter is negative
* getDigitCount(5200); should return 4 since there are 4 digits in the number
```
```
Example Input/Output - reverse method
* reverse(-121); should  return -121
* reverse(1212); should return  2121
* reverse(1234); should return 4321
* reverse(100); should return 1
```
```
Example Input/Output - numberToWords method
* numberToWords(123); should print "One Two Three".
* numberToWords(1010); should print "One Zero One Zero".
* numberToWords(1000); should print "One Zero Zero Zero".
* numberToWords(-12); should print "Invalid Value" since the parameter is negative.
```

HINT: Use a for loop to print zeroes after reversing the number. As seen in a previous example, 100 reversed becomes 1, but the method numberToWords should print "One Zero Zero". To get the number of zeroes, check the difference between the digit count from the original number and the reversed number. 
NOTE: When printing words, each word can be in its own line. For example, numberToWords(123); can be:
One
Two
Three
They don't have to be separated by a space.
NOTE: The methods numberToWords, getDigitCount, reverse should be defined as public static like we have been doing so far in the course.
NOTE: In total, you have to write 3 methods.
NOTE: Do not add a main method to the solution code.
#### 題目九(答案)
```
public class NumberToWords {
    public static void numberToWords(int number) {

        if (number < 0) {
            System.out.println("Invalid Value");
        }

        int remainder;

        int reverseNumber = reverse(number);
        int digitCount = getDigitCount(number);
        int count = 0;
        while (reverseNumber > 0) {

            remainder = reverseNumber % 10;
            switch (remainder) {
                case 0:
                    System.out.println("Zero");
                    break;
                case 1:
                    System.out.println("One");
                    break;
                case 2:
                    System.out.println("Two");
                    break;
                case 3:
                    System.out.println("Three");
                    break;
                case 4:
                    System.out.println("Four");
                    break;
                case 5:
                    System.out.println("Five");
                    break;
                case 6:
                    System.out.println("Six");
                    break;
                case 7:
                    System.out.println("Seven");
                    break;
                case 8:
                    System.out.println("Eight");
                    break;
                case 9:
                    System.out.println("Nine");
                    break;

                default:
                    System.out.println("Invalid Value");
                    break;
            }

            count++;
            reverseNumber /= 10;
        }

        if (digitCount != count) {
            int leftZero = digitCount - count;
            for (int i = 0; i < leftZero; i++) {
                System.out.println("Zero");
            }
        }

    }

    public static int getDigitCount(int number) {

        if (number < 0) {
            return -1;
        }

        if (number == 0) {
            return 1;
        }

        int count = 0;
        while (number > 0) {

            count++;
            number /= 10;
        }

        return count;
    }

    public static int reverse(int number) {

        // 123 -> 321, 100 -> 1
        int reverseNumber = 0;
        int remainder;
        while (number != 0) {

            remainder = number % 10;
            if (reverseNumber != 0) {
                reverseNumber = (reverseNumber * 10) + remainder;
            } else {
                reverseNumber = remainder;
            }

            number /= 10;
        }

        return reverseNumber;
    }
}
```