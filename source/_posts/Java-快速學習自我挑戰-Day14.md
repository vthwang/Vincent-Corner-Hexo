---
title: Java 快速學習自我挑戰 Day14
thumbnail:
  - /images/learning/java/JavaDay14.jpg
toc: true
date: 2021-03-15 22:13:53
categories: Study Note
tags: Java
---
<img src="/images/learning/java/JavaDay14.jpg">

***
### Arrays、Java 內建 List、Autoboxing 和 Unboxing
#### LinkedList
1. LinkedList 是另外一種型態的 List。
2. Java 會為整數分配 4 位元的記憶體，基本上記憶體會連續排列，圖中可以看到 position 0 的位址是 100，position 1 的位址是 104，如果我想要找到 position 3 的位址，就 3*4=12，得知 position 3 的位址是 112。Double 則會分配 8 位元的記憶體。
<img src="/images/learning/java/JavaDay14-Image01.png" width="400">

3. String 跟原始型別不一樣，它的長度是可變的。圖中可以看到 String 的 Address 佔用的也是 8 位元的記憶體，但是他會指向 String 的位置。Java 最後可以追蹤到 String 所在的位置，並讀取它。最後圖中會讀取出來的 String 是 Tim Australia Java Hello World Done Array ArrayList。最後當程式停止之後，這些變數不需要了，會自動啟動一個 Java Garbage Collection 的程序，最後釋放記憶體。最後重要的一點是，String 的位址不一定要是連續的，就像 4000 跟其他數字差非常遠。
<img src="/images/learning/java/JavaDay14-Image02.png">

4. 新增 Customer.java
```
public class Customer {
    private String name;
    private double balance;

    public Customer(String name, double balance) {
        this.name = name;
        this.balance = balance;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getBalance() {
        return balance;
    }

    public void setBalance(double balance) {
        this.balance = balance;
    }
}
```
5. 修改 Main.java
```
public static void main(String[] args) {
    Customer customer = new Customer("Tim", 54.96);
    Customer anotherCustomer;
    anotherCustomer = customer;
    anotherCustomer.setBalance(12.18);
    System.out.println("Balance for customer " + customer.getName() + " is " + customer.getBalance());
}
```
6. 上面的輸出結果是 `Balance for customer Tim is 12.18`，為什麼修改 anotherCustomer 會影響到一開始的 customer 呢？因為指定 anotherCustomer = customer 的時候，他會指向同一個記憶體，最後修改 balance 的時候，其實是同一個地方，所以輸出的結果會是被修改後的 balance。
7. 最下面的迴圈使用 add 之後，會出現 1, 2, 3, 4，原因是在 position 1 插入 2 之後，會將現有的值往後移動。
```
public static void main(String[] args) {
    ArrayList<Integer> intList = new ArrayList<Integer>();

    intList.add(1);
    intList.add(3);
    intList.add(4);

    for (int i = 0; i < intList.size(); i++) {
        System.out.println(i + ": " + intList.get(i));
    }

    intList.add(1, 2);

    for (int i = 0; i < intList.size(); i++) {
        System.out.println(i + ": " + intList.get(i));
}
```
8. LinkedList 在新增的時候，可以直接修改對應的位址，讓 LinkedList 直接插入在中間，移除也一樣，直接將對應的值改成下一個值，Java 就會自動把沒有背對應到的值放在 Java Garbage Collection。
<img src="/images/learning/java/JavaDay14-Image03.png">
<img src="/images/learning/java/JavaDay14-Image04.png">

9. 新增 Demo.java，這邊可以測試出新增和刪除所出現的內容和排序，使用 Iterator 來進行迴圈功能。
```
public class Demo {
    public static void main(String[] args) {
        LinkedList<String> placesToVisit = new LinkedList<String>();
        placesToVisit.add("Sydney");
        placesToVisit.add("Melbourne");
        placesToVisit.add("Brisbane");
        placesToVisit.add("Perth");
        placesToVisit.add("Canberra");
        placesToVisit.add("Adelaide");
        placesToVisit.add("Darwin");

        printList(placesToVisit);

        placesToVisit.add(1, "Alice Springs");
        printList(placesToVisit);

        placesToVisit.remove(4);
        printList(placesToVisit);
    }

    private static void printList(LinkedList<String> linkedList) {
        Iterator<String> i = linkedList.iterator();
        while (i.hasNext()) {
            System.out.println("Now visiting " + i.next());
        }
        System.out.println("===========================");
    }
}
```
10. 將 cities 都列出，如果換方向的話，就會重複出現地名，所以我們這邊會使用 goingForward 來確定查詢的方向，避免方向不同而出現重複地名的問題。
```
public class Demo {
    public static void main(String[] args) {
        LinkedList<String> placesToVisit = new LinkedList<String>();
        addInOrder(placesToVisit, "Sydney");
        addInOrder(placesToVisit, "Melbourne");
        addInOrder(placesToVisit, "Brisbane");
        addInOrder(placesToVisit, "Perth");
        addInOrder(placesToVisit, "Canberra");
        addInOrder(placesToVisit, "Adelaide");
        addInOrder(placesToVisit, "Darwin");

        printList(placesToVisit);

        addInOrder(placesToVisit, "Alice Springs");
        addInOrder(placesToVisit, "Darwin");

        printList(placesToVisit);

        visit(placesToVisit);
    }

    private static void printList(LinkedList<String> linkedList) {
        Iterator<String> i = linkedList.iterator();
        while (i.hasNext()) {
            System.out.println("Now visiting " + i.next());
        }
        System.out.println("===========================");
    }

    private static boolean addInOrder(LinkedList<String> linkedList, String newCity) {
        ListIterator<String> stringListIterator = linkedList.listIterator();

        while (stringListIterator.hasNext()) {
            int comparison = stringListIterator.next().compareTo(newCity);
            if (comparison == 0) {
                // equal, do not add
                System.out.println(newCity + " is already included as a destination");
                return false;
            } else if (comparison > 0) {
                // new City should appear before this one
                // Brisbane -> Adelaide
                stringListIterator.previous();
                stringListIterator.add(newCity);
                return true;
            } else if (comparison < 0) {
                // move on next city
            }
        }

        stringListIterator.add(newCity);
        return true;
    }

    private static void visit(LinkedList<String> cities) {
        Scanner scanner = new Scanner(System.in);
        boolean quit = false;
        boolean goingForward = true;
        ListIterator<String> listIterator = cities.listIterator();

        if (cities.isEmpty()) {
            System.out.println("No cities in the itinerary");
            return;
        } else {
            System.out.println("Now visiting " + listIterator.next());
            printMenu();
        }

        while (!quit) {
            int action = scanner.nextInt();
            scanner.nextLine();
            switch (action) {
                case 0:
                    System.out.println("Holiday (Vacation) over");
                    quit = true;
                    break;

                case 1:
                    if (!goingForward) {
                        if (listIterator.hasNext()) {
                            listIterator.next();
                        }
                        goingForward = true;
                    }
                    if (listIterator.hasNext()) {
                        System.out.println("Now visiting " + listIterator.next());
                    } else {
                        System.out.println("Reached the end of the list");
                        goingForward = false;
                    }
                    break;

                case 2:
                    if (goingForward) {
                        if (listIterator.hasPrevious()) {
                            listIterator.previous();
                        }
                        goingForward = false;
                    }
                    if (listIterator.hasPrevious()) {
                        System.out.println("Now visiting " + listIterator.previous());
                    } else {
                        System.out.println("We are at the start of the list");
                        goingForward = true;
                    }
                    break;

                case 3:
                    printMenu();
                    break;
            }
        }
    }

    private static void printMenu() {
        System.out.println("Available actions:\npress");
        System.out.println("0 - to quit\n" + "1 - go to next city\n" + "2 - go to previous city\n" + "3 - print menu cities");
    }
}
```
#### LinkedList 挑戰
1. 題目
    Create a program that implements a playlist of songs.
    To start you off, implement the following classes:
    1.  Album
        -  It has three fields, two Strings called name and artist, and an ArrayList that holds objects of type Song called songs.
        -  A constructor that accepts two Strings (name of the album and artist). It initialises the fields and instantiates songs.
        -  And three methods, they are:
            -  addSong(), has two parameters of type String (title of song), double (duration of song) and returns a boolean. Returns true if the song was added successfully or false otherwise.
            -  findSong(), has one parameter of type String (title of song) and returns a Song. Returns the Song if it exists, null if it doesn't exists.
            -  addToPlayList(), has two parameters of type int (track number of song in album) and LinkedList (the playlist) that holds objects of type Song, and returns a boolean. Returns true if it exists and it was added successfully using the track number, or false otherwise.
            -  addToPlayList(), has two parameters of type String (title of song) and LinkedList (the playlist) that holds objects of type Song, and returns a boolean. Returns true if it exists and it was added successfully using the name of the song, or false otherwise.
    2.  Song
        -   It has two fields, a String called title and a double called duration.
        -  A constructor that accepts a String (title of the song) and a double (duration of the song). It initialises title and duration.
        -  And two methods, they are:
            -  getTitle(), getter for title.
            -  toString(), Songs overriding toString method. Returns a String in the following format: "title: duration"
    ->  SAMPLE INPUT
    ```
    ArrayList<Album> albums = new ArrayList<>();

    Album album = new Album("Stormbringer", "Deep Purple");
    album.addSong("Stormbringer", 4.6);
    album.addSong("Love don't mean a thing", 4.22);
    album.addSong("Holy man", 4.3);
    album.addSong("Hold on", 5.6);
    album.addSong("Lady double dealer", 3.21);
    album.addSong("You can't do it right", 6.23);
    album.addSong("High ball shooter", 4.27);
    album.addSong("The gypsy", 4.2);
    album.addSong("Soldier of fortune", 3.13);
    albums.add(album);

    album = new Album("For those about to rock", "AC/DC");
    album.addSong("For those about to rock", 5.44);
    album.addSong("I put the finger on you", 3.25);
    album.addSong("Lets go", 3.45);
    album.addSong("Inject the venom", 3.33);
    album.addSong("Snowballed", 4.51);
    album.addSong("Evil walks", 3.45);
    album.addSong("C.O.D.", 5.25);
    album.addSong("Breaking the rules", 5.32);
    album.addSong("Night of the long knives", 5.12);
    albums.add(album);

    LinkedList<Song> playList = new LinkedList<Song>();
    albums.get(0).addToPlayList("You can't do it right", playList);
    albums.get(0).addToPlayList("Holy man", playList);
    albums.get(0).addToPlayList("Speed king", playList);  // Does not exist
    albums.get(0).addToPlayList(9, playList);
    albums.get(1).addToPlayList(3, playList);
    albums.get(1).addToPlayList(2, playList);
    albums.get(1).addToPlayList(24, playList);  // There is no track 24
    ```
    TIP:  In Album, use the findSong() method in addSong() and addToPlayList(String, LinkedList) to check if a song exists before proceeding.
    TIP:  Be extremely careful with the spelling of the names of the fields, constructors and methods.
    TIP:  Be extremely careful about spaces and spelling in the returned String from the toString() method.
    NOTE:  All fields are private.
    NOTE:  All constructors are public.
    NOTE:  All methods are public (except for findSong() which is private). 
    NOTE:  There are no static members.
    NOTE:  Do not add a main method to the solution code.
    NOTE:  If you get an error from the Evaluate class, it's most likely the constructor. Check if you've added a constructor or if the constructor has the right arguments.
2. 答案
    - 新增 Album.java
    ```
    import java.util.ArrayList;
    import java.util.LinkedList;

    public class Album {
        private String name;
        private String artist;
        private ArrayList<Song> songs;

        public Album(String name, String artist) {
            this.name = name;
            this.artist = artist;
            this.songs = new ArrayList<Song>();
        }

        public boolean addSong(String title, double duration) {
            if (findSong(title) == null) {
                this.songs.add(new Song(title, duration));
                return true;
            }
            return false;
        }

        private Song findSong(String title) {
            for (Song checkedSong: this.songs) {
                if (checkedSong.getTitle().equals(title)) {
                    return checkedSong;
                }
            }
            return null;
        }

        public boolean addToPlayList(int trackNumber, LinkedList<Song> playlist) {
            int index = trackNumber - 1;
            if ((index >= 0) && (index <= this.songs.size())) {
                playlist.add(this.songs.get(index));
                return true;
            }
            return false;
        }

        public boolean addToPlayList(String title, LinkedList<Song> playlist) {
            Song checkedSong = findSong(title);
            if (checkedSong != null) {
                playlist.add(checkedSong);
                return true;
            }
            return false;
        }
    }
    ```
    - 新增 Song.java
    ```
    public class Song {
        private String title;
        private double duration;

        public Song(String title, double duration) {
            this.title = title;
            this.duration = duration;
        }

        public String getTitle() {
            return title;
        }

        @Override
        public String toString() {
            return this.title + ": " + this.duration;
        }
    }
    ```


