# delete from start to main function
1,/<main>/d
# delete from end of main to end of file
/<main_test>/,$d
# delete the junk at the start of the lines
s/^...............................//
/^    b/d

# unfortunately, this stuff needs to be done any time addresses move around
s/8697(%rip)/$0x4022000000000000/
