This file loosely follows the buffer implementation in the
[Multiversx+WASM](https://github.com/runtimeverification/mx-semantics/blob/531a3356383693a88ca3d48bc2e6d661ff46c874/kmultiversx/src/kmultiversx/kdist/mx-semantics/vmhooks/manBufOps.md)
implementation. The "// extern" links point to the actual hook somewhat related
to the current implementation.

```k

module MX-BUFFERS-HOOKS
    imports private BOOL
    imports private COMMON-K-CELL
    imports private K-EQUAL-SYNTAX
    imports private MX-BUFFERS-CONFIGURATION
    imports private MX-COMMON-SYNTAX

 // extern int32_t   mBufferNew(void* context);
    rule
        <k> MX#mBufferNew(.MxValueList) => mxIntValue(NextId) ... </k>
        <buffer-heap> Values:Map => Values[NextId <- mxListValue(.MxValueList)] </buffer-heap>
        <buffer-heap-next-id> NextId => NextId +Int 1 </buffer-heap-next-id>

 // extern int32_t   mBufferNewFromBytes(void* context, int32_t dataOffset, int32_t dataLength);
    rule
        <k> MX#mBufferNewFromValue(V:MxValue, .MxValueList) => mxIntValue(NextId) ... </k>
        <buffer-heap> Values:Map => Values[NextId <- mxListValue(V, .MxValueList)] </buffer-heap>
        <buffer-heap-next-id> NextId => NextId +Int 1 </buffer-heap-next-id>

 // extern int32_t   mBufferSetBytes(void* context, int32_t mBufferHandle, int32_t dataOffset, int32_t dataLength);
    rule
        <k> MX#mBufferSetValue(mxIntValue(BufferHandle:Int), V:MxValue, .MxValueList) => mxIntValue(0) ... </k>
        <buffer-heap> Values:Map => Values[BufferHandle <- mxListValue(V, .MxValueList)] </buffer-heap>
        requires BufferHandle in_keys(Values)

 // extern int32_t   mBufferGetBytes(void* context, int32_t mBufferHandle, int32_t resultOffset);
    rule
        <k> MX#mBufferGetValue(mxIntValue(BufferHandle:Int), .MxValueList) => V ... </k>
        <buffer-heap> BufferHandle |-> mxListValue(V, .MxValueList) ... </buffer-heap>

 // extern int32_t   mBufferAppend(void* context, int32_t accumulatorHandle, int32_t dataHandle);
    rule
        <k> MX#mBufferAppend(mxIntValue(BufferHandle:Int), V:MxValue, .MxValueList) => mxIntValue(0) ... </k>
        <buffer-heap>
            BufferHandle |-> mxListValue(L:MxValueList => append(L, V))
            ...
        </buffer-heap>

 // extern int32_t   mBufferGetLength(void* context, int32_t mBufferHandle);
    rule
        <k>
            MX#mBufferGetLength(mxIntValue(BufferHandle:Int), .MxValueList)
            => mxIntValue(lengthValueList(L))
            ...
        </k>
        <buffer-heap> BufferHandle |-> mxListValue(L:MxValueList) ... </buffer-heap>

 // extern int32_t   mBufferGetByteSlice(void* context, int32_t sourceHandle, int32_t startingPosition, int32_t sliceLength, int32_t resultOffset);
    rule
        <k>
            MX#mBufferGetEntry(mxIntValue(BufferHandle:Int), mxIntValue(Position), .MxValueList)
            => getOrError(Position, L)
            ...
        </k>
        <buffer-heap> BufferHandle |-> mxListValue(L:MxValueList) ... </buffer-heap>

 // mBufferSetByteSlice
    rule
        <k>
            MX#mBufferSetEntry
                ( mxIntValue(BufferHandle:Int)
                , mxIntValue(Index:Int)
                , V:MxValue
                , .MxValueList
                )
            => mxIntValue(0)
            ...
        </k>
        <buffer-heap>
            BufferHandle |-> mxListValue(L:MxValueList => setAtIndex(L, Index, V))
            ...
        </buffer-heap>
        requires 0 <=Int Index andBool Index <Int lengthValueList(L)

  // ---------------------------------------

  syntax MxValueOrError ::= getOrError(Int, MxValueList)  [function, total]
  rule getOrError(I, L:MxValueList)
      => mxError("getOrError(Int, MxValueList): Negative index", ListItem(I) ListItem(L))
      requires I <Int 0
  rule getOrError(I, .MxValueList)
      => mxError("getOrError(Int, MxValueList): Index too large", ListItem(I))
      requires I >=Int 0
  rule getOrError(0, V:MxValue , _:MxValueList) => V
  rule getOrError(I, _, L:MxValueList) => getOrError(I -Int 1, L)
      requires I >Int 0

endmodule

```
