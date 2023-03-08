// ASHLEY LIU ashlel13

import java.io.*;
import java.util.Hashtable;

import static java.lang.Thread.sleep;

class Disk
        // extends Thread
{
    static final int NUM_SECTORS = 2048;
    StringBuffer sectors[];

    Disk() {
        sectors = new StringBuffer[NUM_SECTORS];
    }

    void write(int sector, StringBuffer data) throws InterruptedException {
        sectors[sector] = data;
        sleep(800);
    }
    void read(int sector, StringBuffer data) throws InterruptedException {
        data.append(sectors[sector]);
        sleep(800);
    }
}

class Printer
        // extends Thread
{
    int id;
    FileWriter myWriter;

    Printer(int id) throws IOException {
        this.id = id;
         myWriter = new FileWriter("PRINTER" + id, true);
    }

    void print(StringBuffer data) throws InterruptedException, IOException {
//        System.out.println("PRINT DATA: " + data.toString());
        myWriter.write(data.toString());
        myWriter.write("\n");
        sleep(2750);
    }

    FileWriter getWriter() {
        return myWriter;
    }
}

class PrintJobThread extends Thread {
    StringBuffer line = new StringBuffer(); // only allowed one line to reuse for read from disk and print to printer

    PrintJobThread(String fileToPrint)
    {
    }

    public void run()
    {
    }
}

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
 * Tracks where files are stored on disk via mapping file names to FileInfo objects
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

class ResourceManager
{
    boolean isFree[];
    ResourceManager(int numberOfItems) {
        isFree = new boolean[numberOfItems];
        for (int i=0; i<isFree.length; ++i)
            isFree[i] = true;
    }

    synchronized int request() {
        while (true) {
            for (int i = 0; i < isFree.length; ++i)
                if ( isFree[i] ) {
                    isFree[i] = false;
                    return i;
                }
            try {
                this.wait(); // block until someone releases Resource
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    synchronized void release( int index ) {
        isFree[index] = true;
        this.notify(); // let a blocked thread run
    }
}

/**
 * Finds the next free sector on each disk (used to save files)
 * Creates and stores a DirectoryManager for finding file sectors on Disk
 */
class DiskManager extends ResourceManager {
    DiskManager(int numDisks) {
        super(numDisks);
    }
}

/**
 * Finds the next free printer
 */
class PrinterManager extends ResourceManager {
    PrinterManager(int numPrinters) {
        super(numPrinters);
    }
}

class UserThread extends Thread
{
    String INPUT_FILE = "USER";
    int id;

    UserThread(int id)
    {
        this.id = id;
    }

    public void run()
    {
        int diskNumber = 0;
        int fileLength = 0;
        int startingSector = 0;
        StringBuffer fileName = new StringBuffer();
        DirectoryManager directoryManager = new DirectoryManager();
        Disk disk = new Disk();
        Printer printer = null;
        try {
            printer = new Printer(0);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

        try {
            FileInputStream inputStream = new FileInputStream(INPUT_FILE + id);
            BufferedReader myReader = new BufferedReader(new InputStreamReader(inputStream));


            for (String line; (line = myReader.readLine()) != null;)
            {
                if (line.startsWith(".save"))
                {
//                    System.out.println(".save");
                    startingSector = fileLength;
                    fileLength = 0;
                    fileName = new StringBuffer(line.split(" ")[1]);
                }
                else if (line.startsWith(".end"))
                {
//                    System.out.println(".end");
                    FileInfo fileInfoObj = new FileInfo(diskNumber, startingSector, fileLength);
                    startingSector += fileLength;
                    directoryManager.enter(fileName, fileInfoObj);
                }
                else if (line.startsWith(".print"))
                {
//                    System.out.println(".print");
                    fileName = new StringBuffer(line.split(" ")[1]);
                    FileInfo fileInfoObj = directoryManager.lookup(fileName);

                    for (int i = fileInfoObj.startingSector; i < fileInfoObj.startingSector + fileInfoObj.fileLength; i++) {
                        StringBuffer data = new StringBuffer();
                        disk.read(i, data);
                        printer.print(data);
                    }
                }
                else // line to be written to the disk
                {
                    int sector = startingSector + fileLength;
                    disk.write(sector, new StringBuffer(line));
                    fileLength += 1;
                }
            }

            printer.getWriter().close();
            inputStream.close();
        } catch (Exception e) { e.printStackTrace(); }
    }
}


public class MainClass
{
    public static void main(String args[])
    {
//        for (int i=0; i<args.length; ++i)
//            System.out.println("Args[" + i + "] = " + args[i]);
//
//        System.out.println("*** 141 OS Simulation ***");

        UserThread user = new UserThread(0);
        user.run();
    }
}
