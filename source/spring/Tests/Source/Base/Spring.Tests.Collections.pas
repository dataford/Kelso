{***************************************************************************}
{                                                                           }
{           Spring Framework for Delphi                                     }
{                                                                           }
{           Copyright (c) 2009-2013 Spring4D Team                           }
{                                                                           }
{           http://www.spring4d.org                                         }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  Licensed under the Apache License, Version 2.0 (the "License");          }
{  you may not use this file except in compliance with the License.         }
{  You may obtain a copy of the License at                                  }
{                                                                           }
{      http://www.apache.org/licenses/LICENSE-2.0                           }
{                                                                           }
{  Unless required by applicable law or agreed to in writing, software      }
{  distributed under the License is distributed on an "AS IS" BASIS,        }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{  See the License for the specific language governing permissions and      }
{  limitations under the License.                                           }
{                                                                           }
{***************************************************************************}

unit Spring.Tests.Collections;

{$I Spring.inc}

interface

uses
  TestFramework,
  Spring.TestUtils,
  Spring,
  Spring.Collections;

type
  TTestEmptyHashSet = class(TTestCase)
  private
    fSet: ISet<Integer>;
    fEmpty: ISet<Integer>;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestEmpty;
    procedure TestAddDuplications;
    procedure TestExceptWith;
    procedure TestIntersectWith;
    procedure TestUnionWith;
    procedure TestSetEquals;
  end;

  TTestNormalHashSet = class(TTestCase)
  private
    fSet1: ISet<Integer>;
    fSet2: ISet<Integer>;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    procedure CheckSet(const collection: ISet<Integer>; const values: array of Integer);
  published
    procedure TestExceptWith;
    procedure TestIntersectWith;
    procedure TestIntersectWithList;
    procedure TestUnionWith;
    procedure TestSetEquals;
    procedure TestSetEqualsList;
  end;

  TTestIntegerList = class(TExceptionCheckerTestCase)
  private
    SUT: IList<integer>;
    procedure SimpleFillList;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    procedure TestListRemove;  // Empty
  published
    procedure TestListIsInitializedEmpty;
    procedure TestListCountWithAdd;
    procedure TestListCountWithInsert;
    procedure TestListInsertBetween;
    procedure TestListInsertBeginning;
    procedure TestListSimpleDelete;
    procedure TestListMultipleDelete;
    procedure TestListSimpleExchange;
    procedure TestListReverse;
    procedure TestListSort;
    procedure TestListIndexOf;
    procedure TestLastIndexOf;
    procedure TestListMove;
    procedure TestListClear;
    procedure TestListLargeDelete;
  end;

  TTestEmptyStringIntegerDictionary = class(TExceptionCheckerTestCase)
  private
    SUT: IDictionary<string, integer>;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestDictionaryIsInitializedEmpty;
    procedure TestDictionaryKeysAreEmpty;
    procedure TestDictionaryValuesAreEmpty;
    procedure TestDictionaryContainsReturnsFalse;
    procedure TestDictionaryValuesReferenceCounting;
  end;

  TTestStringIntegerDictionary = class(TExceptionCheckerTestCase)
  private
    SUT: IDictionary<string, integer>;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestDictionaryCountWithAdd;
    procedure TestDictionarySimpleValues;
    procedure TestDictionaryKeys;
    procedure TestDictionaryValues;
    procedure TestDictionaryContainsValue;
    procedure TestDictionaryContainsKey;
  end;

  TTestEmptyStackofStrings = class(TExceptionCheckerTestCase)
  private
    SUT: IStack<string>;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestStackInitializesEmpty;
    procedure TestEmptyPopPeek;
  end;

  TTestStackOfInteger = class(TExceptionCheckerTestCase)
  private
    const MaxStackItems = 1000;
  private
    SUT: IStack<integer>;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
    procedure FillStack;
  published
    procedure TestStackInitializesEmpty;
    procedure TestStackPopPushBalances;
    procedure TestStackClear;
    procedure TestStackPeek;
    procedure TestStackPeekOrDefault;
  end;

  TTestStackOfIntegerChangedEvent = class(TExceptionCheckerTestCase)
  private
    SUT: IStack<Integer>;
    fAInvoked, fBInvoked: Boolean;
    fAItem, fBItem: Integer;
    fAAction, fBAction: TCollectionChangedAction;
    procedure HandlerA(Sender: TObject; const Item: Integer; Action: TCollectionChangedAction);
    procedure HandlerB(Sender: TObject; const Item: Integer; Action: TCollectionChangedAction);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestEmpty;
    procedure TestOneHandler;
    procedure TestTwoHandlers;
    procedure TestNonGenericChangedEvent;
  end;

  TTestEmptyQueueOfInteger = class(TExceptionCheckerTestCase)
  private
    SUT: IQueue<integer>;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestEmptyQueueIsEmpty;
    procedure TestClearOnEmptyQueue;
    procedure TestPeekRaisesException;
    procedure TestDequeueRaisesException;
  end;

  TTestQueueOfInteger = class(TExceptionCheckerTestCase)
  private
    const MaxItems = 1000;
  private
    SUT: IQueue<integer>;
    procedure FillQueue;  // Will test Enqueue method
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestQueueClear;
    procedure TestQueueDequeue;
    procedure TestQueuePeek;
  end;

  TTestQueueOfIntegerChangedEvent = class(TExceptionCheckerTestCase)
  private
    SUT: IQueue<Integer>;
    fAInvoked, fBInvoked: Boolean;
    fAItem, fBItem: Integer;
    fAAction, fBAction: TCollectionChangedAction;
    procedure HandlerA(Sender: TObject; const Item: Integer; Action: TCollectionChangedAction);
    procedure HandlerB(Sender: TObject; const Item: Integer; Action: TCollectionChangedAction);
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestEmpty;
    procedure TestOneHandler;
    procedure TestTwoHandlers;
    procedure TestNonGenericChangedEvent;
  end;

  TTestListOfIntegerAsIEnumerable = class(TExceptionCheckerTestCase)
  private
    const MaxItems = 1000;
  private
    InternalList: IList<integer>;
    SUT: IEnumerable<integer>;
    procedure FillList;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestEnumerableIsEmpty;
    procedure TestEnumerableHasCorrectCountAfterFill;
    procedure TestEnumerableFirst;
    procedure TestEnumerableLast;
    procedure TestSingle;
    procedure TestMin;
    procedure TestMax;
    procedure TestContains;
    procedure TestCheckSingleRaisedExceptionWhenHasMultipleItems;
    procedure TestElementAt;
  end;

implementation

uses
  Classes,
  SysUtils;

{ TTestEmptyHashSet }

procedure TTestEmptyHashSet.SetUp;
begin
  inherited;
  fSet := TCollections.CreateSet<Integer>;
  fEmpty := TCollections.CreateSet<Integer>;
end;

procedure TTestEmptyHashSet.TearDown;
begin
  inherited;
  fSet := nil;
end;

procedure TTestEmptyHashSet.TestEmpty;
begin
  CheckEquals(0, fSet.Count);
  CheckTrue(fSet.IsEmpty);
end;

procedure TTestEmptyHashSet.TestExceptWith;
begin
  fSet.ExceptWith(fEmpty);
  CheckEquals(0, fSet.Count);
end;

procedure TTestEmptyHashSet.TestIntersectWith;
begin
  fSet.IntersectWith(fEmpty);
  CheckEquals(0, fSet.Count);
end;

procedure TTestEmptyHashSet.TestUnionWith;
begin
  fSet.UnionWith(fEmpty);
  CheckEquals(0, fSet.Count);
end;

procedure TTestEmptyHashSet.TestAddDuplications;
begin
  fSet.Add(2);
  CheckEquals(1, fSet.Count);

  fSet.Add(2);
  CheckEquals(1, fSet.Count);
end;

procedure TTestEmptyHashSet.TestSetEquals;
begin
  CheckTrue(fSet.SetEquals(fEmpty));
end;

{ TTestNormalHashSet }

procedure TTestNormalHashSet.CheckSet(const collection: ISet<Integer>; const values: array of Integer);
var
  value: Integer;
begin
  CheckEquals(Length(values), collection.Count);
  for value in values do
  begin
    CheckTrue(collection.Contains(value));
  end;
end;

procedure TTestNormalHashSet.SetUp;
begin
  inherited;
  fSet1 := TCollections.CreateSet<Integer>;
  fSet2 := TCollections.CreateSet<Integer>;
  fSet1.AddRange([1, 2, 3]);
  fSet2.AddRange([3, 1, 4, 5]);
end;

procedure TTestNormalHashSet.TearDown;
begin
  inherited;
  fSet1 := nil;
  fSet2 := nil;
end;

procedure TTestNormalHashSet.TestExceptWith;
begin
  fSet1.ExceptWith(fSet2);
  CheckSet(fSet1, [2]);
end;

procedure TTestNormalHashSet.TestIntersectWith;
begin
  fSet1.IntersectWith(fSet2);
  CheckSet(fSet1, [1, 3]);
end;

procedure TTestNormalHashSet.TestIntersectWithList;
var
  list: IList<Integer>;
begin
  list := TCollections.CreateList<Integer>;
  list.AddRange([3, 1, 4, 5]);
  fSet1.IntersectWith(list);
  CheckSet(fSet1, [1, 3]);
end;

procedure TTestNormalHashSet.TestUnionWith;
begin
  fSet1.UnionWith(fSet2);
  CheckSet(fSet1, [1, 2, 3, 4, 5]);
end;

procedure TTestNormalHashSet.TestSetEquals;
begin
  CheckFalse(fSet1.SetEquals(fSet2));
  CheckTrue(fSet1.SetEquals(fSet1));
  CheckTrue(fSet2.SetEquals(fSet2));
end;

procedure TTestNormalHashSet.TestSetEqualsList;
var
  list: IList<Integer>;
begin
  list := TCollections.CreateList<Integer>;
  list.AddRange([3, 2, 1]);
  CheckTrue(fSet1.SetEquals(list));
  CheckFalse(fSet2.SetEquals(list));
end;

{ TTestIntegerList }

procedure TTestIntegerList.SetUp;
begin
  inherited;
  SUT := TCollections.CreateList<integer>;
end;

procedure TTestIntegerList.TearDown;
begin
  inherited;
  SUT := nil;
end;

const
  ListCountLimit = 1000;

procedure TTestIntegerList.TestLastIndexOf;
begin
  SUT.Add(1);
  SUT.Add(1);
  SUT.Add(1);
  SUT.Add(2);
  SUT.Add(3);

  CheckEquals(2, SUT.LastIndexOf(1));
end;

procedure TTestIntegerList.TestListClear;
var
  i: Integer;
begin
  for i := 0 to ListCountLimit do
  begin
    SUT.Add(i);
  end;

  SUT.Clear;

  CheckEquals(0, SUT.Count, 'List not empty after call to Clear');

end;

procedure TTestIntegerList.TestListCountWithAdd;
var
  i: Integer;
begin
  for i := 1 to ListCountLimit do
  begin
    SUT.Add(i);
    CheckEquals(i, SUT.Count);
  end;
end;

procedure TTestIntegerList.TestListCountWithInsert;
var
  i: Integer;
begin
  for i := 1 to ListCountLimit do
  begin
    SUT.Insert(0, i);
    CheckEquals(i, SUT.Count);
  end;
end;

procedure TTestIntegerList.TestListSimpleDelete;
begin
  SUT.Add(1);
  CheckEquals(1, SUT.Count);
  SUT.Delete(0);
  CheckEquals(0, SUT.Count);
end;

procedure TTestIntegerList.TestListReverse;
var
  i: Integer;
begin
  for i := 0 to ListCountLimit do
  begin
    SUT.Add(i);
  end;
  CheckEquals(ListCountLimit + 1, SUT.Count, 'TestReverse: List count incorrect after initial adds');

  SUT.Reverse;

  for i := ListCountLimit downto 0 do
  begin
    CheckEquals(i, SUT[ListCountLimit - i]);
  end;
end;

procedure TTestIntegerList.TestListSimpleExchange;
begin
  SUT.Add(0);
  SUT.Add(1);
  CheckEquals(2, SUT.Count);
  SUT.Exchange(0, 1);
  CheckEquals(2, SUT.Count, 'Count wrong after exchange');
  CheckEquals(1, SUT[0]);
  CheckEquals(0, SUT[1]);
end;

procedure TTestIntegerList.TestListSort;
var
  i: Integer;
begin
  SUT.Add(6);
  SUT.Add(0);
  SUT.Add(2);
  SUT.Add(5);
  SUT.Add(7);
  SUT.Add(1);
  SUT.Add(8);
  SUT.Add(3);
  SUT.Add(4);
  SUT.Add(9);
  CheckEquals(10, SUT.Count, 'Test');
  SUT.Sort;
  for i := 0 to 9 do
  begin
    CheckEquals(i, SUT[i], Format('%s: Items not properly sorted at Index %d', ['TestlistSort', i]));
  end;
end;

procedure TTestIntegerList.TestListIndexOf;
var
  i: Integer;
begin
  for i := 0 to ListCountLimit - 1 do
  begin
    SUT.Add(i);
  end;
  CheckEquals(ListCountLimit, SUT.Count, 'TestLimitIndexOf: List count not correct after adding items.');

  for i := 0 to ListCountLimit - 1 do
  begin
    CheckEquals(i, SUT.IndexOf(i));
  end;

  CheckEquals(-1, SUT.IndexOf(ListCountLimit + 100), 'Index of item not in list was not -1');

end;

procedure TTestIntegerList.TestListInsertBeginning;
begin
  SUT.Add(0);
  SUT.Add(1);
  SUT.Insert(0, 42);
  CheckEquals(3, SUT.Count);
  CheckEquals(42, SUT[0]);
  CheckEquals(0, SUT[1]);
  CheckEquals(1, SUT[2]);
end;

procedure TTestIntegerList.TestListInsertBetween;
begin
  SUT.Add(0);
  SUT.Add(1);
  SUT.Insert(1, 42);
  CheckEquals(3, SUT.Count);
  CheckEquals(0, SUT[0]);
  CheckEquals(42, SUT[1]);
  CheckEquals(1, SUT[2]);
end;


procedure TTestIntegerList.TestListIsInitializedEmpty;
begin
  CheckEquals(SUT.Count, 0);
end;

procedure TTestIntegerList.TestListLargeDelete;
var
  i: Integer;
begin
  for i := 0 to ListCountLimit do
  begin
    SUT.Add(i);
  end;

  for i := 0 to ListCountLimit do
  begin
    SUT.Delete(0);
  end;

  CheckEquals(0, SUT.Count, 'Not all items properly deleted from large delete');
end;

procedure TTestIntegerList.TestListMove;
begin
  SimpleFillList;
  CheckEquals(3, SUT.Count);

  SUT.Move(0, 2);
  CheckEquals(3, SUT.Count, 'List count is wrong after call to Move');

  CheckEquals(2, SUT[0]);
  CheckEquals(3, SUT[1]);
  CheckEquals(1, SUT[2]);
end;

procedure TTestIntegerList.TestListMultipleDelete;
begin
  SimpleFillList;
  CheckEquals(3, SUT.Count);
  SUT.Delete(0);
  CheckEquals(2, SUT.Count);
  SUT.Delete(0);
  CheckEquals(1, SUT.Count);
  SUT.Delete(0);
  CheckEquals(0, SUT.Count);
end;

procedure TTestIntegerList.TestListRemove;
begin

end;

procedure TTestIntegerList.SimpleFillList;
begin
  Assert(Assigned(SUT), 'SUT is nil');
  SUT.Add(1);
  SUT.Add(2);
  SUT.Add(3);
end;

{ TTestStringIntegerDictionary }

procedure TTestStringIntegerDictionary.SetUp;
begin
  inherited;
  SUT := TCollections.CreateDictionary<string, integer>;
  SUT.Add('one', 1);
  SUT.Add('two', 2);
  SUT.Add('three', 3);
end;

procedure TTestStringIntegerDictionary.TearDown;
begin
  inherited;
  SUT := nil;
end;

procedure TTestStringIntegerDictionary.TestDictionaryContainsKey;
begin
  CheckTrue(SUT.ContainsKey('one'), '"one" not found by ContainsKey');
  CheckTrue(SUT.ContainsKey('two'), '"two" not found by ContainsKey');
  CheckTrue(SUT.ContainsKey('three'), '"three" not found by ContainsKey');
end;

procedure TTestStringIntegerDictionary.TestDictionaryContainsValue;
begin
  CheckTrue(SUT.ContainsValue(1), '1 not found by ContainsValue');
  CheckTrue(SUT.ContainsValue(2), '2 not found by ContainsValue');
  CheckTrue(SUT.ContainsValue(3), '3 not found by ContainsValue');
end;

procedure TTestStringIntegerDictionary.TestDictionaryCountWithAdd;
begin
  CheckEquals(3, SUT.Count, 'TestDictionaryCountWithAdd: Count is not correct');
end;

procedure TTestStringIntegerDictionary.TestDictionaryKeys;
var
  Result: ICollection<string>;
begin
  Result := SUT.Keys;
  CheckEquals(3, Result.Count, 'TestDictionaryKeys: Keys call returns wrong count');

  CheckTrue(Result.Contains('one'), 'TestDictionaryKeys: Keys doesn''t contain "one"');
  CheckTrue(Result.Contains('two'), 'TestDictionaryKeys: Keys doesn''t contain "two"');
  CheckTrue(Result.Contains('three'), 'TestDictionaryKeys: Keys doesn''t contain "three"');
end;

procedure TTestStringIntegerDictionary.TestDictionarySimpleValues;
begin
  CheckEquals(3, SUT.Count, 'TestDictionarySimpleValues: Count is not correct');

  CheckEquals(1, SUT['one']);
  CheckEquals(2, SUT['two']);
  CheckEquals(3, SUT['three']);
end;

procedure TTestStringIntegerDictionary.TestDictionaryValues;
var
  Result: ICollection<integer>;
begin
  Result := SUT.Values;
  CheckEquals(3, Result.Count, 'TestDictionaryKeys: Values call returns wrong count');

  CheckTrue(Result.Contains(1), 'TestDictionaryKeys: Values doesn''t contain "one"');
  CheckTrue(Result.Contains(2), 'TestDictionaryKeys: Values doesn''t contain "two"');
  CheckTrue(Result.Contains(3), 'TestDictionaryKeys: Values doesn''t contain "three"');
end;

{ TTestEmptyStringIntegerDictionary }

procedure TTestEmptyStringIntegerDictionary.SetUp;
begin
  inherited;
  SUT := TCollections.CreateDictionary<string, integer>;
end;

procedure TTestEmptyStringIntegerDictionary.TearDown;
begin
  inherited;
  SUT := nil;
end;

procedure TTestEmptyStringIntegerDictionary.TestDictionaryContainsReturnsFalse;
begin
  CheckFalse(SUT.ContainsKey('blah'));
  CheckFalse(SUT.ContainsValue(42));
end;

procedure TTestEmptyStringIntegerDictionary.TestDictionaryIsInitializedEmpty;
begin
  CheckEquals(0, SUT.Count);
end;

procedure TTestEmptyStringIntegerDictionary.TestDictionaryKeysAreEmpty;
var
  Result: ICollection<string>;
begin
  Result := SUT.Keys;
  CheckEquals(0, Result.Count);
end;

procedure TTestEmptyStringIntegerDictionary.TestDictionaryValuesAreEmpty;
var
  Result: ICollection<integer>;
begin
  Result := SUT.Values;
  CheckEquals(0, Result.Count);
end;

procedure TTestEmptyStringIntegerDictionary.TestDictionaryValuesReferenceCounting;
var
  query: IEnumerable<Integer>;
begin
  query := SUT.Values.Skip(1);
  CheckNotNull(query);
end;

{ TTestEmptyStackofStrings }

procedure TTestEmptyStackofStrings.SetUp;
begin
  inherited;
  SUT := TCollections.CreateStack<string>;
end;

procedure TTestEmptyStackofStrings.TearDown;
begin
  inherited;
  SUT := nil;
end;

procedure TTestEmptyStackofStrings.TestEmptyPopPeek;
begin
  CheckException(EListError, procedure() begin SUT.Pop end, 'EListError not raised');
  CheckException(EListError, procedure() begin SUT.Peek end, 'EListError not raised');
end;

procedure TTestEmptyStackofStrings.TestStackInitializesEmpty;
begin
  CheckEquals(0, SUT.Count);
end;

{ TTestStackOfInteger }

procedure TTestStackOfInteger.FillStack;
var
  i: Integer;
begin
  Check(SUT <> nil);
  for i := 0 to MaxStackItems do
  begin
    SUT.Push(i);
  end;
end;

procedure TTestStackOfInteger.SetUp;
begin
  inherited;
  SUT := TCollections.CreateStack<integer>;
end;

procedure TTestStackOfInteger.TearDown;
begin
  inherited;
  SUT := nil;
end;

procedure TTestStackOfInteger.TestStackClear;
begin
  FillStack;
  SUT.Clear;
  CheckEquals(0, SUT.Count, 'Stack failed to empty after call to Clear');
end;

procedure TTestStackOfInteger.TestStackInitializesEmpty;
begin
  CheckEquals(0, SUT.Count);
end;

procedure TTestStackOfInteger.TestStackPeek;
var
  Expected: Integer;
  Actual: integer;
begin
  FillStack;
  Expected := MaxStackItems;
  Actual := SUT.Peek;
  CheckEquals(Expected, Actual, 'Stack.Peek failed');
end;

procedure TTestStackOfInteger.TestStackPeekOrDefault;
var
  Expected: Integer;
  Actual: integer;
begin
  FillStack;
  Expected := MaxStackItems;
  Actual := SUT.PeekOrDefault;
  CheckEquals(Expected, Actual, 'Stack.Peek failed');

  SUT.Clear;
  Expected := Default(Integer);
  Actual := SUT.PeekOrDefault;
  CheckEquals(Expected, Actual, 'Stack.Peek failed');
end;

procedure TTestStackOfInteger.TestStackPopPushBalances;
var
  i: Integer;
begin
  FillStack;

  for i := 0 to MaxStackItems do
  begin
    SUT.Pop;
  end;

  // Should be empty
  CheckEquals(0, SUT.Count);
end;

{ TTestStackOfIntegerChangedEvent }

procedure TTestStackOfIntegerChangedEvent.SetUp;
begin
  inherited;
  SUT := TCollections.CreateStack<Integer>;
end;

procedure TTestStackOfIntegerChangedEvent.TearDown;
begin
  inherited;
  SUT := nil;
  fAInvoked := False;
  fBInvoked := False;
end;

procedure TTestStackOfIntegerChangedEvent.HandlerA(Sender: TObject;
  const Item: Integer; Action: TCollectionChangedAction);
begin
  fAItem := Item;
  fAAction := Action;
  fAInvoked := True;
end;

procedure TTestStackOfIntegerChangedEvent.HandlerB(Sender: TObject;
  const Item: Integer; Action: TCollectionChangedAction);
begin
  fBitem := Item;
  fBAction := Action;
  fBInvoked := True;
end;

procedure TTestStackOfIntegerChangedEvent.TestEmpty;
begin
  CheckEquals(0, SUT.OnChanged.Count);
  CheckTrue(SUT.OnChanged.IsEmpty);

  SUT.Push(0);

  CheckFalse(fAInvoked);
  CheckFalse(fBInvoked);
end;

procedure TTestStackOfIntegerChangedEvent.TestOneHandler;
begin
  SUT.OnChanged.Add(HandlerA);

  SUT.Push(0);

  CheckTrue(fAInvoked, 'handler A not invoked');
  CheckTrue(fAAction = caAdded, 'handler A: different collection notifications');
  CheckEquals(0, fAItem, 'handler A: different item');

  CheckFalse(fBInvoked, 'handler B not registered as callback');

  SUT.Pop;

  CheckTrue(fAAction = caRemoved, 'different collection notifications');

  SUT.OnChanged.Remove(HandlerA);
  CheckEquals(0, SUT.OnChanged.Count);
  CheckTrue(SUT.OnChanged.IsEmpty);
end;

procedure TTestStackOfIntegerChangedEvent.TestTwoHandlers;
begin
  SUT.OnChanged.Add(HandlerA);
  SUT.OnChanged.Add(HandlerB);

  SUT.Push(0);

  CheckTrue(fAInvoked, 'handler A not invoked');
  CheckTrue(fAAction = caAdded, 'handler A: different collection notifications');
  CheckEquals(0, fAItem, 'handler A: different item');
  CheckTrue(fBInvoked, 'handler B not invoked');
  CheckTrue(fBAction = caAdded, 'handler B: different collection notifications');
  CheckEquals(0, fBItem, 'handler B: different item');

  SUT.Pop;

  CheckTrue(fAAction = caRemoved, 'handler A: different collection notifications');
  CheckEquals(0, fAItem, 'handler A: different item');
  CheckTrue(fBAction = caRemoved, 'handler B: different collection notifications');
  CheckEquals(0, fBItem, 'handler B: different item');

  SUT.OnChanged.Remove(HandlerA);
  CheckEquals(1, SUT.OnChanged.Count);
  CheckFalse(SUT.OnChanged.IsEmpty);
  SUT.OnChanged.Remove(HandlerB);
  CheckTrue(SUT.OnChanged.IsEmpty);
end;

procedure TTestStackOfIntegerChangedEvent.TestNonGenericChangedEvent;
var
  stack: IStack;
  method: TMethod;
begin
  stack := SUT.AsStack;

  CheckTrue(stack.IsEmpty);
  CheckTrue(stack.OnChanged.Enabled);

  method.Code := @TTestStackOfIntegerChangedEvent.HandlerA;
  method.Data := Pointer(Self);

  stack.OnChanged.Add(method);

  CheckEquals(1, stack.OnChanged.Count);

  stack.Push(0);

  CheckTrue(fAInvoked, 'handler A not invoked');
  CheckTrue(fAAction = caAdded, 'handler A: different collection notifications');
  CheckEquals(0, fAItem, 'handler A: different item');
end;

{ TTestEmptyQueueofTObject }

procedure TTestEmptyQueueOfInteger.SetUp;
begin
  inherited;
  SUT := TCollections.CreateQueue<integer>
end;

procedure TTestEmptyQueueOfInteger.TearDown;
begin
  inherited;
  SUT := nil;
end;

procedure TTestEmptyQueueOfInteger.TestClearOnEmptyQueue;
begin
  CheckEquals(0, SUT.Count, 'Queue not empty before call to clear');
  SUT.Clear;
  CheckEquals(0, SUT.Count, 'Queue not empty after call to clear');
end;

procedure TTestEmptyQueueOfInteger.TestEmptyQueueIsEmpty;
begin
  CheckEquals(0, SUT.Count);
end;

procedure TTestEmptyQueueOfInteger.TestPeekRaisesException;
begin
  CheckException(EListError, procedure() begin SUT.Peek end, 'EListError was not raised on Peek call with empty Queue');
end;

procedure TTestEmptyQueueOfInteger.TestDequeueRaisesException;
begin
  CheckException(EListError, procedure() begin SUT.Dequeue end, 'EListError was not raised on Peek call with empty Queue');
end;

{ TTestQueueOfInteger }

procedure TTestQueueOfInteger.FillQueue;
var
  i: Integer;
begin
  Check(SUT <> nil);
  for i := 0 to MaxItems - 1  do
  begin
    SUT.Enqueue(i);
  end;
  CheckEquals(MaxItems, SUT.Count, 'Call to FillQueue did not properly fill the queue');
end;

procedure TTestQueueOfInteger.SetUp;
begin
  inherited;
  SUT := TCollections.CreateQueue<integer>;
end;

procedure TTestQueueOfInteger.TearDown;
begin
  inherited;
  SUT := nil;
end;

procedure TTestQueueOfInteger.TestQueueClear;
begin
  FillQueue;
  SUT.Clear;
  CheckEquals(0, SUT.Count, 'Clear call failed to empty the queue');
end;

procedure TTestQueueOfInteger.TestQueueDequeue;
var
  i: Integer;
begin
  FillQueue;
  for i := 1 to MaxItems do
  begin
    SUT.Dequeue;
  end;

  CheckEquals(0, SUT.Count, 'Dequeue did not remove all the items');
end;

procedure TTestQueueOfInteger.TestQueuePeek;
var
  Expected: Integer;
  Actual: Integer;
begin
  FillQueue;
  Expected := 0;
  Actual := SUT.Peek;
  CheckEquals(Expected, Actual);
end;

{ TTestQueueOfIntegerChangedEvent }

procedure TTestQueueOfIntegerChangedEvent.SetUp;
begin
  inherited;
  SUT := TCollections.CreateQueue<Integer>;
end;

procedure TTestQueueOfIntegerChangedEvent.TearDown;
begin
  inherited;
  SUT := nil;
  fAInvoked := False;
  fBInvoked := False;
end;

procedure TTestQueueOfIntegerChangedEvent.HandlerA(Sender: TObject;
  const Item: Integer; Action: TCollectionChangedAction);
begin
  fAItem := Item;
  fAAction := Action;
  fAInvoked := True;
end;

procedure TTestQueueOfIntegerChangedEvent.HandlerB(Sender: TObject;
  const Item: Integer; Action: TCollectionChangedAction);
begin
  fBitem := Item;
  fBAction := Action;
  fBInvoked := True;
end;

procedure TTestQueueOfIntegerChangedEvent.TestEmpty;
begin
  CheckEquals(0, SUT.OnChanged.Count);
  CheckTrue(SUT.OnChanged.IsEmpty);

  SUT.Enqueue(0);

  CheckFalse(fAInvoked);
  CheckFalse(fBInvoked);
end;

procedure TTestQueueOfIntegerChangedEvent.TestOneHandler;
begin
  SUT.OnChanged.Add(HandlerA);

  SUT.Enqueue(0);

  CheckTrue(fAInvoked, 'handler A not invoked');
  CheckTrue(fAAction = caAdded, 'handler A: different collection notifications');
  CheckEquals(0, fAItem, 'handler A: different item');

  CheckFalse(fBInvoked, 'handler B not registered as callback');

  SUT.Dequeue;

  CheckTrue(fAAction = caRemoved, 'different collection notifications');

  SUT.OnChanged.Remove(HandlerA);
  CheckEquals(0, SUT.OnChanged.Count);
  CheckTrue(SUT.OnChanged.IsEmpty);
end;

procedure TTestQueueOfIntegerChangedEvent.TestTwoHandlers;
begin
  SUT.OnChanged.Add(HandlerA);
  SUT.OnChanged.Add(HandlerB);

  SUT.Enqueue(0);

  CheckTrue(fAInvoked, 'handler A not invoked');
  CheckTrue(fAAction = caAdded, 'handler A: different collection notifications');
  CheckEquals(0, fAItem, 'handler A: different item');
  CheckTrue(fBInvoked, 'handler B not invoked');
  CheckTrue(fBAction = caAdded, 'handler B: different collection notifications');
  CheckEquals(0, fBItem, 'handler B: different item');

  SUT.Dequeue;

  CheckTrue(fAAction = caRemoved, 'handler A: different collection notifications');
  CheckEquals(0, fAItem, 'handler A: different item');
  CheckTrue(fBAction = caRemoved, 'handler B: different collection notifications');
  CheckEquals(0, fBItem, 'handler B: different item');

  SUT.OnChanged.Remove(HandlerA);
  CheckEquals(1, SUT.OnChanged.Count);
  CheckFalse(SUT.OnChanged.IsEmpty);
  SUT.OnChanged.Remove(HandlerB);
  CheckTrue(SUT.OnChanged.IsEmpty);
end;

procedure TTestQueueOfIntegerChangedEvent.TestNonGenericChangedEvent;
var
  queue: IQueue;
  method: TMethod;
begin
  queue := SUT.AsQueue;

  CheckTrue(queue.IsEmpty);
  CheckTrue(queue.OnChanged.Enabled);

  method.Code := @TTestStackOfIntegerChangedEvent.HandlerA;
  method.Data := Pointer(Self);

  queue.OnChanged.Add(method);

  CheckEquals(1, queue.OnChanged.Count);

  queue.Enqueue(0);

  CheckTrue(fAInvoked, 'handler A not invoked');
  CheckTrue(fAAction = caAdded, 'handler A: different collection notifications');
  CheckEquals(0, fAItem, 'handler A: different item');
end;

{ TTestListOfIntegerAsIEnumerable }

procedure TTestListOfIntegerAsIEnumerable.FillList;
var
  i: integer;
begin
  for i := 0 to MaxItems - 1 do
  begin
    InternalList.Add(i);
  end;
end;

procedure TTestListOfIntegerAsIEnumerable.SetUp;
begin
  inherited;
  InternalList := TCollections.CreateList<integer>;
  SUT := InternalList;
end;

procedure TTestListOfIntegerAsIEnumerable.TearDown;
begin
  inherited;
  SUT := nil;
end;

procedure TTestListOfIntegerAsIEnumerable.TestEnumerableIsEmpty;
begin
  CheckEquals(0, SUT.Count);
  CheckTrue(SUT.IsEmpty);
end;

procedure TTestListOfIntegerAsIEnumerable.TestEnumerableLast;
begin
  FillList;
  CheckEquals(MaxItems - 1, SUT.Last);
end;

procedure TTestListOfIntegerAsIEnumerable.TestMax;
begin
  FillList;
  CheckEquals(MaxItems - 1, SUT.Max);
end;

procedure TTestListOfIntegerAsIEnumerable.TestMin;
begin
  FillList;
  CheckEquals(0, SUT.Min);
end;

procedure TTestListOfIntegerAsIEnumerable.TestSingle;
var
  ExpectedResult, ActualResult: integer;
begin
  InternalList.Add(1);
  ExpectedResult := 1;
  ActualResult := SUT.Single;
  CheckEquals(ExpectedResult, ActualResult);
end;

procedure TTestListOfIntegerAsIEnumerable.TestCheckSingleRaisedExceptionWhenHasMultipleItems;
begin
  FillList;
  CheckException(EInvalidOperationException, procedure begin SUT.Single end,
    'SUT has more thann one item, but failed to raise the EInvalidOperationException when the Single method was called.');
end;

procedure TTestListOfIntegerAsIEnumerable.TestContains;
begin
  FillList;
  CheckTrue(SUT.Contains(50));
  CheckFalse(SUT.Contains(MaxItems + 50));
end;

procedure TTestListOfIntegerAsIEnumerable.TestElementAt;
var
  i: integer;
begin
  FillList;
  for i := 0 to MaxItems - 1 do
  begin
    CheckEquals(i, SUT.ElementAt(i));
  end;
end;

procedure TTestListOfIntegerAsIEnumerable.TestEnumerableFirst;
begin
  FillList;
  CheckEquals(0, SUT.First);
end;

procedure TTestListOfIntegerAsIEnumerable.TestEnumerableHasCorrectCountAfterFill;
begin
  FillList;
  CheckEquals(MaxItems, SUT.Count);
end;

end.
