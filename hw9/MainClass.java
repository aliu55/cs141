// ASHLEY LIU ashlel13

import static java.lang.Thread.sleep;
import java.io.*;
import java.util.Hashtable;

public class MainClass {
    public static OS141 instance;

    public static void main(String args[])
    {
        instance = OS141.getInstance();
        instance.configure(args);
        instance.startUserThreads();
        instance.joinUserThreads();
    }
}

class OS141 {
    private static OS141 instance;
    UserThread[] users;
    Disk[] disks;
    Printer[] printers;
    DiskManager diskManager;
    PrinterManager printerManager;

    private OS141 () {
    }

    public static OS141 getInstance() {
        if (instance == null)
            instance = new OS141();
        return instance;
    }

    void configure(String[] args) {
        int NUM_USERS = Integer.parseInt(args[0].substring(1));
        int NUM_DISKS = Integer.parseInt(args[1].substring(1));
        int NUM_PRINTERS = Integer.parseInt(args[2].substring(1));

        users = new UserThread[NUM_USERS];
        for (int i = 0; i < NUM_USERS; i++) {
            users[i] = new UserThread(i);
        }

        disks = new Disk[NUM_DISKS];
        for (int i = 0; i < NUM_DISKS; i++) {
            disks[i] = new Disk();
        }

        printers = new Printer[NUM_PRINTERS];
        for (int i = 0; i < NUM_PRINTERS; i++) {
            printers[i] = new Printer(i);
        }

        diskManager = new DiskManager(NUM_DISKS);
        printerManager = new PrinterManager(NUM_PRINTERS);

        // System.out.println(NUM_USERS + " " + NUM_DISKS + " " + NUM_PRINTERS);
    }

    void startUserThreads() {
        for (UserThread user : users)
        {
            user.start();
        }
    }

    void joinUserThreads() {
        // join: waits for the other thread to finish processing before executing the next method
        try {
            for (UserThread user : users)
            {
                user.join();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

class Printer {
    /**
     * Your implementation could differ!
     *  Member Variables:
     *      - file name
     *      - FileWriter object
     *      - BufferedWriter object
     *          - Look up how to use these two to write to files
     */

    String fileName;

    /**
     * Constructor:
     *  - Takes an int id that is used to create and store the file name
     */
    Printer(int id) {
        fileName = "PRINTER" + id;
    }

    /**
     * This is a class I used in my implementation for performance's sake. You do not need this class
     *
     * Initializes the filewriter and bufferwriter. This method is called from PrintJobThread.
     *  - Pass the file name and true to FileWriter(fileName, boolean)
     */
    // void initialize() {

    // }

    /**
     * Another method I wrote for myself.
     * Flushes the bufferwriter and closes it
     */
    // void cleanup() {
    // }

    /**
     * Writes the data to the bufferwriter. Just write the data and add a newline
     */
    void print(StringBuffer data) {
        try {
            FileWriter myWriter = new FileWriter(fileName, true);
            myWriter.write(data.toString());
            myWriter.write("\n");
            myWriter.flush();
            myWriter.close();
            sleep(275);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}


class Disk {
    /**
     * Member Variables:
     *  - a constant variable for the num of sectors in a disk
     *  - array of string buffers with the len of num of sectors
     *  - an int recording the latest free sector within the disk; this is my implementation not the professor's way
     *
     * Make any getters you need
     */
    static final int NUM_SECTORS = 2048;
    StringBuffer[] sectors; /* each sector stores a line from the file */
    int nextFreeSector;

    /**
     * Init member vars
     */
    public Disk() {
        sectors = new StringBuffer[NUM_SECTORS];
        nextFreeSector = 0;
    }

    /**
     * Write data to the latest free sector and update the latest free sector
     */
    void write(StringBuffer data) throws InterruptedException {
        sectors[nextFreeSector] = data;
        nextFreeSector++;
        sleep(80);
    }

    /**
     * Read the data from the given sector into the second parameter.
     */
    void read(int sector, StringBuffer data) throws InterruptedException {
        data.append(sectors[sector]);
        sleep(80);
    }

    int getNextFreeSector() {
        return nextFreeSector;
    }

}

/**
 * HashMap interface that maps filenames to FileInfo objects.
 */
class DirectoryManager {
    private Hashtable<String, FileInfo> fileDirectories = new Hashtable<String, FileInfo>();

    DirectoryManager()
    {
    }

    void enter(StringBuffer fileName, FileInfo file) {
        fileDirectories.put(fileName.toString(), file);
    }

    FileInfo lookup(StringBuffer fileName) {
        if (fileDirectories.containsKey(fileName.toString())) {
            return fileDirectories.get(fileName.toString());
        }
        return null;
    }
}

/**
 * Stores and intializes directory manager
 *      - only access the directory manager through here! Do not create more directory managers
 *
 */
class DiskManager extends ResourceManager {
    /**
     * Member Variables:
     *  - directory manager
     *
     * Create any getters you need
     */

    DirectoryManager directoryManager = new DirectoryManager();

    /**
     * Call the parent constructor, initialize a directory manager
     */
    DiskManager (int numDisks){
        super(numDisks);
    }

}

/**
 * Simple data class that holds:
 *  - disk number
 *  - startingSector
 *  - file length
 *
 *
 *  Create getters and setters as you need
 */
class FileInfo {
    int diskNumber;
    int startingSector;
    int fileLength;

    FileInfo(int diskNumber, int startingSector, int fileLength) {
        this.diskNumber = diskNumber;
        this.startingSector = startingSector;
        this.fileLength = fileLength;
    }
}

/**
 * Class that finds the next free printer
 */
class PrinterManager extends ResourceManager {

    /**
     * Takes number of printers and passes it to parent constructor
     */
    PrinterManager(int numPrinters){
        super(numPrinters);
    }
}

/**
 * Given
 * Try to understand what is going on in this class
 */
class ResourceManager {
    boolean[] isFree;

    ResourceManager(int numberOfItems) {
        isFree = new boolean[numberOfItems];
        for (int i = 0; i < isFree.length; ++i)
            isFree[i] = true;
    }

    synchronized int request() {
        while (true) {
            for (int i = 0; i < isFree.length; ++i)
                if (isFree[i]) {
                    isFree[i] = false;
                    return i;
                }
            try {
                this.wait();
            } catch (InterruptedException e){
                e.printStackTrace();
            }
        }
    }

    synchronized void release( int index ) {
        isFree[index] = true;
        this.notify();
    }
}

/**
 Reads a file and writes it to an available Disk.
 Request a disk to write to using diskManager.request() method.
 The request method will return an index of the first free disk, access the disk
 using the disks array in the Singleton instance.
 */
class UserThread extends Thread {

    String fileName;
    
    /**
     Takes a file name and saves it to the class
     */
    UserThread (int id) {
        this.fileName = "USER" + id;
    }


    /**
     Reads file and process user commands.
     General strategy is looping through each line and keeping track of what kind of command it is.
     According to the command, do the appropriate actions.
     Some useful java commands: substring and startsWith.

     If you request a resource, make sure to release it!! Or it will never free up.
     */

    @Override
    public void run() {
        processUserCommands();
    }

    private void processUserCommands() {

        // info about the file that is being written to
        int fileLength = 0;
        int startingSector = 0;
        StringBuffer fileToSave = new StringBuffer();
        
        int diskNumber = MainClass.instance.diskManager.request();
        Disk disk = MainClass.instance.disks[diskNumber];

        try {
            FileInputStream inputStream = new FileInputStream(fileName);
            BufferedReader myReader = new BufferedReader(new InputStreamReader(inputStream));
            
            for (String line; (line = myReader.readLine()) != null;) {
                if (line.startsWith(".save")) {
                    startingSector = disk.getNextFreeSector();
                    fileLength = 0;
                    fileToSave = getFileNameFromLine(line);
                    // System.out.println("SAVING FILE: " + fileToSave.toString());
                } else if (line.startsWith(".end")) {
                    FileInfo fileInfoObj = new FileInfo(diskNumber, startingSector, fileLength);
                    DirectoryManager directoryManager = MainClass.instance.diskManager.directoryManager;
                    directoryManager.enter(fileToSave, fileInfoObj);
                } else if (line.startsWith(".print")) {
                    StringBuffer fileToPrint = getFileNameFromLine(line);
                    PrintJobThread printJobThread = new PrintJobThread(fileToPrint);
                    printJobThread.start();
                } else { // line to be written to disk
                    disk.write(new StringBuffer(line));
                    fileLength++;
                }
            }
        
            MainClass.instance.diskManager.release(diskNumber);
            inputStream.close();

        } catch (Exception e) {
            e.printStackTrace();;
        }

    }

    private StringBuffer getFileNameFromLine(String line) {
        return new StringBuffer(line.split(" ")[1]);
    }
}

/**
 * Handles printing one file at a time. Files are stored in a certain disk. The FileInfo object has the info
 * for which disk the file is stored in. Using the starting disk sector and the file length, print line by line

 */
class PrintJobThread extends Thread {
    /**
     Member Variables:
     - file name -> file name that you are printing
     you will use this to find the fileinfo saved in the directory manager
     */

    StringBuffer fileToPrint;
    PrinterManager printerManager;

    /**
     Takes a file name that needs to be printed and saves it to be used later
     */
    PrintJobThread(StringBuffer fileName) {
        this.fileToPrint = fileName;
        printerManager = MainClass.instance.printerManager;
    }


    /**
     Read the file from the appropriate disk and sectors and print it using a free printer.

     You can read from any disk, without "requesting" it
     You must request a printer since multiple Print Jobs are running simultaneously
     To request a resource (Disk or Printer), simply call the .request method on the DiskManager or PrinterManager.
     The request method will return the index of the free resource. You can use that index to access the Disk or Printer
     from the disks and printers array in the mainclass.
     Remember to access everything from the Singleton instance i.e something like MainClass.getInstance().get...()

     If you request a resource, make sure to release it!! Or it will never free up.


     */
    @Override
    public void run()
    {
        // get printer
        int printerNumber = printerManager.request();
        Printer printer = MainClass.instance.printers[printerNumber];

        // System.out.println("REQUESTED PRINTER: " + printerNumber);
        
        // get fileInfoObj
        DirectoryManager directoryManager = MainClass.instance.diskManager.directoryManager;
        FileInfo file = directoryManager.lookup(fileToPrint);

        // get disk
        int diskNumber = file.diskNumber;
        Disk disk = MainClass.instance.disks[diskNumber];

        writeFileFromDiskToPrinter(file, disk, printer);

        printerManager.release(printerNumber);
    }

    private void writeFileFromDiskToPrinter(FileInfo file, Disk disk, Printer printer) {
        try {
            for (int i = file.startingSector; i < file.startingSector + file.fileLength; i++) {
                StringBuffer data = new StringBuffer();
                disk.read(i, data);
                printer.print(data);
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}

