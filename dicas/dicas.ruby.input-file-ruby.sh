How to Input a File in Ruby

Reading data from and writing data to a file are common tasks in programming.
The programming language Ruby has a number of methods which make it simple to
input a file.

Difficulty: Challenging

Instructions

    Input a File

 1. 1

    Identify the filename of the file you want and open it.

 2. 2

    Determine whether you want to read from the file, write to the file or
    both. If you want to read a file, pass "r" as the second argument to
    File.open. If you want to write, pass "w". To do both, pass "r+".

 3. 3

    Create a new File object with the File.open method and store the result in
    a variable:
    f = File.open("myfile.txt", "r")

 4. 4

    Use one of a number of methods for reading and writing the file. To read
    each line in order, you can use the each_line method, which takes a block
    as an argument, enclosed in do...end keywords, or {...} braces. Reading a
    file this way is similar to iterating over an array:
    f = File.open("myfile.txt", "r")
    f.each_line do|line|
    	puts "I read this line: #{line}"
    end

 5. 5

    Read individual strings for formatted data in a number of ways. After
    opening the file use the gets method to read a line and store the result in
    a variable:
    f = File.open("myfile.txt", "r")
    line = f.gets
    puts "The line I read is: #{line}"

    Utilize the Shortcuts

 6. 1

    Use the shortcut for the each_line method, the File.foreach method. This
    method opens the file and uses each_line without you having to open the
    file yourself. It also closes the file when it's finished:
	File.foreach("myfile.txt") do|line|
		puts "I read this line: #{line}"
	end

 7. 2

    Use the readlines method in situations where it would be easier to read all
    the lines of the file into an array. The readlines method returns an array
    of all the lines. The following example will open a file, read all the
    lines with readlines, then iterate over the returned array and print all
    the lines:

	f = File.open("myfile.txt", "r")
	lines = f.readlines
	lines.each do|line|
		puts "I read this line: #{line}"
	end

    Close the File

 8. 1

    Close the file with the close method. Remember to call the close method,
    otherwise the file might never be closed:
    f = File.open("myfile.txt", "r")
    # ... Do something with the file
    f.close

 9. 2

    Close it automatically if you don't need to keep the file open for very
    long. The File.open method can take a block as an argument.

10. 3

    Pass a block, and the file will be automatically closed at the end of the
    block. File.open will also return the result of the block if one is passed
    to it as a opposed to a file handle. Blocks automatically return the result
    of their last expression. In this example, File.open returns the result of
    the readlines method despite the fact that there is no return statement:
    lines = File.open("myfile.txt", "r") do|file|
    file.readlines
    end
