program test;

uses
  linkedlist;

type
  pData = ^TData;

  TData = record
    Next, prev: pData;
    msg: shortstring;
  end;

var
  list: ListBase;
  tmp, tmp2: pData;
  li: pData;
begin
  tmp := calloc(1, sizeof(TData));
  tmp^.msg := 'first';
  addtail(@list, tmp);

  tmp := malloc(sizeof(TData));
  tmp^.msg := 'second';
  addhead(@list, tmp);

  tmp2 := malloc(sizeof(TData));
  tmp2^.msg := 'third';
  insertlink(@list, tmp, tmp2);

  tmp2 := malloc(sizeof(TData));
  tmp2^.msg := 'fourth';
  insertlinkbefore(@list, tmp, tmp2);

  tmp := malloc(sizeof(TData));
  tmp^.msg := 'fifth';
  addtail(@list, tmp);

  remlink(@list, tmp);
  free(tmp);

  li := list.first;
  freelinkN(@list, li);

  li := list.First;

  while li <> nil do
  begin
    writeln(li^.msg);

    li := li^.Next;
  end;

  writeln;
  writeln(countlist(@list));

  freelist(@list);
end.
