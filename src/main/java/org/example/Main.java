package org.example;

import java.lang.foreign.*;
import java.lang.invoke.MethodHandle;

import static java.lang.foreign.SymbolLookup.libraryLookup;

public class Main {
    public static void main(String[] args) throws Throwable {
        Linker linker = Linker.nativeLinker();
        String libName = "";

        SymbolLookup libraryLookup = libraryLookup(libName, Arena.global());
        var symbol = libraryLookup.find("my_strlen").orElseThrow();

        MethodHandle strlen = linker.downcallHandle(symbol,
                FunctionDescriptor.of(ValueLayout.JAVA_LONG, ValueLayout.ADDRESS));

        Arena arena = Arena.ofAuto();
        MemorySegment str = arena.allocateFrom("Hello");
        long len = (long) strlen.invoke(str);

        System.out.println("Inaccurate string length: " + len);

    }
}