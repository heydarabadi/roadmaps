# فصل ۴ — درخت‌ها و هیپ

> نسخهٔ انگلیسی: [English version](../../../en/data-structures-and-algorithms/04-trees/README.md)

روابط سلسله‌مراتبی، جست‌وجوی مرتب و پیمایش بازگشتی را درک کن.

## ترتیب پیشنهادی

1. پیش‌نیازها و تعریف‌ها را بخوان.
2. مثال هر تاپیک را دستی اجرا کن.
3. تمرین‌ها را انجام بده و بعد پاسخ آزمون را ببین.
4. هنگام پیاده‌سازی، complexity را با operation واقعی کتابخانهٔ زبانت تطبیق بده.

## انتخاب میان درخت‌ها و پیمایش‌ها

درخت دودویی فقط سقف دو فرزند دارد؛ BST علاوه بر آن invariant ترتیب کلید دارد؛ heap فقط رابطهٔ والد/فرزند و ریشهٔ min/max را تضمین می‌کند. AVL ارتفاع BST را متوازن می‌کند. B-tree چندراهه است تا nodeها یک page را پر و ارتفاع I/O را کم کنند. نام «درخت» این ساختارها را معادل نمی‌کند.

| نیاز | انتخاب اولیه | دلیل |
|---|---|---|
| hierarchical data | tree عمومی/binary | parent-child |
| ordered lookup/range در حافظه | BST متوازن | ترتیب و height محدود |
| min/max پرتکرار | binary heap | ریشه مستقیم، update لگاریتمی |
| page storage / database | B-tree | fanout زیاد، I/O کمتر |
| preorder/inorder/postorder | DFS | ترتیب بازدید وابسته به مسئله |
| نزدیک‌ترین سطح | tree BFS | صف و level order |

## تاپیک‌های فصل

- [درخت دودویی](binary-tree/README.md)
- [درخت جست‌وجوی دودویی](bst/README.md)
- [درخت AVL](avl-tree/README.md)
- [درخت B](b-tree/README.md)
- [Heap و صف اولویت](heap/README.md)
- [پیمایش درخت: preorder, inorder, postorder](tree-traversal/README.md)
- [پیمایش سطحی درخت با BFS](tree-bfs/README.md)
- [پیمایش عمقی درخت با DFS](tree-dfs/README.md)

## منبع فارسی فصل

[منبع فارسی پیشنهادی](https://safarnejad.github.io/)

## منبع انگلیسی فصل

[منبع انگلیسی پیشنهادی](https://algs4.cs.princeton.edu/32bst/)


---

## آموزش گره‌های والد در نقشهٔ رسمی

این بخش عنوان‌های گروهی نقشه را نیز پوشش می‌دهد؛ برای درس مستقل هر برگ، README تاپیک را باز کن.

## تاپیک والد نقشه: Tree Data Structures

### آموزش

درخت‌ها روابط پدر/فرزند و مسیرهای سلسله‌مراتبی را نشان می‌دهند. این فصل Binary Tree, BST, AVL, B-tree, Heap و traversalها را پوشش می‌دهد.

**روش انتخاب/اجرا:** اول مشخص کن ساختار باید ترتیب کامل، search، range scan یا فقط min/max را پشتیبانی کند؛ سپس نوع درخت، تعادل و پیمایش را برگزین.

**پیچیدگی و مبادله:** BST نامتوازن می‌تواند O(n) شود؛ AVL ارتفاع لگاریتمی را تضمین می‌کند؛ B-tree تعداد مراجعه به صفحه را کم می‌کند؛ Heap فقط extremum را در ریشه تضمین می‌کند.

**تجربهٔ عملی:** AST، filesystem، ایندکس B-tree پایگاه داده، سلسله‌مراتب سازمانی و صف اولویت.

**دام رایج:** همهٔ درخت‌ها BST نیستند؛ heap مرتب کامل نیست؛ توازن و invariants هر نوع را جدا بفهم.

### آزمون کوتاه با پاسخ

1. **پرسش:** چه چیزی BST را از درخت دودویی عمومی جدا می‌کند؟
   **پاسخ:** ناوردای ترتیب کلیدها نسبت به هر گره.
2. **پرسش:** کدام پیمایش BST را مرتب چاپ می‌کند؟
   **پاسخ:** In-order.
3. **پرسش:** برای min/max سریع بدون جست‌وجوی مرتب کامل چه ساختاری مناسب است؟
   **پاسخ:** Min/Max Heap.


## زیرتاپیک‌های جداگانهٔ پیمایش

- [In-order Traversal](tree-traversal/inorder/README.md)
- [Pre-order Traversal](tree-traversal/preorder/README.md)
- [Post-order Traversal](tree-traversal/postorder/README.md)


## آزمون جمع‌بندی فصل

۱. آیا inorder هر binary tree را مرتب می‌کند؟ فقط BST با comparator سازگار. ۲. چرا BST معمولی می‌تواند O(n) شود؟ درج مرتب آن را skew می‌کند. ۳. AVL با چه چیزی balance را نگه می‌دارد؟ factor ارتفاع و rotation. ۴. heap چه تضمینی دربارهٔ دو فرزند دارد؟ فقط parent/child order، نه مرتب‌بودن کامل. ۵. برای محاسبهٔ نتیجهٔ زیر‌درخت قبل از والد کدام traversal؟ postorder. ۶. برای کمترین تعداد یال از ریشه؟ BFS.

## معیار عبور

یک BST را درج/حذف کن، invariant آن را با بازهٔ مجاز ثابت کن، سپس همان داده را به min-heap تبدیل کن و توضیح بده چرا heap برای range query و successor مناسب نیست.

