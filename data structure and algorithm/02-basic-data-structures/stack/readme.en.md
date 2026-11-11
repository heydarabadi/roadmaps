# Stack

> Course: [Chapter 2](../readme.en.md) · [Original Persian lesson](readme.md) · Prerequisites: arrays or linked lists and function calls

## Learning goals and prerequisites

You should be comfortable with arrays or linked lists and function calls. By the end, you should be able to explain the representation, trace its operations, state their preconditions, and choose it for a workload for a reason.

## Core idea

A stack is a sequence with a Last-In, First-Out (LIFO) contract: the most recently pushed item is the first one popped. All insertion and removal happen at the same end, called the top.

## Representation, contract, and invariant

Core operations are `push(x)`, `pop()`, `peek()/top()`, and `isEmpty()`. A pop or peek on an empty stack must return a controlled error/optional result or follow another explicit API contract. The interface is independent of whether the representation is an array or linked list.

An invariant is a property that must remain true before and after every operation. State it explicitly before coding: it often exposes boundary bugs before they appear in a test.

## Step-by-step operations or algorithm

For an array-backed stack, push writes at the next free index and advances top/size; pop saves the top value, decrements size, and returns it. Check a fixed capacity for overflow and check emptiness before pop/peek. A dynamic array may resize.

Define API behavior for empty input, missing values, duplicates, and capacity limits. A library method name alone does not tell you its complexity or mutation behavior; consult the implementation's contract.

## Worked trace

To evaluate `(2 + 3) × 4`, push operands as they arrive. On `+`, pop 3 and 2, compute 5, then push 5. On `×`, pop 4 and 5, compute 20, and push 20. Parentheses can be handled by retaining an opening delimiter and reducing operators until it is reached.

When studying, write a table with the operation, indexes or pointers, active region, state change, and reason. Do not skip pointer updates or heap/array swaps.

## Why it is correct

The top always identifies the last live element. After pushes and pops, the remaining elements leave in reverse order of their insertion. The maximum number of simultaneously active recursive calls is the recursion stack depth.

Check the usual proof shape: initialization (the invariant is true at the start), maintenance (each step preserves it), and termination (the invariant plus the stopping condition implies the result).

## Time and space analysis

Push, pop, and peek are O(1) amortized for the usual implementation; a resizing push can be O(n). Space is O(n). Recursion also uses the call stack, and excessive depth can cause stack overflow.

Name the input-size variable and the case being analyzed. Separate auxiliary space from the input and returned output. Big-O describes growth, not seconds; cache locality, allocation, implementation constants, and the workload affect measured time.

## Real-world use

Stacks model undo/redo histories, browser navigation, expression evaluation, delimiter matching, DFS, and function-call management. A two-stack design often supports undo and redo in both directions.

## Common mistakes and edge cases

For non-commutative operators, the first popped value is the right operand. Always guard empty pop/peek. Recursion has hidden stack cost; an iterative version may make memory use more controllable.

Always consider empty input, one element, duplicates, a missing target, extreme values, and large input. Integer overflow and invalidated references are language-dependent.

## Exercises

1. Validate `([{}])` and reject `([)]` with a delimiter stack. 2. Evaluate postfix `5 2 3 * +` step by step. 3. Convert recursive DFS to an explicit-stack DFS and compare neighbor order.

For each exercise, first trace a small instance by hand, then analyze it and add boundary cases. The questions below include an answer key; attempt them before reading the answers.

## Comprehensive quiz with explained answers

1. **Question:** What does LIFO mean?
   **Explained answer:** The last item pushed is the first one removed.
2. **Question:** What is stack underflow?
   **Explained answer:** Attempting to pop from an empty stack; the API should handle it safely.
3. **Question:** Why evaluate postfix with a stack?
   **Explained answer:** It retains operands until an operator can combine them, without requiring precedence parentheses.
4. **Question:** What is push complexity?
   **Explained answer:** O(1) amortized; one resize-triggering operation may take O(n).
5. **Question:** What is a risk of deep recursion?
   **Explained answer:** It consumes call-stack space and may overflow the stack.

## Further reading and references

- [Princeton Algorithms, Section 1.3: Stacks and Queues](https://algs4.cs.princeton.edu/13stacks/) — Stack APIs, array and linked implementations.
- [Python Tutorial: Data Structures](https://docs.python.org/3/tutorial/datastructures.html) — Using a list as a stack.
- [USFCA stack visualization](https://www.cs.usfca.edu/~galles/visualization/StackArray.html) — Animated array-backed stack operations.
- [MIT 6.006 lecture notes](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-notes/) — Algorithm and data-structure analysis.
- [Data Structures & Algorithms roadmap](https://roadmap.sh/datastructures-and-algorithms) — topic map and learning sequence.

## Mastery checklist

- [ ] I can explain the representation and its invariant without looking at the page.
- [ ] I can trace the example and handle empty, singleton, duplicate, and boundary cases.
- [ ] I can justify correctness and state time and auxiliary space by case.
- [ ] I can name a suitable workload and one trade-off.
- [ ] I can solve the exercises and quiz without copying the explanation.
