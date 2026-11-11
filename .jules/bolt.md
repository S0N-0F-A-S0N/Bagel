## 2024-11-11 - [DateFormatter performance]
**Learning:** Instantiating `DateFormatter` repeatedly in table view cells causes significant performance drops in Swift applications due to high initialization cost.
**Action:** Use a static `DateFormatter` instance for recurring formatting operations, like timestamp display in list views.
