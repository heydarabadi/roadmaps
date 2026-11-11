# 4.1 — Conditions, loops, range, and control flow

<div dir="ltr">

**Time:** 90 minutes · **Prerequisite:** variables and collections  
**Goal:** Express branching and repetition clearly, and understand what each range form iterates over.

## if and switch

Go if statements do not require parentheses. An initializer may limit a variable’s scope to the condition and branches.

~~~go
if err := validate(input); err != nil {
    return err
}

switch status {
case "ready":
    start()
case "stopped":
    stop()
default:
    report(status)
}
~~~

Switch cases do not fall through by default. Use fallthrough only when that specific behavior is wanted. Type switches are covered with interfaces.

## The for statement

Go uses one loop keyword: for. It supports initializer/condition/post form, condition-only form, or an infinite loop that exits with break or return.

~~~go
for i := 0; i < len(items); i++ {
    process(items[i])
}

for condition {
    work()
}

for {
    if done {
        break
    }
    work()
}
~~~

A guard clause can reduce nesting. Prefer clear flow over clever labels.

## range over collections

For slices, range yields an index and a copy of the element value. For maps, it yields key/value pairs in unspecified order. For strings, it yields byte offsets and decoded runes. For channels, it receives values until the channel is closed.

~~~go
for index, value := range values {
    fmt.Println(index, value)
}
for key, value := range lookup {
    fmt.Println(key, value)
}
for offset, r := range text {
    fmt.Println(offset, r)
}
~~~

Go 1.22 changed loop-variable semantics for modules using the newer language version, reducing a common closure-capture bug. For older module versions or intentionally shared variables, understand which variable each iteration captures. Check the go directive before relying on the new rule.

## break, continue, labels, and goto

break exits the innermost loop or switch. continue starts the next loop iteration. A label lets break or continue target an outer loop, but too many labels make code hard to follow. goto exists and is discouraged in ordinary structured application code; resource cleanup and helper functions are usually clearer.

~~~go
outer:
for _, group := range groups {
    for _, item := range group {
        if item == target {
            break outer
        }
    }
}
~~~

## Common mistakes

- Assuming map range order is deterministic.
- Assuming range over a slice returns a reference to each element.
- Treating string range indexes as rune indexes.
- Capturing a loop variable in a goroutine without understanding the language version.
- Forgetting that break exits only the nearest loop unless labeled.
- Using goto instead of ordinary structured control flow.

## Guided practice with answers

**1. You need stable output from a map. What should you do?**  
Collect and sort its keys before printing.

**2. Why does changing the value variable in a slice range loop not necessarily change the original element?**  
The loop variable is a copy. Update the slice by index when mutation is required.

**3. How do you exit two nested loops after finding an item?**  
Use a clearly named label with break, or move the search into a function and return.

## Quiz

### Questions

1. What keyword represents Go loop forms?
2. Do switch cases fall through automatically?
3. What does break exit by default?
4. What does continue do?
5. What does range over a map yield?
6. Is map iteration order guaranteed?
7. What does range over a string return?
8. Is the slice element variable a reference to the original element?
9. What can a label change for break or continue?
10. Which release introduced new loop-variable semantics for newer language versions?
11. Why should code check its module version for loop capture behavior?
12. Why is goto discouraged for ordinary application flow?

### Answer key

1. for.
2. No.
3. The innermost loop or switch.
4. Starts the next iteration.
5. A key and value.
6. No.
7. The starting byte offset and decoded rune.
8. No; it receives a copy.
9. It can target a named outer loop.
10. Go 1.22.
11. Language behavior depends on the go directive.
12. It can obscure structured flow; loops, functions, and returns are usually clearer.

## References and further reading

- [Go specification: statements](https://go.dev/ref/spec#Statements)
- [Go specification: for statements](https://go.dev/ref/spec#For_statements)
- [Go specification: range clause](https://go.dev/ref/spec#For_range)
- [Go specification: switch statements](https://go.dev/ref/spec#Switch_statements)
- [Go specification: break and continue](https://go.dev/ref/spec#Break_statements)
- [Go 1.22 release notes: language changes](https://go.dev/doc/go1.22#language)
- [Go blog: loop variable capture](https://go.dev/blog/loopvar-preview)

[Persian version](README.md) · [Next: functions and closures](../02-functions-closures/README.en.md)

</div>