# nvtt
A neovim typing test

## Things to note:
Uses the file you're currenty in as the test, so you can practice writing code and such in the most realistic way possible, within the same tool you'll be writing it in

Sets buftype=nofile, so don't worry, it won't change the file at all

Test ends when you get the end of the file, but you can specify amount of seconds as an argument (:NVTT 60 for one minute), and it will take you back to the top if you get to the end of the file before the timer finishes

Removes all auto indentation

Type :NVTT to start
