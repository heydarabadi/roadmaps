# Data Structures and Algorithms — Persian/English Study Course

> [فارسی](../../fa/data-structures-and-algorithms/README.md) · [Roadmap coverage map](roadmap-coverage.md) · [Curated bibliography](references.md)

This folder contains a chapter-by-chapter course based on the Data Structures and Algorithms roadmap. The English lessons sit beside the Persian lessons as `readme.en.md`; each topic page includes a complete explanation, worked trace, correctness reasoning, complexity analysis, exercises, an answer-explained quiz, and related reading.

## Roadmap basis and scope

The interactive [DSA roadmap](https://roadmap.sh/datastructures-and-algorithms) was inspected on 2026-11-10 and compared with the official [roadmap PDF](https://roadmap.sh/pdfs/roadmaps/datastructures-and-algorithms.pdf). The inspected interactive graph showed C# under “Pick a Language”; the PDF lists eight languages. This course includes C# plus seven companion language guides so both views are covered. The main roadmap is organized into 83 topics; the collection also contains three separate traversal lessons and eight language guides. The [coverage map](roadmap-coverage.md) connects roadmap nodes to files.

The references are a curated set of course notes, official documentation, algorithm articles, papers, and practice material. No one can literally read every page on the internet; the goal here is to provide multiple useful, credible paths for each topic. The lesson text contains the core knowledge needed to learn the topic; outside links are for additional study.

## Chapters

1. [Foundations and complexity](01-foundations/README.md) — programming fundamentals, analysis, and common growth rates.
2. [Basic data structures](02-basic-data-structures/README.md) — arrays, linked lists, stacks, queues, and hash tables.
3. [Searching and sorting](03-searching-and-sorting/README.md) — linear/binary search and six sorting algorithms.
4. [Trees and heaps](04-trees/README.md) — binary trees, BSTs, AVL/B-trees, heaps, and traversals.
5. [Graphs](05-graphs/README.md) — representations, BFS/DFS, shortest paths, and spanning trees.
6. [Advanced data structures](06-advanced-data-structures/README.md) — tries, Fenwick/segment trees, DSU, and suffix indexes.
7. [Complex structures and indexing](07-complex-structures-and-indexing/README.md) — multiway trees, skip lists, ISAM, and indexes.
8. [Problem-solving techniques](08-problem-solving-techniques/README.md) — recursion, DP, greedy, backtracking, pointers, and more.
9. [Practice and self-assessment](09-practice-platforms/README.md) — structured practice with LeetCode and Edabit.

## How to study each lesson

1. Read the prerequisites and state the problem contract in your own words.
2. Trace the worked example by hand before reading its explanation.
3. Write the invariant or state definition before implementing the algorithm.
4. Complete the exercises and check empty, singleton, duplicate, absent, boundary, and maximum-size cases.
5. Answer the quiz before reading the answer explanations.
6. Revisit the page later and explain correctness and complexity without looking.
7. Use the references for a second explanation, implementation detail, original paper, or additional practice.

Each page separates algorithmic time from auxiliary memory and calls out assumptions such as sorted input, nonnegative edge weights, bounded key ranges, or expected hash behavior. A Big-O bound describes growth; it is not a wall-clock prediction.

## A reliable problem-solving process

1. Define inputs, outputs, constraints, duplicates, and failure behavior.
2. Construct a small example and an edge case.
3. Start with a simple correct baseline.
4. Identify repeated work or an exploitable property such as sorted order or overlapping subproblems.
5. Select a data structure or pattern and state its invariant.
6. Prove progress, correctness, and termination.
7. Analyze time and auxiliary space, including library operations.
8. Implement, trace, and compare against the baseline on small inputs.
9. Explain why the chosen trade-off fits the workload.

## Quick technique guide

| Problem shape | Starting point | Critical assumption |
|---|---|---|
| Membership lookup | Hash set/map | Expected-time assumptions and stable key equality/hash |
| Search/range in ordered data | Binary search or ordered tree | A consistent comparator and maintained order |
| FIFO/LIFO behavior | Queue/deque or stack | The required processing order |
| Unweighted shortest path | BFS | Every edge has equal cost |
| Weighted shortest path | Dijkstra, Bellman–Ford, or A* | Edge weights and heuristic conditions |
| Minimum-cost connection of all vertices | Prim or Kruskal | Undirected weighted graph; objective is total tree weight |
| Overlapping intervals | Sort then merge | Closed/open endpoint convention |
| Contiguous subarray/substring | Sliding window or prefix sums | Monotonicity for the standard variable window |
| Repeated subproblems | Dynamic programming | Complete state and valid recurrence |
| All constraint-satisfying answers | Backtracking | Valid state, exhaustive choices, and safe pruning |

This table is a starting point, not an automatic answer. If an algorithm’s precondition does not hold, account for the conversion cost or choose another method.

## Short glossary

- **Invariant:** A statement that remains true at a defined point in every iteration or recursive state.
- **ADT:** The contract of operations supported by a data type, independent of its implementation.
- **Stable sorting:** Equal-key items retain their original relative order.
- **Amortized analysis:** A bound over a sequence of operations; different from an expected bound over random choices.
- **Relaxation:** Updating a candidate distance or value when a better path/solution is found.
- **Page I/O:** Reading or writing a storage block; a key concern for database indexes.
- **Expected time:** Average over the algorithm’s random choices under stated assumptions; not a worst-case guarantee.

## Capstone project: a small route planner

Model intersections as vertices and roads as directed or undirected weighted edges. Store the network as an adjacency list. Use BFS to minimize the number of roads when all edges count equally; use Dijkstra for nonnegative travel times; optionally add A* with a heuristic that is a valid lower bound. Store parents and reconstruct the path. Include disconnected components, equal-cost routes, zero-weight roads, and an empty graph in your manual cases. Report the contract, graph representation, invariants, complexity, weight assumptions, and trade-offs. The core material is in Chapters 1, 5, and 8.

## Core references

- [Official DSA roadmap](https://roadmap.sh/datastructures-and-algorithms)
- [Official roadmap PDF](https://roadmap.sh/pdfs/roadmaps/datastructures-and-algorithms.pdf)
- [MIT OpenCourseWare 6.006 — Introduction to Algorithms](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/)
- [Princeton Algorithms, 4th edition companion site](https://algs4.cs.princeton.edu/home/)
- [CP-Algorithms](https://cp-algorithms.com/)
- [USACO Guide](https://usaco.guide/)
- [Python data structures documentation](https://docs.python.org/3/tutorial/datastructures.html)
- [C++ standard library reference](https://en.cppreference.com/w/cpp/container.html)
- [Java collections API](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/package-summary.html)
- [Microsoft .NET collections](https://learn.microsoft.com/en-us/dotnet/standard/collections/)
- [Rust standard collections](https://doc.rust-lang.org/std/collections/)
- [Go slices article](https://go.dev/blog/slices-intro)
- [Go memory model](https://go.dev/ref/mem)
- [Persian: Ferdowsi University Data Structures course](https://cs-um.github.io/docs/mandatory/Data-Structures/)
- [Persian: Data Structures and Algorithms course](https://valinejad.ir/courses/data-structures-algorithms/index.html)
- [Persian: Data Structures video course](https://www.konkurcomputer.ir/dade-videos.html)
- [Expanded topic-by-topic bibliography](references.md)
