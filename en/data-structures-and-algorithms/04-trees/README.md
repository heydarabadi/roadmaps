# Chapter 4 — Trees and Heaps

> [Persian chapter](../../../fa/data-structures-and-algorithms/04-trees/README.md) · [Course index](../README.md)

Trees model hierarchy, ordered search, and recursive structure. “Tree” is not a single guarantee: a binary tree limits child count, a BST adds an ordering invariant, a heap exposes an extremum, and a B-tree targets storage pages.

## Choose among the structures

| Need | Starting point | Why |
|---|---|---|
| Hierarchical parent-child data | General or binary tree | Represents relationships and subtrees |
| Ordered lookup and range traversal in memory | Balanced search tree | Maintains sorted order with bounded height |
| Frequent min/max extraction | Binary heap | The extremum is at the root |
| Disk pages and database indexes | B-tree | High fan-out reduces page levels |
| Pre/in/post-order processing | Depth-first traversal | Visit order follows subtree structure |
| Visit the nearest level first | Tree BFS | A FIFO queue preserves level order |

## Roadmap parent lesson: Tree Data Structures

The roadmap groups binary trees, BSTs, AVL/B-trees, heaps, and traversals. Decide first whether you need full ordering, search, range scans, or only an extremum. A plain BST can have height Θ(n); AVL rotations maintain logarithmic height. A heap orders each parent against its children but does not sort every pair of values. B-trees use many separators per node to reduce page reads.

**Self-check**

1. What property distinguishes a BST from a general binary tree? The key-order invariant over each subtree.
2. Which traversal prints BST keys in sorted order? Inorder.
3. Which structure provides the min/max quickly without sorting all keys? A min-heap or max-heap.

## Chapter review quiz

1. **Does inorder sort every binary tree?** Only a BST with a compatible comparator.
2. **Why can an ordinary BST degrade to O(n) operations?** Ordered insertion can create a chain.
3. **How does AVL maintain balance?** It stores height/balance information and performs rotations.
4. **What does a heap guarantee?** Parent-child order, not a globally sorted arrangement.
5. **Which traversal computes children before their parent?** Postorder.
6. **Which traversal finds the minimum number of edges from the root?** Breadth-first search.

## Further reading and references

- [Princeton Algorithms — Binary Search Trees](https://algs4.cs.princeton.edu/32bst/)
- [Princeton Algorithms — Heaps and Priority Queues](https://algs4.cs.princeton.edu/24pq/)
- [MIT 6.006 — Binary Trees, AVL Trees, and Heaps](https://ocw.mit.edu/courses/6-006-introduction-to-algorithms-spring-2020/video_galleries/lecture-videos/)
- [PostgreSQL — B-tree indexes](https://www.postgresql.org/docs/current/btree.html)
- [Full bibliography](../references.md)

## Topic lessons

- [Binary Trees](binary-tree/README.md)
- [Binary Search Trees](bst/README.md)
- [AVL Trees](avl-tree/README.md)
- [B-Trees](b-tree/README.md)
- [Binary Heaps](heap/README.md)
- [Tree Traversal Overview](tree-traversal/README.md)
- [Tree BFS](tree-bfs/README.md)
- [Tree DFS](tree-dfs/README.md)

### Individual traversal lessons

- [Preorder](tree-traversal/preorder/README.md)
- [Inorder](tree-traversal/inorder/README.md)
- [Postorder](tree-traversal/postorder/README.md)

## Mastery standard

Insert and delete keys in a BST, prove its invariant with key ranges, and then build a heap from the same values. Explain why a heap is not suitable for range queries or predecessor/successor searches.
