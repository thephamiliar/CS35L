The most difficult part of implementing the multithreading aspect of the project
was figuring out where to begin. For my lab, I multithreaded the part of the
main function that dealt with pixelating the picture and obtaining the color
arrays. I first had to make an argument structure that would hold all of the
threads arguments and the color arrays. The argument structure had to typedef
because when I declare it later in the program I wouldn't have to declare it as
a struct everytime. I then divided the work equally between all the threads and
create the threads with the thread function. However, figuring out how to divide
the work also posed a problem. I originally wanted to divide the work evenly
between the width and height, but the output produced did not pass the check
test. As a result, I divided the work with just the width. I also had to make
sure that the threads contained the whole picture and account for pictures that
are not evenly divided between the threads. Within the thread function, I made
global variables out of the camera, scene, pixel, and subsample variables since
they were constant throughout the process. Finally, I joined the threads and
printed out the color arrays. I had to make color arrays because when I tried to
print the pixels from within the thread function, it again produced the wrong
output. From the results of the make check clean test, the implementation of SRT
improves the performance by speeding the process about 2x with every 2^N
threads. Between 2 and 1 threads, the time spent was cut in half, and between 4
and 2 threads, the time spent jumped from 24 seconds to 16 seconds. 
