FileCharLicker
====

library for Ruby.

it has the following functions.

- move the position of file pointer in character-based.
- get string that is around the file pointer.
- support for multi-byte character.


## Installation

```ruby
gem install file_char_picker
```

## Usage

### attach (setup)

at first, you must set up incetance of File object before use features of _FileCharLicker_ .

```ruby
file = open(path)
FileLineSeeker.attach(file, encoding)
```

the argument of _file_ is instance of File object that you want to use features of _FileCharLicker_ .

you can pass String object that is 'utf8', 'eucjp', 'jis', 'sjis' or each prefix. if you pass _nil_ or does not pass, the instance set up for ascii character.

you can use the following instance methods after setup.

### around_lines

```ruby
file.around_lines(needle)
```

get string around the position of file pointer that matched _needle_ argument. you can pass to _needle_ argument as String object or Regexp object.

if does not exist the matched string around the position of file pointer, return empty string.

I assume that the position of file pointer is start of line in run.

### backward_char

```ruby
file.backward_char
```

get a character that a character before the position of file pointer. mainly, may use to multi-byte character.

if does not exist before a character, return _nil_ .

### backward_lines

```ruby
file.backward_lines(size)
```

get string for lines before the position of file pointer. the _size_ argument is number of lines. if reach to beginning of file (BOF) in advance of _size_ number, return string until BOF.

I assume that the position of file pointer is start of line in run.

### current_line

```ruby
file.current_line
```

get string that is a line of the position of file pointer.

### forward_lines

```ruby
file.forward_lines(size)
```

get string for lines after the position of file pointer. the _size_ argument is number of lines. if reach to end of file (EOF) in advance of _size_ number, return string until EOF.

I assume that the position of file pointer is start of line in run.

### seek_contiguous_min

```ruby
file.scan_contiguous_min(needle)
```

move the position of file pointer to the start of line that matched the _needle_ argument. the line is contiguous and backward line from the file pointer at run. you can pass to _needle_ argument as String object or Regexp object.

return Integer object for the position of file pointer if succeed to move. else return nil.

I assume that the position of file pointer is start of line in run.

### seek_contiguous_max(*args)

```ruby
file.scan_contiguous_min(needle)
```

move the position of file pointer to the end of line that matched the _needle_ argument. the line is contiguous and forward line from the file pointer at run. you can pass to _needle_ argument as String object or Regexp object.

return Integer object for the position of file pointer if succeed to move. else return nil.

I assume that the position of file pointer is start of line in run.

### seek_line_head

```ruby
file.seek_line_head
```

move the position of file pointer to the head of line.

## Author

[indeep-xyz](http://indeep.xyz/)