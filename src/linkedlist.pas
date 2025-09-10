(*
 * This code is originally taken from Blender 1.72 and ported by Darius Blaszyk
 * to freepascal. The code implements a basic linkedlist.
 *)

(**
 * $Id:$
 * ***** BEGIN GPL/BL DUAL LICENSE BLOCK *****
 *
 * The contents of this file may be used under the terms of either the GNU
 * General Public License Version 2 or later (the 'GPL', see
 * http://www.gnu.org/licenses/gpl.html ), or the Blender License 1.0 or
 * later (the 'BL', see http://www.blender.org/BL/ ) which has to be
 * bought from the Blender Foundation to become active, in which  the
 * above mentioned GPL option does not apply.
 *
 * The Original Code is Copyright (C) 2002 by NaN Holding BV.
 * All rights reserved.
 *
 * The Original Code is: all of this file.
 *
 * Contributor(s): none yet.
 *
 * ***** END GPL/BL DUAL LICENSE BLOCK *****
 *)

unit linkedlist;

{$mode objfpc}{$H+}

interface

type
  pLink = ^Link;

  Link = record
    next, prev: ^Link;
  end;

  pListBase = ^ListBase;

  ListBase = record
    first, last: pointer;
  end;

{
  Allocates memory for a raw pointer and returns it.
  ptr: pointer to be freed
}
procedure free(ptr: pointer);

{
  Allocates a block of memory of the given size.
  size: number of bytes to allocate
  Returns pointer to the allocated memory
}
function malloc(size: ptruint): pointer;

{
  Allocates and clears memory for an array of elements.
  num: number of elements
  size: size of each element
  Returns pointer to zero-initialized memory
}
function calloc(num, size: ptruint): pointer;

{
  Adds a link/node to the head of the list.
  listbase: pointer to the list
  vlink: pointer to the link to add
}
procedure addhead(listbase: pListBase; vlink: pointer);

{
  Adds a link/node to the tail of the list.
  listbase: pointer to the list
  vlink: pointer to the link to add
}
procedure addtail(listbase: pListBase; vlink: pointer);

{
  Returns the number of nodes in the list.
  listbase: pointer to the list
  Returns: count of nodes
}
function countlist(listbase: pListBase): longint;

{
  Removes a specific link from the list and frees it.
  listbase: pointer to the list
  vlink: pointer to the link to remove and free
}
procedure freelinkN(listbase: pListBase; vlink: pointer);

{
  Frees all nodes in the list and resets list pointers.
  listbase: pointer to the list
}
procedure freelist(listbase: pListBase);

{
  Inserts a new link after a given link in the list.
  listbase: pointer to the list
  vprevlink: link after which to insert (nil inserts at head)
  vnewlink: link to insert
}
procedure insertlink(listbase: pListBase; vprevlink, vnewlink: pointer);

{
  Inserts a new link before a given link in the list.
  listbase: pointer to the list
  vnextlink: link before which to insert (nil inserts at tail)
  vnewlink: link to insert
}
procedure insertlinkbefore(listbase: pListBase; vnextlink, vnewlink: pointer);

{
  Removes a link from the list without freeing its memory.
  listbase: pointer to the list
  vlink: link to remove
}
procedure remlink(listbase: pListBase; vlink: pointer);

implementation

procedure free(ptr: pointer);
begin
  finalize(ptr);
  freemem(ptr);
end;

function malloc(size: ptruint): pointer;
var
  p: pointer;
begin
  p := getmem(size);
  Initialize(p);
  exit(p);
end;

function calloc(num, size: ptruint): pointer;
var
  p: Pointer;
begin
  p := malloc(num * size);
  fillchar(p^, num * size, #0);
  exit(p);
end;

procedure addhead(listbase: pListBase; vlink: pointer);
var
  link: pLink;
begin
  link := vlink;

  if (link = nil) then
    exit;
  if (listbase = nil) then
    exit;

  link^.next := listbase^.first;
  link^.prev := nil;

  if (listbase^.first <> nil) then
    pLink(listbase^.first)^.prev := link;
  if (listbase^.last = nil) then
    listbase^.last := link;
  listbase^.first := link;
end;

procedure addtail(listbase: pListBase; vlink: pointer);
var
  link: pLink;
begin
  link := vlink;

  if (link = nil) then
    exit;
  if (listbase = nil) then
    exit;

  link^.next := nil;
  link^.prev := listbase^.last;

  if (listbase^.last <> nil) then
    pLink(listbase^.last)^.next := link;
  if (listbase^.first = nil) then
    listbase^.first := link;
  listbase^.last := link;
end;

procedure remlink(listbase: pListBase; vlink: pointer);
var
  link: pLink;
begin
  link := vlink;

  if (link = nil) then
    exit;
  if (listbase = nil) then
    exit;

  if (link^.next <> nil) then
    link^.next^.prev := link^.prev;
  if (link^.prev <> nil) then
    link^.prev^.next := link^.next;

  if (listbase^.last = link) then
    listbase^.last := link^.prev;
  if (listbase^.first = link) then
    listbase^.first := link^.next;
end;

procedure freelinkN(listbase: pListBase; vlink: pointer);
var
  link: pLink;
begin
  link := vlink;

  if (link = nil) then
    exit;
  if (listbase = nil) then
    exit;

  remlink(listbase, link);
  free(link);
end;

procedure insertlink(listbase: pListBase; vprevlink, vnewlink: pointer);
var
  prevlink, newlink: pLink;
begin
  newlink := pLink(vnewlink);
  prevlink := pLink(vprevlink);

  (* newlink is after prevlink *)

  if (newlink = nil) then
    exit;
  if (listbase = nil) then
    exit;

  if (listbase^.first = nil) then
  begin  (* empty list *)
    listbase^.first := newlink;
    listbase^.last := newlink;
    exit;
  end;
  if (prevlink = nil) then
  begin  (* insert before first element *)
    newlink^.next := listbase^.first;
    newlink^.prev := nil;
    newlink^.next^.prev := newlink;
    listbase^.first := newlink;
    exit;
  end;

  if (listbase^.last = prevlink) then (* end of the list *)
    listbase^.last := newlink;

  newlink^.next := prevlink^.next;
  prevlink^.next := newlink;
  if (newlink^.next <> nil) then
    newlink^.next^.prev := newlink;
  newlink^.prev := prevlink;
end;

procedure insertlinkbefore(listbase: pListBase; vnextlink, vnewlink: pointer);
var
  nextlink, newlink: pLink;
begin
  newlink := pLink(vnewlink);
  nextlink := pLink(vnextlink);

  (* newlink before nextlink *)

  if (newlink = nil) then
    exit;
  if (listbase = nil) then
    exit;

  if (listbase^.first = nil) then
  begin  (* empty list *)
    listbase^.first := newlink;
    listbase^.last := newlink;
    exit;
  end;
  if (nextlink = nil) then
  begin  (* insert at the end of the list *)
    newlink^.prev := listbase^.last;
    newlink^.next := nil;
    pLink(listbase^.last)^.next := newlink;
    listbase^.last := newlink;
    exit;
  end;

  if (listbase^.first = nextlink) then (* begining of the list *)
    listbase^.first := newlink;

  newlink^.next := nextlink;
  newlink^.prev := nextlink^.prev;
  nextlink^.prev := newlink;
  if (newlink^.prev <> nil) then
    newlink^.prev^.next := newlink;
end;

procedure freelist(listbase: pListBase);
var
  link, next: pLink;
begin
  if (listbase = nil) then
    exit;
  link := listbase^.first;
  while (link <> nil) do
  begin
    next := link^.next;
    free(link);
    link := next;
  end;
  listbase^.first := nil;
  listbase^.last := nil;
end;

function countlist(listbase: pListBase): longint;
var
  link: pLink;
  Count: longint = 0;
begin

  if (listbase <> nil) then
  begin
    link := listbase^.first;
    while (link <> nil) do
    begin
      Inc(Count);
      link := link^.next;
    end;
  end;
  exit(Count);
end;

end.
