# Ufiles in Matlab

Matlab functions to read, write and use [Ufiles][1].

[1]: http://w3.pppl.gov/~pshare/help/ufiles_manual.html

## Getting started

Clone the repository, then add it to your matlab path.

For an example of usage, take a look at the [`example`][2] directory which contains
a sample 2d Ufile and a Matlab script where all the functions are used.

[2]: example/

## License

[MIT License][3]

[3]: LICENSE.txt

## Known bugs

- end of line comments are discarded when reading and replaced by standard ones
  when writing
- the numbers that come after the dimension are ignored and replaced by 0 and 6
  when writing since they are not described in the spec, I have no idea what
  they mean and they are 0 and 6 in all the Ufiles I have seen so far
- leading whitespace in units is not conserved
- leading whitespace in comments (at the end of the file) is not conserved
- there are virtually no consistency checks

Contributions are welcome :D
