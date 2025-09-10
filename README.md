# linkedlist

A simple **doubly linked list implementation** for FreePascal.  
This code was originally taken from **Blender 1.72** and later ported by Darius Blaszyk.  
It provides basic list operations such as adding, removing, inserting, and freeing nodes.


## Features

- Doubly linked list structure (`next` and `prev` pointers).
- Basic memory management (`malloc`, `calloc`, `free`).
- Core list operations:
  - Add to head (`addhead`) or tail (`addtail`)
  - Remove a node (`remlink`, `freelinkN`)
  - Insert before/after a given node (`insertlink`, `insertlinkbefore`)
  - Count nodes (`countlist`)
  - Free the entire list (`freelist`)

## Usage

Define your own record type with `next` and `prev` fields as the first two members, for compatibility with the linked list API:

```pascal
type
  pData = ^TData;
  TData = record
    next, prev: pData;     // must match linkedlist expectations
    msg: shortstring;      // your custom data
  end;
````

Allocate and add nodes:

```pascal
var
  list: ListBase;
  node: pData;
begin
  list.first := nil;
  list.last := nil;

  node := calloc(1, sizeof(TData));
  node^.msg := 'Hello, world!';
  addtail(@list, node);

  writeln(countlist(@list)); // prints 1

  freelist(@list); // cleanup
end;
```

## Installation

### With Nova package manager

If you are using [Nova](https://github.com/daar/nova), you can install directly:

```sh
nova install daar/linkedlist
```

Then include it in your project:

```pascal
uses
  linkedlist;
```

## License

This code is dual-licensed under the **GNU GPL v2** or later and the **Blender License 1.0**.
See the file header for details.

```