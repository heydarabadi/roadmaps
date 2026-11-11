# Data Structures and Algorithms: Curated References (English)

This is a deliberately curated reading list for the lessons in this course. It gathers university lectures, textbooks and open course notes, algorithm references, official language documentation, and primary database or protocol documentation. It is not a claim to have read every page on the internet. Each topic lesson also has a short list of sources chosen for that topic; use this index when you want a broader path or a deeper source.

Prefer this sequence when you use an external source: read the matching local lesson first, consult the reference to compare definitions or implementation details, then solve a problem without looking at its solution. Course pages and documentation can change; version-specific pages are labeled where relevant.

## Roadmap and complete courses

- [Roadmap.sh: Data Structures and Algorithms](https://roadmap.sh/datastructures-and-algorithms) — interactive topic map used to organize this course.
- [Roadmap.sh: official DSA roadmap PDF](https://roadmap.sh/pdfs/roadmaps/datastructures-and-algorithms.pdf) — printable snapshot with the expanded language choices.
- [MIT OpenCourseWare 6.006: Introduction to Algorithms (Spring 2020)](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/) — lectures, notes, problem sets, quizzes, and solutions across data structures, sorting, graphs, shortest paths, and dynamic programming.
- [MIT 6.006 lecture video gallery](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-videos/) — lecture-by-lecture explanations and worked examples.
- [MIT 6.006 course resource index](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/pages/resource-index/) — organized notes, recitations, problem sessions, and problem sets.
- [MIT OpenCourseWare 6.006: Introduction to Algorithms (Fall 2011)](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-fall-2011/) — a second complete offering with material on AVL trees, hashing, graphs, Dijkstra, Bellman–Ford, and DP.
- [MIT OpenCourseWare 6.046J: Design and Analysis of Algorithms](https://ocw.mit.edu/courses/6-046j-design-and-analysis-of-algorithms-spring-2015/) — more advanced analysis and design techniques after an introductory algorithms course.
- [Princeton Algorithms, 4th Edition companion site](https://algs4.cs.princeton.edu/home/) — free online excerpts, Java implementations, videos, exercises, and programming assignments.
- [OpenDSA: Data Structures and Algorithms](https://opendsa.cs.vt.edu/home/books) — interactive explanations and visualizations, with implementation-oriented chapters.
- [Open Data Structures](https://opendatastructures.org/) — a freely available textbook with pseudocode, proofs, and Java, C++, and Python implementations.
- [NIST Dictionary of Algorithms and Data Structures (DADS)](https://xlinux.nist.gov/dads/) — concise definitions and cross-references for algorithms, structures, and analysis terms.
- [CP-Algorithms](https://cp-algorithms.com/) — detailed implementation-oriented articles on common algorithms and competitive-programming techniques.
- [USACO Guide](https://usaco.guide/) — a structured, practice-oriented guide that develops topics from fundamentals through advanced techniques.
- [VisuAlgo](https://visualgo.net/en) — interactive visualizations useful for tracing state changes in common algorithms and data structures.

## Foundations, complexity, and correctness

- [MIT 6.006 Lecture 1: Introduction](https://live.ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/477c78e0af2df61fa205bcc6cb613ceb_MIT6_006S20_lec1.pdf) — computational models, scaling, and how to describe an algorithm.
- [MIT 6.006 Lecture 20: Course Review](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/aa4f264093faf990054cc4820553bb46_MIT6_006S20_lec20.pdf) — correctness arguments, asymptotics, reductions, and a broad recap.
- [MIT 6.006 syllabus](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2008/pages/syllabus/) — course expectations and a useful model for written algorithm explanations.
- [NIST DADS: Big-O notation](https://xlinux.nist.gov/dads/HTML/bigOnotation.html) — terminology for asymptotic analysis.
- [NIST DADS: algorithm](https://xlinux.nist.gov/dads/HTML/algorithm.html) — a compact definition and related terms.
- [Princeton Algorithms: Fundamentals](https://algs4.cs.princeton.edu/10fundamentals/) — programming model, analysis, and foundational tools.

## Arrays, lists, stacks, queues, and hash tables

- [MIT 6.006 Lecture 2: Data Structures and Dynamic Arrays](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-2-data-structures-and-dynamic-arrays/) — dynamic arrays, amortized resizing, and elementary structures.
- [Princeton Algorithms: Searching and symbol tables](https://algs4.cs.princeton.edu/30search/) — search abstractions, symbol tables, and implementation trade-offs.
- [CP-Algorithms: Disjoint Set Union](https://cp-algorithms.com/data_structures/disjoint_set_union.html) — also a clear case study in amortized analysis and path compression.
- [Python tutorial: Data Structures](https://docs.python.org/3/tutorial/datastructures.html) — lists, stacks, queues with `deque`, and sets/dictionaries.
- [C++ reference: Containers library](https://en.cppreference.com/w/cpp/container.html) — standard sequence, associative, and unordered containers.
- [Java 21 API: `java.util`](https://docs.oracle.com/en/java/javase/21/docs/api/java.base/java/util/package-summary.html) — collection interfaces and implementations.
- [Microsoft Learn: .NET collections](https://learn.microsoft.com/en-us/dotnet/standard/collections/) — choosing and using standard collection types.
- [Go blog: Arrays, slices, and strings](https://go.dev/blog/slices-intro) — how Go slices relate to backing arrays and capacity.
- [Rust standard library: Collections](https://doc.rust-lang.org/std/collections/) — `Vec`, `HashMap`, `BTreeMap`, queues, and collection guarantees.
- [MDN: JavaScript Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array) — the JavaScript array API and its semantics.
- [MDN: JavaScript Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map) — key/value maps and their contract.
- [Ruby: `Array`](https://docs.ruby-lang.org/en/master/Array.html) and [Ruby: `Hash`](https://docs.ruby-lang.org/en/master/Hash.html) — official core collection references.

## Searching and sorting

- [Princeton Algorithms: Sorting](https://algs4.cs.princeton.edu/20sorting/) — comparison sorts, heapsort, mergesort, quicksort, stability, and performance.
- [MIT 6.006 Lecture 3: Sets and Sorting](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-3-sets-and-sorting/) — sorting and set-oriented problem framing.
- [CP-Algorithms: Binary Search](https://cp-algorithms.com/num_methods/binary_search.html) — invariants, boundary searches, and common implementation errors.
- [CP-Algorithms: Sorting](https://cp-algorithms.com/sorting.html) — reference implementations and comparisons for common sorts.
- [NIST DADS: binary search](https://xlinux.nist.gov/dads/HTML/binarySearch.html) — concise definition and links to related terms.
- [Princeton Algorithms: priority queues](https://algs4.cs.princeton.edu/24pq/) — heaps, priority queues, and heapsort.
- [MIT 6.006 Lecture 8: Binary Heaps](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-8-binary-heaps/) — heap operations and their role in algorithms.

## Trees, tries, and range-query structures

- [Princeton Algorithms: Search trees](https://algs4.cs.princeton.edu/32bst/) — binary search trees and ordered operations.
- [MIT 6.006 Lecture 7: AVL Trees](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-7-binary-trees-part-2-avl/) — rotations and height balancing.
- [Open Data Structures: Binary trees](https://opendatastructures.org/ods-python/6_Binary_Trees.html) — structural properties and traversal.
- [CP-Algorithms: Segment Tree](https://cp-algorithms.com/data_structures/segment_tree.html) — range aggregation, updates, and variants.
- [CP-Algorithms: Fenwick Tree](https://cp-algorithms.com/data_structures/fenwick.html) — prefix aggregates and point updates.
- [CP-Algorithms: Trie](https://cp-algorithms.com/string/tries.html) — prefix trees and string-key lookup.
- [CP-Algorithms: Suffix Array](https://cp-algorithms.com/string/suffix-array.html) — construction, LCP, and substring-query applications.
- [MIT 6.006 Lecture 9: Breadth-First Search](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-9-breadth-first-search/) — queue-based exploration and layers.
- [MIT 6.006 Lecture 10: Depth-First Search](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-10-depth-first-search/) — recursion/stack exploration and graph structure.

## Graphs, shortest paths, and spanning trees

- [Princeton Algorithms: Graphs](https://algs4.cs.princeton.edu/40graphs/) — representations, traversal, connectivity, and applications.
- [Princeton Algorithms: Minimum spanning trees](https://algs4.cs.princeton.edu/43mst/) — Prim, Kruskal, and cut-based reasoning.
- [Princeton Algorithms: Shortest paths](https://algs4.cs.princeton.edu/44sp/) — shortest-path models and algorithm implementations.
- [CP-Algorithms: Breadth-first search](https://cp-algorithms.com/graph/breadth-first-search.html) — unweighted shortest paths and BFS properties.
- [CP-Algorithms: Dijkstra](https://cp-algorithms.com/graph/dijkstra.html) — nonnegative-weight shortest paths and priority queues.
- [CP-Algorithms: Bellman–Ford](https://cp-algorithms.com/graph/bellman_ford.html) — negative edges and negative-cycle detection.
- [CP-Algorithms: Kruskal](https://cp-algorithms.com/graph/mst_kruskal.html) and [Prim](https://cp-algorithms.com/graph/mst_prim.html) — two MST construction strategies.
- [MIT 6.006 Lecture 13: Dijkstra’s Algorithm](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/lecture-13-dijkstras-algorithm/) — shortest paths, relaxation, and implementation details.
- [RFC 2328: OSPF Version 2](https://www.rfc-editor.org/rfc/rfc2328) — a primary protocol document that specifies link-state routing and shortest-path-tree computation.
- [Hart, Nilsson, and Raphael: A Formal Basis for the Heuristic Determination of Minimum Cost Paths (1968)](https://doi.org/10.1109/TSSC.1968.300136) — original A* paper.

## Problem-solving paradigms

- [MIT 6.006 Lecture 16: Dynamic Programming](https://live.ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/28461a74f81101874a13d9679a40584d_MIT6_006S20_lec16.pdf) — subproblems, recurrences, and reconstruction.
- [MIT 6.006 Recitation 15: Dynamic Programming](https://live.ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/6022dc36557c5e5df2ad0a77e9463855_MIT6_006S20_r15.pdf) — worked examples and practice.
- [MIT 6.006 calendar: dynamic programming sessions](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2008/pages/calendar/) — topic sequence from memoization through knapsack and structural DP.
- [Stanford CS106B: Backtracking](https://see.stanford.edu/Course/CS106B/149) — recursion trees, choices, and undoing state.
- [Stanford CS106B: Recursion and backtracking examples (PDF)](https://see.stanford.edu/materials/icspacs106b/H19-RecBacktrackExamples.pdf) — worked recursion and constraint-search examples.
- [CP-Algorithms: Divide and conquer DP optimization](https://cp-algorithms.com/dynamic_programming/divide-and-conquer-dp.html) — a specialized optimization and its preconditions.
- [USACO Guide: Two Pointers](https://usaco.guide/silver/two-pointers) — recognizing and implementing monotone pointer scans.
- [UT Austin: Randomized Algorithms lecture notes](https://www.cs.utexas.edu/~ecprice/courses/randomized/fa15/notes/lec1.pdf) — randomized algorithm basics and analysis.
- [Cornell: Randomized Algorithms lecture notes](https://people.orie.cornell.edu/vc333/orie5270/lectures/04/) — probability tools and expected-time reasoning.
- [MIT 6.046J: Design and Analysis of Algorithms](https://ocw.mit.edu/courses/6-046j-design-and-analysis-of-algorithms-spring-2015/) — advanced design, analysis, and parallel algorithm topics.
- [MIT CSAIL: Parallel Algorithms course materials](https://people.csail.mit.edu/ghaffari/PA26/) — work/span and parallel algorithm design.

## Real systems: indexes and storage

- [PostgreSQL 18: Index Types](https://www.postgresql.org/docs/current/indexes-types.html) — when PostgreSQL uses B-tree, hash, GiST, GIN, BRIN, and related indexes.
- [PostgreSQL 18: B-tree indexes](https://www.postgresql.org/docs/current/btree.html) — implementation and ordering behavior of PostgreSQL B-tree indexes.
- [SQLite: Database File Format](https://www.sqlite.org/fileformat.html) — page layout and the B-trees used to store tables and indexes.
- [MySQL 8.4: InnoDB Index Types](https://dev.mysql.com/doc/refman/8.4/en/innodb-index-types.html) — clustered and secondary index behavior in InnoDB.
- [RocksDB: Block-Based Table Format](https://github.com/facebook/rocksdb/wiki/Block-Based-Table-Format) — practical storage blocks, indexes, and filters in an LSM-tree based key-value engine.
- [Redis: Sorted Sets](https://redis.io/docs/latest/develop/data-types/sorted-sets/) — an ordered collection exposed as a production data type.

## Practice platforms and problem sets

- [LeetCode problem set](https://leetcode.com/problemset/) — searchable coding problems by topic and difficulty.
- [LeetCode Explore](https://leetcode.com/explore/) — guided topic tracks and structured practice.
- [LeetCode: How to use Explore](https://support.leetcode.com/hc/en-us/articles/360013578114-How-to-use-Explore) — official platform guidance.
- [Edabit](https://edabit.com/challenges) — short programming exercises for syntax fluency and basic problem decomposition.
- [MIT 6.006 problem sets and solutions](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/resources/problem-sets/) — deeper exercises paired with the course.
- [Princeton Algorithms programming assignments](https://algs4.cs.princeton.edu/code/) — implementation-focused assignments and supporting code.

## Suggested reference workflow

1. Use the local lesson to learn the invariant and work through its example.
2. Read one university or textbook source for a proof-oriented explanation.
3. Read one implementation reference for edge cases and language/API details.
4. Compare at least two implementations only after writing your own.
5. For an application claim, prefer primary material such as a standard, official protocol specification, or database documentation.

