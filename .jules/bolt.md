## 2024-03-XX - [Optimize Packet Filtering Loop]
**Learning:** In Swift, combining multiple `.filter` calls on large arrays into a single `.filter` closure significantly reduces sequence iteration overhead and intermediate array allocations.
**Action:** When filtering collections across multiple criteria, use one pass instead of chaining map/filter unnecessarily. Cache repetitive string operations (`lowercased()`, `trimmingCharacters()`) outside the filter block instead of computing them for each element.
