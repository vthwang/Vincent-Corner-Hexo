---
title: Java 快速學習自我挑戰 Day13
thumbnail:
  - /images/learning/java/JavaDay13.jpg
toc: true
date: 2021-01-28 10:24:57
categories: Study Note
tags: Java
---
<img src="/images/learning/java/JavaDay13.jpg">

***
### Arrays、Java 內建 List、Autoboxing 和 Unboxing
#### List 和 ArrayList
1. Array 如果需要變更長度，會需要變更 Array 的長度，但是重複做變更長度會很冗贅，所以這邊要講 List 中的 ArrayList，ArrayList 就是可以變更長度的 Array，ArrayList 還可以保存 Objects。
2. 這邊用購物清單的功能做一個例子，先新增一個 GroceryList.java
```
import java.util.ArrayList;

public class GroceryList {
    private ArrayList<String> groceryList = new ArrayList<String>();

    public void addGroceryItem(String item) {
        groceryList.add(item);
    }

    public ArrayList<String> getGroceryList() {
        return groceryList;
    }

    public void printGroceryList() {
        System.out.println("You have " + groceryList.size() + " itmes in your grocery list");
        for (int i = 0; i < groceryList.size(); i++) {
            System.out.println((i+1) + ". " + groceryList.get(i));
        }
    }

    public void modifyGroceryItem(String currentItem, String newItem) {
        int position = findItem(currentItem);
        if (position >= 0) {
            modifyGroceryItem(position, newItem);
        }
    }

    private void modifyGroceryItem(int position, String newItem) {
        groceryList.set(position, newItem);
        System.out.println("Grocery item " + (position + 1) + " has been modified.");
    }

    public void removeGroceryItem(String item) {
        int position = findItem(item);
        if (position >= 0) {
            removeGroceryItem(position);
        }
    }

    private void removeGroceryItem(int position) {
        groceryList.remove(position);
    }

    private int findItem(String searchItem) {
        return groceryList.indexOf(searchItem);
    }

    public boolean onFile(String searchItem) {
        int position = findItem(searchItem);
        return position >= 0;
    }
}
```
3. 修改 Main.java
```
import java.util.ArrayList;
import java.util.Scanner;

public class Main {
    private static Scanner scanner = new Scanner(System.in);
    private static GroceryList groceryList = new GroceryList();

    public static void main(String[] args) {
        boolean quit = false;
        int choice = 0;

        printInstructions();
        while(!quit) {
            System.out.println("Enter your choice: ");
            choice = scanner.nextInt();
            scanner.nextLine();

            switch (choice) {
                case 0:
                    printInstructions();
                    break;
                case 1:
                    groceryList.printGroceryList();
                    break;
                case 2:
                    addItem();
                    break;
                case 3:
                    modifyItem();
                    break;
                case 4:
                    removeItem();
                    break;
                case 5:
                    searchForItem();
                    break;
                case 6:
                    processArrayList();
                case 7:
                    quit = true;
                    break;
            }
        }
    }

    public static void printInstructions() {
        System.out.println("\nPress ");
        System.out.println("\t 0 - To print choice options.");
        System.out.println("\t 1 - To print the list of grocery items.");
        System.out.println("\t 2 - To add an item to the list.");
        System.out.println("\t 3 - To modify an item in the list.");
        System.out.println("\t 4 - To remove an item from the list.");
        System.out.println("\t 5 - To search for an item in the list.");
        System.out.println("\t 6 - To quit the application.");
    }

    public static void addItem() {
        System.out.print("Please enter the grocery item: ");
        groceryList.addGroceryItem(scanner.nextLine());
    }

    public static void modifyItem() {
        System.out.print("Current item name: ");
        String itemNo = scanner.nextLine();
        System.out.print("Enter new item: ");
        String newItem = scanner.nextLine();
        groceryList.modifyGroceryItem(itemNo, newItem);
    }

    public static void removeItem() {
        System.out.print("Enter item name: ");
        String itemNo = scanner.nextLine();
        groceryList.removeGroceryItem(itemNo);
    }

    public static void searchForItem() {
        System.out.print("Item to search for: ");
        String searchItem = scanner.nextLine();
        if (groceryList.onFile(searchItem)) {
            System.out.println("Found " + searchItem + " in our grocery list");
        } else {
            System.out.println(searchItem + " is not in the shopping list");
        }
    }

    // 三種 複製 ArrayList 的方法
    public static void processArrayList() {
        ArrayList<String> newArray = new ArrayList<String>();
        newArray.addAll(groceryList.getGroceryList());

        ArrayList<String> nextArray = new ArrayList<String>(groceryList.getGroceryList());

        // 把 ArrayList 轉換成 Array
        String[] myArray = new String[groceryList.getGroceryList().size()];
        myArray = groceryList.getGroceryList().toArray(myArray);
    }
}
```
#### ArrayList 挑戰
1. 題目
    Create a program that implements a simple mobile phone with the following capabilities.
    Able to store, modify, remove and query contact names.
    You will want to create a separate class for Contacts (name and phone number).
    Create a master class (MobilePhone) that holds the ArrayList of Contacts
    The MobilePhone class has the functionality listed above.
    Add a menu of options that are available.
    Options: Quit, print list of contacts, add new contact, update existing contact, remove contact
    and search/find contact.
    When adding or updating be sure to check if the contact already exists (use name)
    Be sure not to expose the inner workings of the Arraylist to MobilePhone
    e.g. no ints, no .get(i) etc
    MobilePhone should do everything with Contact objects only.
2. 答案
    1. 新增 Contact.java
    ```
    public class Contact {
        private String name;
        private String phoneNumber;

        public Contact(String name, String phoneNumber) {
            this.name = name;
            this.phoneNumber = phoneNumber;
        }

        public String getName() {
            return name;
        }

        public String getPhoneNumber() {
            return phoneNumber;
        }

        public static Contact createContact(String name, String phoneNumber) {
            return new Contact(name, phoneNumber);
        }
    }
    ```
    2. 新增 MobilePhone.java
    ```
    import java.util.ArrayList;

    public class MobilePhone {
        private String myNumber;
        private ArrayList<Contact> myContacts;

        public MobilePhone(String myNumber) {
            this.myNumber = myNumber;
            this.myContacts = new ArrayList<Contact>();
        }

        public boolean addNewContact(Contact contact) {
            if (findContact(contact.getName()) >= 0) {
                System.out.println("Contact is already on file");
                return false;
            }

            myContacts.add(contact);
            return true;
        }

        public boolean updateContact(Contact oldContact, Contact newContact) {
            int foundPosition = findContact(oldContact);
            if (foundPosition < 0) {
                System.out.println(oldContact.getName() + ", was not found.");
                return false;
            } else if (findContact(newContact.getName()) != -1) {
                System.out.println("Contact with name " + newContact.getName() + " already exist. Update was not successful.");
                return false;
            }

            this.myContacts.set(foundPosition, newContact);
            System.out.println(oldContact.getName() + ", was replaced with " + newContact.getName());
            return true;
        }

        public boolean removeContact(Contact contact) {
            int foundPosition = findContact(contact);
            if (foundPosition < 0) {
                System.out.println(contact.getName() + ", was not found.");
                return false;
            }

            this.myContacts.remove(foundPosition);
            System.out.println(contact.getName() + ", was deleted.");
            return true;
        }

        private int findContact(Contact contact) {
            return this.myContacts.indexOf(contact);
        }

        private int findContact(String contactName) {
            for (int i = 0; i < this.myContacts.size(); i++) {
                Contact contact = this.myContacts.get(i);
                if (contact.getName().equals(contactName)) {
                    return i;
                }
            }
            return -1;
        }

        public Contact queryContact(String name) {
            int position = findContact(name);
            if (position >= 0) {
                return this.myContacts.get(position);
            }

            return null;
        }

        public void printContacts() {
            System.out.println("Contact List");
            for (int i = 0; i < this.myContacts.size(); i++) {
                System.out.println((i + 1) + "." + this.myContacts.get(i).getName() + " -> " + this.myContacts.get(i).getPhoneNumber());
            }
        }
    }
    ```
    3. 修改 Main.java
    ```
    import java.util.Scanner;

    public class Main {
        private static Scanner scanner = new Scanner(System.in);
        private static MobilePhone mobilePhone = new MobilePhone("0039 330 4404");

        public static void main(String[] args) {
            boolean quit = false;
            startPhone();
            printActions();
            while (!quit) {
                System.out.println("\nEnter action: (6 to show available actions)");
                int action = scanner.nextInt();
                scanner.nextLine();

                switch (action) {
                    case 0:
                        System.out.println("\nShutting down...");
                        quit = true;
                        break;
                    case 1:
                        mobilePhone.printContacts();
                        break;
                    case 2:
                        addNewContact();
                        break;
                    case 3:
                        updateContact();
                        break;
                    case 4:
                        removeContact();
                        break;
                    case 5:
                        queryContact();
                        break;
                    case 6:
                        printActions();
                        break;
                }
            }
        }

        private static void updateContact() {
            System.out.println("Enter existing contact name: ");
            String name = scanner.nextLine();
            Contact existingContactRecord = mobilePhone.queryContact(name);
            if (existingContactRecord == null) {
                System.out.println("Contact not found");
                return;
            }

            System.out.println("Enter new contact name: ");
            String newName = scanner.nextLine();
            System.out.println("Enter new contact phone number: ");
            String newNumber = scanner.nextLine();
            Contact newContact = Contact.createContact(newName, newNumber);
            if (mobilePhone.updateContact(existingContactRecord, newContact)) {
                System.out.println("Successfully updated record");
            } else {
                System.out.println("Error updating record");
            }
        }

        private static void removeContact() {
            System.out.println("Enter existing contact name: ");
            String name = scanner.nextLine();
            Contact existingContactRecord = mobilePhone.queryContact(name);
            if (existingContactRecord == null) {
                System.out.println("Contact not found");
                return;
            }

            if (mobilePhone.removeContact(existingContactRecord)) {
                System.out.println("Successfully deleted");
            } else {
                System.out.println("Error deleting contact");
            }
        }

        private static void queryContact() {
            System.out.println("Enter existing contact name: ");
            String name = scanner.nextLine();
            Contact existingContactRecord = mobilePhone.queryContact(name);
            if (existingContactRecord == null) {
                System.out.println("Contact not found");
                return;
            }

            System.out.println("Name: " + existingContactRecord.getName() + " phone number is " + existingContactRecord.getPhoneNumber());
        }

        private static void addNewContact() {
            System.out.println("Enter new contact name: ");
            String name = scanner.nextLine();
            System.out.println("Enter phone number: ");
            String phone = scanner.nextLine();
            Contact newContact = Contact.createContact(name, phone);
            if (mobilePhone.addNewContact(newContact)) {
                System.out.println("New contact added: " + name + ", phone = " + phone);
            } else {
                System.out.println("Cannot add, " + name + " already on file");
            }
        }

        private static void startPhone() {
            System.out.println("Starting phone...");
        }

        private static void printActions() {
            System.out.println("\nAvailable actions:\npress");
            System.out.println("0 - to shut down\n" +
                            "1 - to print contact\n" +
                            "2 - to add a new contact\n" +
                            "3 - to update an existing contact\n" +
                            "4 - to remove an existing contact\n" +
                            "5 - query of an existing contact exists\n" +
                            "6 - to print a list of available actions.");
            System.out.println("Choose your action: ");
        }
    }
    ```
3. 注意幾個 ArrayList 常用的方法
    - .add() 新增
    - .set() 編輯
    - .remove() 刪除
    - .indexOf() 找到對應內容的 index
    - .get() 找到 index 的對應內容
    - .size() 取得 ArrayList 的長度
#### Autoboxing 和 Unboxing
1. String 可以給 ArrayList 使用，因為 String 是一種 Class，而 int 是 primitive type，所以無法使用在 ArrayList，這時候我們需要把 int 包裝成一個 Class
```
String[] strArray = new String[10];
int[] intArray = new int[10];

ArrayList<String> strArrayList = new ArrayList<String>();
strArrayList.add("Tim");

// 以下會出錯
ArrayList<int> intArrayList = new ArrayList<int>();
```
2. 直接新增一個 Class 來包裝 Int
```
class IntClass {
    private int myValue;

    public IntClass(int myValue) {
        this.myValue = myValue;
    }

    public int getMyValue() {
        return myValue;
    }

    public void setMyValue(int myValue) {
        this.myValue = myValue;
    }
}

public class Main {

    public static void main(String[] args) {
        ArrayList<IntClass> intClassArrayList = new ArrayList<IntClass>();
        intClassArrayList.add(new IntClass(54));
    }
}
```
3. 新增 Class 太麻煩，可以用 Autoboxing 來達到一樣的目的，Autoboxing 就是一種 Wrapper
```
Integer integer = new Integer(54);
Double doubleValue = new Double(12.25);

ArrayList<Integer> intArrayList = new ArrayList<Integer>();
for (int i = 0;i <= 10; i++) {
    intArrayList.add(Integer.valueOf(i));
}

for (int i = 0;i <= 10; i++) {
    System.out.println(i + " --> " + intArrayList.get(i).intValue());
}
```
4. Double 的 Autoboxing 和 Unboxing 如下
```
// Autoboxing
Integer myIntValue = 56; // 等同於 Integer.valueOf(56)
// Unboxing
int myInt = myIntValue.intValue();

ArrayList<Double> myDoubleValues = new ArrayList<Double>();
for (double dbl = 0.0; dbl <= 10.0; dbl += 0.5) {
    myDoubleValues.add(Double.valueOf(dbl));
}

for (int i = 0; i < myDoubleValues.size(); i++) {
    double value = myDoubleValues.get(i).doubleValue();
    System.out.println(i + " --> " + value);
}
```
5. Autoboxing 和 Unboxing 還可以簡化
```
ArrayList<Double> myDoubleValues = new ArrayList<Double>();
for (double dbl = 0.0; dbl <= 10.0; dbl += 0.5) {
    myDoubleValues.add(dbl);
}

for (int i = 0; i < myDoubleValues.size(); i++) {
    double value = myDoubleValues.get(i);
    System.out.println(i + " --> " + value);
}
```